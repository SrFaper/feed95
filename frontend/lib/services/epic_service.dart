import 'dart:convert';
import 'package:http/http.dart' as http;

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
  final String generos;

  EpicDetalle({
    required this.nombre,
    required this.descripcion,
    required this.portada,
    required this.generos,
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
      final portadaMap = images.firstWhere(
        (img) => img['type'] == 'OfferImageTall',
        orElse: () => images.isNotEmpty ? images.first : {},
      );

      final tags = (offer['tags'] as List? ?? [])
          .map((t) => t['name'] as String? ?? '')
          .where((t) => t.isNotEmpty)
          .take(5)
          .join(', ');

      final descripcionRaw = offer['description'] as String? ?? '';
      final descripcion = descripcionRaw
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .trim();

      return EpicDetalle(
        nombre: offer['title'] as String? ?? '',
        descripcion: descripcion,
        portada: portadaMap['url'] as String? ?? '',
        generos: tags,
      );
    } catch (_) {
      return null;
    }
  }
}
