import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class EpicResultado {
  final String id;
  final String namespace;
  final String nombre;
  final String portada;

  EpicResultado({
    required this.id,
    required this.namespace,
    required this.nombre,
    required this.portada,
  });
}

class EpicDetalle {
  final String nombre;
  final String descripcion;
  final String portada;
  final String portadaGrid;
  final String generos;
  final String imagenesExtra;

  EpicDetalle({
    required this.nombre,
    required this.descripcion,
    required this.portada,
    required this.portadaGrid,
    required this.generos,
    required this.imagenesExtra,
  });
}

class EpicService {
  static Future<List<EpicResultado>> buscar(String query) async {
    try {
      final queryLimpia = query.replaceAll('"', ''); // ← agrega esto
      final searchUri = Uri.parse('https://store.epicgames.com/graphql');
      final graphqlQuery =
          '''
    {
      Catalog {
        searchStore(
          keywords: "$queryLimpia"
          count: 10
          category: "games/edition/base"
        ) {
          elements {
            id
            namespace
            title
            keyImages {
              type
              url
            }
          }
        }
      }
    }
    ''';

      final response = await http
          .post(
            searchUri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'query': graphqlQuery}),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final elements =
          data['data']?['Catalog']?['searchStore']?['elements'] as List? ?? [];

      return elements
          .map((e) {
            final images = e['keyImages'] as List? ?? [];
            final portadaMap = images.firstWhere(
              (img) => img['type'] == 'OfferImageTall',
              orElse: () => images.isNotEmpty ? images.first : {},
            );
            return EpicResultado(
              id: e['id'] as String? ?? '',
              namespace: e['namespace'] as String? ?? '',
              nombre: e['title'] as String? ?? '',
              portada: portadaMap['url'] as String? ?? '',
            );
          })
          .where((r) => r.nombre.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<EpicDetalle?> obtenerDetalle(
    String id,
    String namespace,
  ) async {
    try {
      final uri = Uri.parse('https://store.epicgames.com/graphql');

      final graphqlQuery =
          '''
    {
      Catalog {
        catalogOffer(
          namespace: "$namespace"
          id: "$id"
        ) {
          title
          description
          keyImages {
            type
            url
          }
          categories {
            path
          }
          tags {
            name
          }
          catalogNs {
            mappings(pageType: "productHome") {
              pageSlug
              pageType
            }
          }
        }
      }
    }
    ''';

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'query': graphqlQuery}),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final offer = data['data']?['Catalog']?['catalogOffer'];
      if (offer == null) return null;
      final images = offer['keyImages'] as List? ?? [];
      final mappings = offer['catalogNs']?['mappings'] as List? ?? [];
      final tags = (offer['tags'] as List? ?? [])
          .map((t) => t['name'] as String? ?? '')
          .where((t) => t.isNotEmpty)
          .take(5)
          .join(', ');
      final descripcionRaw = offer['description'] as String? ?? '';
      final descripcion = descripcionRaw
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .trim();
      final portadaGrid =
          (images.firstWhere(
                (img) => img['type'] == 'OfferImageTall',
                orElse: () => images.isNotEmpty ? images.first : {},
              )['url']
              as String?) ??
          '';
      final portada =
          (images.firstWhere(
                (img) =>
                    img['type'] == 'OfferImageWide' ||
                    img['type'] == 'DieselGameBoxWide',
                orElse: () => images.isNotEmpty ? images.first : {},
              )['url']
              as String?) ??
          '';

      // Obtener screenshots desde el storefront usando el pageSlug
      String imagenesExtra = images
          .where((img) => img['type'] == 'featuredMedia')
          .take(10)
          .map((img) => img['url'] as String? ?? '')
          .where((u) => u.isNotEmpty)
          .join(',');

      try {
        final slug = mappings.isNotEmpty
            ? mappings.first['pageSlug'] as String? ?? ''
            : '';

        if (slug.isNotEmpty) {
          final screenshotUri = Uri.parse(
            'https://store-content.ak.epicgames.com/api/en-US/content/products/$slug',
          );

          final screenshotResponse = await http.get(screenshotUri);

          if (screenshotResponse.statusCode == 200) {
            final screenshotData = jsonDecode(screenshotResponse.body);

            final pages = screenshotData['pages'];

            if (pages is List && pages.isNotEmpty) {
              final firstPage = pages.first as Map<String, dynamic>;

              final pageData = firstPage['data'] as Map<String, dynamic>?;

              if (pageData != null && imagenesExtra.isEmpty) {
                final carousel = pageData['carousel'];

                if (carousel != null) {
                  final items = carousel['items'] as List? ?? [];

                  final urls = items
                      .map((item) => item['image']?['src'] as String? ?? '')
                      .where((url) => url.isNotEmpty)
                      .take(10)
                      .toList();

                  if (urls.isNotEmpty) {
                    imagenesExtra = urls.join(',');
                  }
                }
              }
            }
          }
        }
      } catch (e) {
        debugPrint('SLUG ERROR: $e');
      }

      return EpicDetalle(
        nombre: offer['title'] as String? ?? '',
        descripcion: descripcion,
        portada: portada,
        portadaGrid: portadaGrid,
        generos: tags,
        imagenesExtra: imagenesExtra,
      );
    } catch (_) {
      return null;
    }
  }
}
