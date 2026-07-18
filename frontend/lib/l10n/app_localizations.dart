import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Feed95'**
  String get appTitle;

  /// No description provided for @btnCancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get btnCancelar;

  /// No description provided for @btnGuardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get btnGuardar;

  /// No description provided for @btnEliminar.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get btnEliminar;

  /// No description provided for @btnEditar.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get btnEditar;

  /// No description provided for @btnAceptar.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get btnAceptar;

  /// No description provided for @btnEnter.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get btnEnter;

  /// No description provided for @btnImportar.
  ///
  /// In es, this message translates to:
  /// **'Importar'**
  String get btnImportar;

  /// No description provided for @btnConfigurar.
  ///
  /// In es, this message translates to:
  /// **'Configurar'**
  String get btnConfigurar;

  /// No description provided for @btnCrearPerfil.
  ///
  /// In es, this message translates to:
  /// **'Crear perfil'**
  String get btnCrearPerfil;

  /// No description provided for @btnNuevoPerfil.
  ///
  /// In es, this message translates to:
  /// **'Nuevo perfil'**
  String get btnNuevoPerfil;

  /// No description provided for @loginSinCuenta.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta? Créala aquí'**
  String get loginSinCuenta;

  /// No description provided for @estadoPendiente.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get estadoPendiente;

  /// No description provided for @estadoJugando.
  ///
  /// In es, this message translates to:
  /// **'Jugando'**
  String get estadoJugando;

  /// No description provided for @estadoCompletado.
  ///
  /// In es, this message translates to:
  /// **'Completado'**
  String get estadoCompletado;

  /// No description provided for @estadoAbandonado.
  ///
  /// In es, this message translates to:
  /// **'Abandonado'**
  String get estadoAbandonado;

  /// No description provided for @splashCargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get splashCargando;

  /// No description provided for @homeTitle.
  ///
  /// In es, this message translates to:
  /// **'Feed95'**
  String get homeTitle;

  /// No description provided for @homeBienvenido.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido, {nombre}'**
  String homeBienvenido(String nombre);

  /// No description provided for @homeMiCatalogo.
  ///
  /// In es, this message translates to:
  /// **'Mi catálogo'**
  String get homeMiCatalogo;

  /// No description provided for @homeStatJuegos.
  ///
  /// In es, this message translates to:
  /// **'Juegos'**
  String get homeStatJuegos;

  /// No description provided for @homeStatCompletados.
  ///
  /// In es, this message translates to:
  /// **'Completados'**
  String get homeStatCompletados;

  /// No description provided for @homeStatJugando.
  ///
  /// In es, this message translates to:
  /// **'Jugando'**
  String get homeStatJugando;

  /// No description provided for @homeTooltipCambiarTema.
  ///
  /// In es, this message translates to:
  /// **'Cambiar tema'**
  String get homeTooltipCambiarTema;

  /// No description provided for @homeTooltipCambiarPerfil.
  ///
  /// In es, this message translates to:
  /// **'Cambiar perfil'**
  String get homeTooltipCambiarPerfil;

  /// No description provided for @homeTooltipCerrarSesion.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get homeTooltipCerrarSesion;

  /// No description provided for @homeEditarPerfil.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get homeEditarPerfil;

  /// No description provided for @homeModoExtendidoActivado.
  ///
  /// In es, this message translates to:
  /// **'Modo extendido activado'**
  String get homeModoExtendidoActivado;

  /// No description provided for @homeModoExtendidoDesactivado.
  ///
  /// In es, this message translates to:
  /// **'Modo extendido desactivado'**
  String get homeModoExtendidoDesactivado;

  /// No description provided for @homeConfiguraciones.
  ///
  /// In es, this message translates to:
  /// **'Configuraciones y Backup'**
  String get homeConfiguraciones;

  /// No description provided for @homeSeccionConfiguraciones.
  ///
  /// In es, this message translates to:
  /// **'CONFIGURACIONES'**
  String get homeSeccionConfiguraciones;

  /// No description provided for @homeSeccionSistema.
  ///
  /// In es, this message translates to:
  /// **'SISTEMA'**
  String get homeSeccionSistema;

  /// No description provided for @homeConfigurarIGDB.
  ///
  /// In es, this message translates to:
  /// **'Configurar IGDB'**
  String get homeConfigurarIGDB;

  /// No description provided for @homeConfigurarF95.
  ///
  /// In es, this message translates to:
  /// **'Configurar F95Zone'**
  String get homeConfigurarF95;

  /// No description provided for @homeExportarCopia.
  ///
  /// In es, this message translates to:
  /// **'Exportar copia'**
  String get homeExportarCopia;

  /// No description provided for @homeImportarCopia.
  ///
  /// In es, this message translates to:
  /// **'Importar copia'**
  String get homeImportarCopia;

  /// No description provided for @homeErrorExportar.
  ///
  /// In es, this message translates to:
  /// **'Error al exportar: {error}'**
  String homeErrorExportar(String error);

  /// No description provided for @homeErrorImportar.
  ///
  /// In es, this message translates to:
  /// **'Error al importar: {error}'**
  String homeErrorImportar(String error);

  /// No description provided for @homeBackupGuardado.
  ///
  /// In es, this message translates to:
  /// **'Backup guardado en {ruta}'**
  String homeBackupGuardado(String ruta);

  /// No description provided for @homeBackupNoDisponibleWeb.
  ///
  /// In es, this message translates to:
  /// **'Exportar backup no está disponible en Web'**
  String get homeBackupNoDisponibleWeb;

  /// No description provided for @homeImportarNoDisponibleWeb.
  ///
  /// In es, this message translates to:
  /// **'Importar backup no está disponible en Web'**
  String get homeImportarNoDisponibleWeb;

  /// No description provided for @homeDialogoImportarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Importar backup'**
  String get homeDialogoImportarTitulo;

  /// No description provided for @homeDialogoImportarContenido.
  ///
  /// In es, this message translates to:
  /// **'Se agregarán los perfiles y juegos del backup. Los perfiles con el mismo nombre serán omitidos.'**
  String get homeDialogoImportarContenido;

  /// No description provided for @homeGuardarBackupEn.
  ///
  /// In es, this message translates to:
  /// **'Guardar backup en...'**
  String get homeGuardarBackupEn;

  /// No description provided for @perfilesTitulo.
  ///
  /// In es, this message translates to:
  /// **'Feed95 — Perfiles'**
  String get perfilesTitulo;

  /// No description provided for @perfilesVacio.
  ///
  /// In es, this message translates to:
  /// **'No hay perfiles todavía'**
  String get perfilesVacio;

  /// No description provided for @perfilesEliminarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Eliminar perfil'**
  String get perfilesEliminarTitulo;

  /// No description provided for @perfilesEliminarContenido.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar a {nombre}? Se borrarán todos sus juegos.'**
  String perfilesEliminarContenido(String nombre);

  /// No description provided for @perfilesPasswordIncorrecta.
  ///
  /// In es, this message translates to:
  /// **'Contraseña incorrecta'**
  String get perfilesPasswordIncorrecta;

  /// No description provided for @perfilesInputPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get perfilesInputPassword;

  /// No description provided for @registroTitulo.
  ///
  /// In es, this message translates to:
  /// **'Nuevo perfil'**
  String get registroTitulo;

  /// No description provided for @registroUsuario.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get registroUsuario;

  /// No description provided for @registroUsarPassword.
  ///
  /// In es, this message translates to:
  /// **'Proteger con contraseña'**
  String get registroUsarPassword;

  /// No description provided for @registroAgregarImagen.
  ///
  /// In es, this message translates to:
  /// **'Agregar imagen'**
  String get registroAgregarImagen;

  /// No description provided for @registroPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get registroPassword;

  /// No description provided for @registroRepetirPassword.
  ///
  /// In es, this message translates to:
  /// **'Repetir contraseña'**
  String get registroRepetirPassword;

  /// No description provided for @registroColorPerfil.
  ///
  /// In es, this message translates to:
  /// **'Color del perfil'**
  String get registroColorPerfil;

  /// No description provided for @registroTocaColor.
  ///
  /// In es, this message translates to:
  /// **'Toca para elegir un color'**
  String get registroTocaColor;

  /// No description provided for @registroElegirColor.
  ///
  /// In es, this message translates to:
  /// **'Elige un color'**
  String get registroElegirColor;

  /// No description provided for @registroCamposObligatorios.
  ///
  /// In es, this message translates to:
  /// **'Complete todos los campos'**
  String get registroCamposObligatorios;

  /// No description provided for @registroPasswordsNoCoinciden.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get registroPasswordsNoCoinciden;

  /// No description provided for @registroColorAplicar.
  ///
  /// In es, this message translates to:
  /// **'Aplicar'**
  String get registroColorAplicar;

  /// No description provided for @perfilTitulo.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get perfilTitulo;

  /// No description provided for @perfilCambiarImagen.
  ///
  /// In es, this message translates to:
  /// **'Cambiar imagen'**
  String get perfilCambiarImagen;

  /// No description provided for @perfilQuitarImagen.
  ///
  /// In es, this message translates to:
  /// **'Quitar'**
  String get perfilQuitarImagen;

  /// No description provided for @perfilNuevaPassword.
  ///
  /// In es, this message translates to:
  /// **'Nueva contraseña'**
  String get perfilNuevaPassword;

  /// No description provided for @perfilNuevaPasswordHint.
  ///
  /// In es, this message translates to:
  /// **'Dejar vacío para no cambiar'**
  String get perfilNuevaPasswordHint;

  /// No description provided for @perfilRepetirNuevaPassword.
  ///
  /// In es, this message translates to:
  /// **'Repetir nueva contraseña'**
  String get perfilRepetirNuevaPassword;

  /// No description provided for @perfilColorTitulo.
  ///
  /// In es, this message translates to:
  /// **'Color del perfil'**
  String get perfilColorTitulo;

  /// No description provided for @perfilColorTocar.
  ///
  /// In es, this message translates to:
  /// **'Toca para cambiar el color'**
  String get perfilColorTocar;

  /// No description provided for @perfilGuardarCambios.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get perfilGuardarCambios;

  /// No description provided for @perfilNombreVacio.
  ///
  /// In es, this message translates to:
  /// **'El nombre no puede estar vacío'**
  String get perfilNombreVacio;

  /// No description provided for @perfilActualizado.
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado correctamente'**
  String get perfilActualizado;

  /// No description provided for @perfilesEliminarConfirmarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Confirmar eliminación'**
  String get perfilesEliminarConfirmarTitulo;

  /// No description provided for @catalogoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Mi catálogo'**
  String get catalogoTitulo;

  /// No description provided for @catalogoSecundarioNombre.
  ///
  /// In es, this message translates to:
  /// **'NSFW'**
  String get catalogoSecundarioNombre;

  /// No description provided for @catalogoVacio.
  ///
  /// In es, this message translates to:
  /// **'No hay juegos en este catálogo'**
  String get catalogoVacio;

  /// No description provided for @catalogoVacioFiltros.
  ///
  /// In es, this message translates to:
  /// **'No hay juegos con esos filtros'**
  String get catalogoVacioFiltros;

  /// No description provided for @catalogoReordenarVacio.
  ///
  /// In es, this message translates to:
  /// **'No hay juegos para reordenar'**
  String get catalogoReordenarVacio;

  /// No description provided for @catalogoBuscar.
  ///
  /// In es, this message translates to:
  /// **'Buscar...'**
  String get catalogoBuscar;

  /// No description provided for @catalogoTooltipFiltros.
  ///
  /// In es, this message translates to:
  /// **'Filtros y categorías'**
  String get catalogoTooltipFiltros;

  /// No description provided for @catalogoTooltipReordenar.
  ///
  /// In es, this message translates to:
  /// **'Reordenar'**
  String get catalogoTooltipReordenar;

  /// No description provided for @catalogoTooltipVerCatalogo.
  ///
  /// In es, this message translates to:
  /// **'Ver catálogo'**
  String get catalogoTooltipVerCatalogo;

  /// No description provided for @catalogoTooltipVistaLista.
  ///
  /// In es, this message translates to:
  /// **'Vista lista'**
  String get catalogoTooltipVistaLista;

  /// No description provided for @catalogoTooltipVistaGrid.
  ///
  /// In es, this message translates to:
  /// **'Vista cuadrícula'**
  String get catalogoTooltipVistaGrid;

  /// No description provided for @catalogoTooltipCatalogoSecundario.
  ///
  /// In es, this message translates to:
  /// **'Ir a {nombre}'**
  String catalogoTooltipCatalogoSecundario(String nombre);

  /// No description provided for @catalogoTooltipCatalogoPrincipal.
  ///
  /// In es, this message translates to:
  /// **'Ir al catálogo principal'**
  String get catalogoTooltipCatalogoPrincipal;

  /// No description provided for @catalogoSeccionEstado.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get catalogoSeccionEstado;

  /// No description provided for @catalogoSeccionCategorias.
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get catalogoSeccionCategorias;

  /// No description provided for @catalogoFiltroTodos.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get catalogoFiltroTodos;

  /// No description provided for @catalogoFiltroTodas.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get catalogoFiltroTodas;

  /// No description provided for @catalogoAsignarCategoria.
  ///
  /// In es, this message translates to:
  /// **'Asignar categoría'**
  String get catalogoAsignarCategoria;

  /// No description provided for @catalogoSinCategoria.
  ///
  /// In es, this message translates to:
  /// **'Sin categoría'**
  String get catalogoSinCategoria;

  /// No description provided for @catalogoTooltipDensidad.
  ///
  /// In es, this message translates to:
  /// **'Tamaño de las tarjetas'**
  String get catalogoTooltipDensidad;

  /// No description provided for @catalogoDensidadTitulo.
  ///
  /// In es, this message translates to:
  /// **'VISTA DEL CATÁLOGO'**
  String get catalogoDensidadTitulo;

  /// No description provided for @catalogoDensidadSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Tarjetas más chicas = más juegos visibles a la vez'**
  String get catalogoDensidadSubtitulo;

  /// No description provided for @catalogoDensidadGrande.
  ///
  /// In es, this message translates to:
  /// **'Grande'**
  String get catalogoDensidadGrande;

  /// No description provided for @catalogoDensidadCompacta.
  ///
  /// In es, this message translates to:
  /// **'Compacta'**
  String get catalogoDensidadCompacta;

  /// No description provided for @catalogoDensidadLista.
  ///
  /// In es, this message translates to:
  /// **'Lista'**
  String get catalogoDensidadLista;

  /// No description provided for @categoriaNuevaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Nueva categoría'**
  String get categoriaNuevaTitulo;

  /// No description provided for @categoriaEditarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Editar categoría'**
  String get categoriaEditarTitulo;

  /// No description provided for @categoriaNombreLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get categoriaNombreLabel;

  /// No description provided for @categoriaEliminarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Eliminar categoría'**
  String get categoriaEliminarTitulo;

  /// No description provided for @categoriaEliminarContenido.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar \"{nombre}\"? Los juegos perderán esta categoría.'**
  String categoriaEliminarContenido(String nombre);

  /// No description provided for @juegoDetalleTitulo.
  ///
  /// In es, this message translates to:
  /// **'Detalle'**
  String get juegoDetalleTitulo;

  /// No description provided for @juegoDetalleDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get juegoDetalleDescripcion;

  /// No description provided for @juegoDetalleImagenes.
  ///
  /// In es, this message translates to:
  /// **'Imágenes'**
  String get juegoDetalleImagenes;

  /// No description provided for @juegoDetalleJugar.
  ///
  /// In es, this message translates to:
  /// **'Jugar'**
  String get juegoDetalleJugar;

  /// No description provided for @juegoDetalleEliminarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Eliminar juego'**
  String get juegoDetalleEliminarTitulo;

  /// No description provided for @juegoDetalleEliminarContenido.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar \"{nombre}\"? Esta acción no se puede deshacer.'**
  String juegoDetalleEliminarContenido(String nombre);

  /// No description provided for @juegoDetalleErrorEjecutable.
  ///
  /// In es, this message translates to:
  /// **'No se pudo ejecutar: {error}'**
  String juegoDetalleErrorEjecutable(String error);

  /// No description provided for @juegoDetalleTooltipEditar.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get juegoDetalleTooltipEditar;

  /// No description provided for @juegoDetalleTooltipEliminar.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get juegoDetalleTooltipEliminar;

  /// No description provided for @juegoFormNuevoTitulo.
  ///
  /// In es, this message translates to:
  /// **'Nuevo juego'**
  String get juegoFormNuevoTitulo;

  /// No description provided for @juegoFormEditarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Editar juego'**
  String get juegoFormEditarTitulo;

  /// No description provided for @juegoFormNombre.
  ///
  /// In es, this message translates to:
  /// **'Nombre *'**
  String get juegoFormNombre;

  /// No description provided for @juegoFormBuscarEn.
  ///
  /// In es, this message translates to:
  /// **'Buscar en:'**
  String get juegoFormBuscarEn;

  /// No description provided for @juegoFormDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get juegoFormDescripcion;

  /// No description provided for @juegoFormImagenDetalle.
  ///
  /// In es, this message translates to:
  /// **'Imagen del detalle'**
  String get juegoFormImagenDetalle;

  /// No description provided for @juegoFormUrlImagenDetalle.
  ///
  /// In es, this message translates to:
  /// **'URL imagen detalle'**
  String get juegoFormUrlImagenDetalle;

  /// No description provided for @juegoFormImagenGrid.
  ///
  /// In es, this message translates to:
  /// **'Imagen del grid'**
  String get juegoFormImagenGrid;

  /// No description provided for @juegoFormUrlImagenGrid.
  ///
  /// In es, this message translates to:
  /// **'URL imagen grid'**
  String get juegoFormUrlImagenGrid;

  /// No description provided for @juegoFormAjustar.
  ///
  /// In es, this message translates to:
  /// **'Ajustar'**
  String get juegoFormAjustar;

  /// No description provided for @juegoFormVersion.
  ///
  /// In es, this message translates to:
  /// **'Versión'**
  String get juegoFormVersion;

  /// No description provided for @juegoFormCalificacion.
  ///
  /// In es, this message translates to:
  /// **'Calificación (1-10)'**
  String get juegoFormCalificacion;

  /// No description provided for @juegoFormGeneros.
  ///
  /// In es, this message translates to:
  /// **'Géneros'**
  String get juegoFormGeneros;

  /// No description provided for @juegoFormEstado.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get juegoFormEstado;

  /// No description provided for @juegoFormLanzador.
  ///
  /// In es, this message translates to:
  /// **'Lanzador'**
  String get juegoFormLanzador;

  /// No description provided for @juegoFormRutaEjecutable.
  ///
  /// In es, this message translates to:
  /// **'Ruta del ejecutable'**
  String get juegoFormRutaEjecutable;

  /// No description provided for @juegoFormRutaEjecutableHint.
  ///
  /// In es, this message translates to:
  /// **'C:\\juegos\\myjuego.exe'**
  String get juegoFormRutaEjecutableHint;

  /// No description provided for @juegoFormBuscarArchivo.
  ///
  /// In es, this message translates to:
  /// **'Buscar archivo'**
  String get juegoFormBuscarArchivo;

  /// No description provided for @juegoFormQuitarRuta.
  ///
  /// In es, this message translates to:
  /// **'Quitar ruta'**
  String get juegoFormQuitarRuta;

  /// No description provided for @juegoFormBtnGuardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get juegoFormBtnGuardar;

  /// No description provided for @juegoFormBtnActualizar.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get juegoFormBtnActualizar;

  /// No description provided for @juegoFormNombreObligatorio.
  ///
  /// In es, this message translates to:
  /// **'El nombre es obligatorio'**
  String get juegoFormNombreObligatorio;

  /// No description provided for @juegoFormNoBusqueda.
  ///
  /// In es, this message translates to:
  /// **'Escribe un nombre para buscar'**
  String get juegoFormNoBusqueda;

  /// No description provided for @juegoFormSinResultadosSteam.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron resultados en Steam'**
  String get juegoFormSinResultadosSteam;

  /// No description provided for @juegoFormSinResultadosEpic.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron resultados en Epic'**
  String get juegoFormSinResultadosEpic;

  /// No description provided for @juegoFormSinResultadosIgdb.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron resultados en IGDB'**
  String get juegoFormSinResultadosIgdb;

  /// No description provided for @juegoFormSinResultadosF95.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron resultados en F95Zone'**
  String get juegoFormSinResultadosF95;

  /// No description provided for @juegoFormErrorDetalles.
  ///
  /// In es, this message translates to:
  /// **'No se pudieron obtener los detalles'**
  String get juegoFormErrorDetalles;

  /// No description provided for @juegoFormResultadosSteam.
  ///
  /// In es, this message translates to:
  /// **'Resultados en Steam'**
  String get juegoFormResultadosSteam;

  /// No description provided for @juegoFormResultadosEpic.
  ///
  /// In es, this message translates to:
  /// **'Resultados en Epic Games'**
  String get juegoFormResultadosEpic;

  /// No description provided for @juegoFormResultadosIgdb.
  ///
  /// In es, this message translates to:
  /// **'Resultados en IGDB'**
  String get juegoFormResultadosIgdb;

  /// No description provided for @juegoFormResultadosF95.
  ///
  /// In es, this message translates to:
  /// **'Resultados en F95Zone'**
  String get juegoFormResultadosF95;

  /// No description provided for @juegoFormAgregado.
  ///
  /// In es, this message translates to:
  /// **'Juego agregado correctamente'**
  String get juegoFormAgregado;

  /// No description provided for @juegoFormActualizado.
  ///
  /// In es, this message translates to:
  /// **'Juego actualizado correctamente'**
  String get juegoFormActualizado;

  /// No description provided for @juegoFormEliminado.
  ///
  /// In es, this message translates to:
  /// **'Juego eliminado correctamente'**
  String get juegoFormEliminado;

  /// No description provided for @juegoFormGuardarImagenesLocal.
  ///
  /// In es, this message translates to:
  /// **'Guardar imágenes en este dispositivo'**
  String get juegoFormGuardarImagenesLocal;

  /// No description provided for @juegoFormCacheGuardadoOk.
  ///
  /// In es, this message translates to:
  /// **'Imágenes guardadas localmente (WebP)'**
  String get juegoFormCacheGuardadoOk;

  /// No description provided for @juegoFormCacheError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar ninguna imagen localmente'**
  String get juegoFormCacheError;

  /// No description provided for @juegoFormModoNinguno.
  ///
  /// In es, this message translates to:
  /// **'No guardar localmente'**
  String get juegoFormModoNinguno;

  /// No description provided for @juegoFormModoOriginal.
  ///
  /// In es, this message translates to:
  /// **'Guardar tal cual (sin comprimir)'**
  String get juegoFormModoOriginal;

  /// No description provided for @juegoFormModoComprimido.
  ///
  /// In es, this message translates to:
  /// **'Guardar comprimido (JPG)'**
  String get juegoFormModoComprimido;

  /// No description provided for @homeCarpetaImagenes.
  ///
  /// In es, this message translates to:
  /// **'Carpeta de imágenes'**
  String get homeCarpetaImagenes;

  /// No description provided for @homeCarpetaImagenesTitulo.
  ///
  /// In es, this message translates to:
  /// **'Imágenes guardadas localmente'**
  String get homeCarpetaImagenesTitulo;

  /// No description provided for @homeCarpetaImagenesEspacio.
  ///
  /// In es, this message translates to:
  /// **'Espacio usado: {mb} MB'**
  String homeCarpetaImagenesEspacio(String mb);

  /// No description provided for @acercaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get acercaTitulo;

  /// No description provided for @acercaQueEs.
  ///
  /// In es, this message translates to:
  /// **'¿Qué es Feed95?'**
  String get acercaQueEs;

  /// No description provided for @acercaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Catálogo personal de videojuegos. Sin cuentas, sin nube, sin rastreo: todo se guarda localmente en tu dispositivo.'**
  String get acercaDescripcion;

  /// No description provided for @acercaCodigo.
  ///
  /// In es, this message translates to:
  /// **'Código fuente'**
  String get acercaCodigo;

  /// No description provided for @acercaLicencia.
  ///
  /// In es, this message translates to:
  /// **'Licencia'**
  String get acercaLicencia;

  /// No description provided for @acercaLicenciaTexto.
  ///
  /// In es, this message translates to:
  /// **'Distribuido bajo GNU GPL v3.0. Puedes usar, copiar, modificar y distribuir este software, pero cualquier versión derivada debe mantener la misma licencia con el código fuente disponible.'**
  String get acercaLicenciaTexto;

  /// No description provided for @acercaVerLicenciaCompleta.
  ///
  /// In es, this message translates to:
  /// **'Ver licencia completa'**
  String get acercaVerLicenciaCompleta;

  /// No description provided for @acercaFuentesDatos.
  ///
  /// In es, this message translates to:
  /// **'Fuentes de datos'**
  String get acercaFuentesDatos;

  /// No description provided for @acercaFuentesDatosNota.
  ///
  /// In es, this message translates to:
  /// **'Ninguno de estos servicios está afiliado al proyecto. Steam es marca registrada de Valve Corporation.'**
  String get acercaFuentesDatosNota;

  /// No description provided for @acercaCreditos.
  ///
  /// In es, this message translates to:
  /// **'Créditos'**
  String get acercaCreditos;

  /// No description provided for @acercaVerLicenciasPaquetes.
  ///
  /// In es, this message translates to:
  /// **'Ver licencias de paquetes usados'**
  String get acercaVerLicenciasPaquetes;

  /// No description provided for @igdbTitulo.
  ///
  /// In es, this message translates to:
  /// **'IGDB'**
  String get igdbTitulo;

  /// No description provided for @igdbConfiguradoTitulo.
  ///
  /// In es, this message translates to:
  /// **'IGDB configurado'**
  String get igdbConfiguradoTitulo;

  /// No description provided for @igdbConfiguradoDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Las credenciales están guardadas localmente. El botón IGDB está disponible al añadir juegos.'**
  String get igdbConfiguradoDescripcion;

  /// No description provided for @igdbEliminarCredenciales.
  ///
  /// In es, this message translates to:
  /// **'Eliminar credenciales'**
  String get igdbEliminarCredenciales;

  /// No description provided for @igdbConfigurarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Configurar IGDB'**
  String get igdbConfigurarTitulo;

  /// No description provided for @igdbDescripcion.
  ///
  /// In es, this message translates to:
  /// **'IGDB es la base de datos de videojuegos de Twitch. Es gratuita y cubre prácticamente cualquier juego.'**
  String get igdbDescripcion;

  /// No description provided for @igdbInstrucciones.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo obtener credenciales?\n1. Ve a dev.twitch.tv\n2. Inicia sesión con tu cuenta de Twitch\n3. Crea una nueva aplicación (cualquier nombre)\n4. Copia el Client-ID y genera un Client-Secret'**
  String get igdbInstrucciones;

  /// No description provided for @igdbClientId.
  ///
  /// In es, this message translates to:
  /// **'Client-ID'**
  String get igdbClientId;

  /// No description provided for @igdbClientSecret.
  ///
  /// In es, this message translates to:
  /// **'Client-Secret'**
  String get igdbClientSecret;

  /// No description provided for @igdbGuardarVerificar.
  ///
  /// In es, this message translates to:
  /// **'Guardar y verificar'**
  String get igdbGuardarVerificar;

  /// No description provided for @igdbCamposObligatorios.
  ///
  /// In es, this message translates to:
  /// **'Completa ambos campos'**
  String get igdbCamposObligatorios;

  /// No description provided for @igdbCredencialesInvalidas.
  ///
  /// In es, this message translates to:
  /// **'Credenciales inválidas. Verifica tus datos.'**
  String get igdbCredencialesInvalidas;

  /// No description provided for @igdbConfiguradoOk.
  ///
  /// In es, this message translates to:
  /// **'IGDB configurado correctamente'**
  String get igdbConfiguradoOk;

  /// No description provided for @igdbNecesitaConfiguracion.
  ///
  /// In es, this message translates to:
  /// **'Necesitas configurar IGDB primero.'**
  String get igdbNecesitaConfiguracion;

  /// No description provided for @f95Titulo.
  ///
  /// In es, this message translates to:
  /// **'F95Zone'**
  String get f95Titulo;

  /// No description provided for @f95SesionActivaTitulo.
  ///
  /// In es, this message translates to:
  /// **'Sesión activa'**
  String get f95SesionActivaTitulo;

  /// No description provided for @f95SesionActivaDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Las cookies de sesión están guardadas en tu dispositivo. La búsqueda en F95Zone está disponible.'**
  String get f95SesionActivaDescripcion;

  /// No description provided for @f95CerrarSesion.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get f95CerrarSesion;

  /// No description provided for @f95SesionCerrada.
  ///
  /// In es, this message translates to:
  /// **'Sesión cerrada'**
  String get f95SesionCerrada;

  /// No description provided for @f95ConectarTitulo.
  ///
  /// In es, this message translates to:
  /// **'Conectar con F95Zone'**
  String get f95ConectarTitulo;

  /// No description provided for @f95ConectarDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Tus credenciales se usan solo para iniciar sesión. Las cookies se guardan localmente en tu dispositivo.'**
  String get f95ConectarDescripcion;

  /// No description provided for @f95Usuario.
  ///
  /// In es, this message translates to:
  /// **'Usuario de F95Zone'**
  String get f95Usuario;

  /// No description provided for @f95Password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get f95Password;

  /// No description provided for @f95IniciarSesion.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get f95IniciarSesion;

  /// No description provided for @f95CamposObligatorios.
  ///
  /// In es, this message translates to:
  /// **'Completa usuario y contraseña'**
  String get f95CamposObligatorios;

  /// No description provided for @f95SesionOk.
  ///
  /// In es, this message translates to:
  /// **'Sesión iniciada correctamente'**
  String get f95SesionOk;

  /// No description provided for @f95ErrorSesion.
  ///
  /// In es, this message translates to:
  /// **'No se pudo iniciar sesión. Verifica tus datos.'**
  String get f95ErrorSesion;

  /// No description provided for @f95NecesitaSesion.
  ///
  /// In es, this message translates to:
  /// **'Necesitas iniciar sesión en F95Zone primero.'**
  String get f95NecesitaSesion;

  /// No description provided for @apiPerfilCreadoOk.
  ///
  /// In es, this message translates to:
  /// **'Perfil creado correctamente'**
  String get apiPerfilCreadoOk;

  /// No description provided for @apiNombreDuplicado.
  ///
  /// In es, this message translates to:
  /// **'Ese nombre de usuario ya existe'**
  String get apiNombreDuplicado;

  /// No description provided for @apiPasswordIncorrecta.
  ///
  /// In es, this message translates to:
  /// **'Contraseña incorrecta'**
  String get apiPasswordIncorrecta;

  /// No description provided for @apiPerfilActualizadoOk.
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado correctamente'**
  String get apiPerfilActualizadoOk;

  /// No description provided for @apiNombreEnUso.
  ///
  /// In es, this message translates to:
  /// **'Ese nombre ya está en uso'**
  String get apiNombreEnUso;

  /// No description provided for @apiPerfilEliminado.
  ///
  /// In es, this message translates to:
  /// **'Perfil eliminado'**
  String get apiPerfilEliminado;

  /// No description provided for @apiCategoriaCreada.
  ///
  /// In es, this message translates to:
  /// **'Categoría creada'**
  String get apiCategoriaCreada;

  /// No description provided for @apiCategoriaActualizada.
  ///
  /// In es, this message translates to:
  /// **'Categoría actualizada'**
  String get apiCategoriaActualizada;

  /// No description provided for @apiBackupArchivoInvalido.
  ///
  /// In es, this message translates to:
  /// **'Archivo de backup inválido'**
  String get apiBackupArchivoInvalido;

  /// No description provided for @apiBackupRestaurado.
  ///
  /// In es, this message translates to:
  /// **'Backup restaurado: {perfiles} perfil(es), {categorias} categoría(s), {juegos} juego(s)'**
  String apiBackupRestaurado(int perfiles, int categorias, int juegos);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
