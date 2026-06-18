// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Feed95';

  @override
  String get btnCancelar => 'Cancelar';

  @override
  String get btnGuardar => 'Guardar';

  @override
  String get btnEliminar => 'Eliminar';

  @override
  String get btnEditar => 'Editar';

  @override
  String get btnAceptar => 'Aceptar';

  @override
  String get btnEnter => 'Entrar';

  @override
  String get btnImportar => 'Importar';

  @override
  String get btnConfigurar => 'Configurar';

  @override
  String get btnCrearPerfil => 'Crear perfil';

  @override
  String get btnNuevoPerfil => 'Nuevo perfil';

  @override
  String get loginSinCuenta => '¿No tienes cuenta? Créala aquí';

  @override
  String get estadoPendiente => 'Pendiente';

  @override
  String get estadoJugando => 'Jugando';

  @override
  String get estadoCompletado => 'Completado';

  @override
  String get estadoAbandonado => 'Abandonado';

  @override
  String get splashCargando => 'Cargando...';

  @override
  String get homeTitle => 'Feed95';

  @override
  String homeBienvenido(String nombre) {
    return 'Bienvenido, $nombre';
  }

  @override
  String get homeMiCatalogo => 'Mi catálogo';

  @override
  String get homeStatJuegos => 'Juegos';

  @override
  String get homeStatCompletados => 'Completados';

  @override
  String get homeStatJugando => 'Jugando';

  @override
  String get homeTooltipCambiarTema => 'Cambiar tema';

  @override
  String get homeTooltipCambiarPerfil => 'Cambiar perfil';

  @override
  String get homeTooltipCerrarSesion => 'Cerrar sesión';

  @override
  String get homeEditarPerfil => 'Editar perfil';

  @override
  String get homeModoExtendidoActivado => 'Modo extendido activado';

  @override
  String get homeModoExtendidoDesactivado => 'Modo extendido desactivado';

  @override
  String get homeConfiguraciones => 'Configuraciones y Backup';

  @override
  String get homeSeccionConfiguraciones => 'CONFIGURACIONES';

  @override
  String get homeSeccionSistema => 'SISTEMA';

  @override
  String get homeConfigurarIGDB => 'Configurar IGDB';

  @override
  String get homeConfigurarF95 => 'Configurar F95Zone';

  @override
  String get homeExportarCopia => 'Exportar copia';

  @override
  String get homeImportarCopia => 'Importar copia';

  @override
  String homeErrorExportar(String error) {
    return 'Error al exportar: $error';
  }

  @override
  String homeErrorImportar(String error) {
    return 'Error al importar: $error';
  }

  @override
  String homeBackupGuardado(String ruta) {
    return 'Backup guardado en $ruta';
  }

  @override
  String get homeBackupNoDisponibleWeb =>
      'Exportar backup no está disponible en Web';

  @override
  String get homeImportarNoDisponibleWeb =>
      'Importar backup no está disponible en Web';

  @override
  String get homeDialogoImportarTitulo => 'Importar backup';

  @override
  String get homeDialogoImportarContenido =>
      'Se agregarán los perfiles y juegos del backup. Los perfiles con el mismo nombre serán omitidos.';

  @override
  String get homeGuardarBackupEn => 'Guardar backup en...';

  @override
  String get perfilesTitulo => 'Feed95 — Perfiles';

  @override
  String get perfilesVacio => 'No hay perfiles todavía';

  @override
  String get perfilesEliminarTitulo => 'Eliminar perfil';

  @override
  String perfilesEliminarContenido(String nombre) {
    return '¿Eliminar a $nombre? Se borrarán todos sus juegos.';
  }

  @override
  String get perfilesPasswordIncorrecta => 'Contraseña incorrecta';

  @override
  String get perfilesInputPassword => 'Contraseña';

  @override
  String get registroTitulo => 'Nuevo perfil';

  @override
  String get registroUsuario => 'Usuario';

  @override
  String get registroUsarPassword => 'Proteger con contraseña';

  @override
  String get registroAgregarImagen => 'Agregar imagen';

  @override
  String get registroPassword => 'Contraseña';

  @override
  String get registroRepetirPassword => 'Repetir contraseña';

  @override
  String get registroColorPerfil => 'Color del perfil';

  @override
  String get registroTocaColor => 'Toca para elegir un color';

  @override
  String get registroElegirColor => 'Elige un color';

  @override
  String get registroCamposObligatorios => 'Complete todos los campos';

  @override
  String get registroPasswordsNoCoinciden => 'Las contraseñas no coinciden';

  @override
  String get registroColorAplicar => 'Aplicar';

  @override
  String get perfilTitulo => 'Editar perfil';

  @override
  String get perfilCambiarImagen => 'Cambiar imagen';

  @override
  String get perfilQuitarImagen => 'Quitar';

  @override
  String get perfilNuevaPassword => 'Nueva contraseña';

  @override
  String get perfilNuevaPasswordHint => 'Dejar vacío para no cambiar';

  @override
  String get perfilRepetirNuevaPassword => 'Repetir nueva contraseña';

  @override
  String get perfilColorTitulo => 'Color del perfil';

  @override
  String get perfilColorTocar => 'Toca para cambiar el color';

  @override
  String get perfilGuardarCambios => 'Guardar cambios';

  @override
  String get perfilNombreVacio => 'El nombre no puede estar vacío';

  @override
  String get perfilActualizado => 'Perfil actualizado correctamente';

  @override
  String get perfilesEliminarConfirmarTitulo => 'Confirmar eliminación';

  @override
  String get catalogoTitulo => 'Mi catálogo';

  @override
  String get catalogoSecundarioNombre => 'NSFW';

  @override
  String get catalogoVacio => 'No hay juegos en este catálogo';

  @override
  String get catalogoVacioFiltros => 'No hay juegos con esos filtros';

  @override
  String get catalogoReordenarVacio => 'No hay juegos para reordenar';

  @override
  String get catalogoBuscar => 'Buscar...';

  @override
  String get catalogoTooltipFiltros => 'Filtros y categorías';

  @override
  String get catalogoTooltipReordenar => 'Reordenar';

  @override
  String get catalogoTooltipVerCatalogo => 'Ver catálogo';

  @override
  String get catalogoTooltipVistaLista => 'Vista lista';

  @override
  String get catalogoTooltipVistaGrid => 'Vista cuadrícula';

  @override
  String catalogoTooltipCatalogoSecundario(String nombre) {
    return 'Ir a $nombre';
  }

  @override
  String get catalogoTooltipCatalogoPrincipal => 'Ir al catálogo principal';

  @override
  String get catalogoSeccionEstado => 'Estado';

  @override
  String get catalogoSeccionCategorias => 'Categorías';

  @override
  String get catalogoFiltroTodos => 'Todos';

  @override
  String get catalogoFiltroTodas => 'Todas';

  @override
  String get catalogoAsignarCategoria => 'Asignar categoría';

  @override
  String get catalogoSinCategoria => 'Sin categoría';

  @override
  String get categoriaNuevaTitulo => 'Nueva categoría';

  @override
  String get categoriaEditarTitulo => 'Editar categoría';

  @override
  String get categoriaNombreLabel => 'Nombre';

  @override
  String get categoriaEliminarTitulo => 'Eliminar categoría';

  @override
  String categoriaEliminarContenido(String nombre) {
    return '¿Eliminar \"$nombre\"? Los juegos perderán esta categoría.';
  }

  @override
  String get juegoDetalleTitulo => 'Detalle';

  @override
  String get juegoDetalleDescripcion => 'Descripción';

  @override
  String get juegoDetalleImagenes => 'Imágenes';

  @override
  String get juegoDetalleJugar => 'Jugar';

  @override
  String get juegoDetalleEliminarTitulo => 'Eliminar juego';

  @override
  String juegoDetalleEliminarContenido(String nombre) {
    return '¿Eliminar \"$nombre\"? Esta acción no se puede deshacer.';
  }

  @override
  String juegoDetalleErrorEjecutable(String error) {
    return 'No se pudo ejecutar: $error';
  }

  @override
  String get juegoDetalleTooltipEditar => 'Editar';

  @override
  String get juegoDetalleTooltipEliminar => 'Eliminar';

  @override
  String get juegoFormNuevoTitulo => 'Nuevo juego';

  @override
  String get juegoFormEditarTitulo => 'Editar juego';

  @override
  String get juegoFormNombre => 'Nombre *';

  @override
  String get juegoFormBuscarEn => 'Buscar en:';

  @override
  String get juegoFormDescripcion => 'Descripción';

  @override
  String get juegoFormImagenDetalle => 'Imagen del detalle';

  @override
  String get juegoFormUrlImagenDetalle => 'URL imagen detalle';

  @override
  String get juegoFormImagenGrid => 'Imagen del grid';

  @override
  String get juegoFormUrlImagenGrid => 'URL imagen grid';

  @override
  String get juegoFormAjustar => 'Ajustar';

  @override
  String get juegoFormVersion => 'Versión';

  @override
  String get juegoFormCalificacion => 'Calificación (1-10)';

  @override
  String get juegoFormGeneros => 'Géneros';

  @override
  String get juegoFormEstado => 'Estado';

  @override
  String get juegoFormLanzador => 'Lanzador';

  @override
  String get juegoFormRutaEjecutable => 'Ruta del ejecutable';

  @override
  String get juegoFormRutaEjecutableHint => 'C:\\juegos\\myjuego.exe';

  @override
  String get juegoFormBuscarArchivo => 'Buscar archivo';

  @override
  String get juegoFormQuitarRuta => 'Quitar ruta';

  @override
  String get juegoFormBtnGuardar => 'Guardar';

  @override
  String get juegoFormBtnActualizar => 'Actualizar';

  @override
  String get juegoFormNombreObligatorio => 'El nombre es obligatorio';

  @override
  String get juegoFormNoBusqueda => 'Escribe un nombre para buscar';

  @override
  String get juegoFormSinResultadosSteam =>
      'No se encontraron resultados en Steam';

  @override
  String get juegoFormSinResultadosEpic =>
      'No se encontraron resultados en Epic';

  @override
  String get juegoFormSinResultadosIgdb =>
      'No se encontraron resultados en IGDB';

  @override
  String get juegoFormSinResultadosF95 =>
      'No se encontraron resultados en F95Zone';

  @override
  String get juegoFormErrorDetalles => 'No se pudieron obtener los detalles';

  @override
  String get juegoFormResultadosSteam => 'Resultados en Steam';

  @override
  String get juegoFormResultadosEpic => 'Resultados en Epic Games';

  @override
  String get juegoFormResultadosIgdb => 'Resultados en IGDB';

  @override
  String get juegoFormResultadosF95 => 'Resultados en F95Zone';

  @override
  String get juegoFormAgregado => 'Juego agregado correctamente';

  @override
  String get juegoFormActualizado => 'Juego actualizado correctamente';

  @override
  String get juegoFormEliminado => 'Juego eliminado correctamente';

  @override
  String get juegoFormGuardarImagenesLocal =>
      'Guardar imágenes en este dispositivo';

  @override
  String get juegoFormCacheGuardadoOk => 'Imágenes guardadas localmente (WebP)';

  @override
  String get juegoFormCacheError =>
      'No se pudo guardar ninguna imagen localmente';

  @override
  String get juegoFormModoNinguno => 'No guardar localmente';

  @override
  String get juegoFormModoOriginal => 'Guardar tal cual (sin comprimir)';

  @override
  String get juegoFormModoComprimido => 'Guardar comprimido (JPEG)';

  @override
  String get homeCarpetaImagenes => 'Carpeta de imágenes';

  @override
  String get homeCarpetaImagenesTitulo => 'Imágenes guardadas localmente';

  @override
  String homeCarpetaImagenesEspacio(String mb) {
    return 'Espacio usado: $mb MB';
  }

  @override
  String get igdbTitulo => 'IGDB';

  @override
  String get igdbConfiguradoTitulo => 'IGDB configurado';

  @override
  String get igdbConfiguradoDescripcion =>
      'Las credenciales están guardadas localmente. El botón IGDB está disponible al añadir juegos.';

  @override
  String get igdbEliminarCredenciales => 'Eliminar credenciales';

  @override
  String get igdbConfigurarTitulo => 'Configurar IGDB';

  @override
  String get igdbDescripcion =>
      'IGDB es la base de datos de videojuegos de Twitch. Es gratuita y cubre prácticamente cualquier juego.';

  @override
  String get igdbInstrucciones =>
      '¿Cómo obtener credenciales?\n1. Ve a dev.twitch.tv\n2. Inicia sesión con tu cuenta de Twitch\n3. Crea una nueva aplicación (cualquier nombre)\n4. Copia el Client-ID y genera un Client-Secret';

  @override
  String get igdbClientId => 'Client-ID';

  @override
  String get igdbClientSecret => 'Client-Secret';

  @override
  String get igdbGuardarVerificar => 'Guardar y verificar';

  @override
  String get igdbCamposObligatorios => 'Completa ambos campos';

  @override
  String get igdbCredencialesInvalidas =>
      'Credenciales inválidas. Verifica tus datos.';

  @override
  String get igdbConfiguradoOk => 'IGDB configurado correctamente';

  @override
  String get igdbNecesitaConfiguracion => 'Necesitas configurar IGDB primero.';

  @override
  String get f95Titulo => 'F95Zone';

  @override
  String get f95SesionActivaTitulo => 'Sesión activa';

  @override
  String get f95SesionActivaDescripcion =>
      'Las cookies de sesión están guardadas en tu dispositivo. La búsqueda en F95Zone está disponible.';

  @override
  String get f95CerrarSesion => 'Cerrar sesión';

  @override
  String get f95SesionCerrada => 'Sesión cerrada';

  @override
  String get f95ConectarTitulo => 'Conectar con F95Zone';

  @override
  String get f95ConectarDescripcion =>
      'Tus credenciales se usan solo para iniciar sesión. Las cookies se guardan localmente en tu dispositivo.';

  @override
  String get f95Usuario => 'Usuario de F95Zone';

  @override
  String get f95Password => 'Contraseña';

  @override
  String get f95IniciarSesion => 'Iniciar sesión';

  @override
  String get f95CamposObligatorios => 'Completa usuario y contraseña';

  @override
  String get f95SesionOk => 'Sesión iniciada correctamente';

  @override
  String get f95ErrorSesion => 'No se pudo iniciar sesión. Verifica tus datos.';

  @override
  String get f95NecesitaSesion =>
      'Necesitas iniciar sesión en F95Zone primero.';

  @override
  String get apiPerfilCreadoOk => 'Perfil creado correctamente';

  @override
  String get apiNombreDuplicado => 'Ese nombre de usuario ya existe';

  @override
  String get apiPasswordIncorrecta => 'Contraseña incorrecta';

  @override
  String get apiPerfilActualizadoOk => 'Perfil actualizado correctamente';

  @override
  String get apiNombreEnUso => 'Ese nombre ya está en uso';

  @override
  String get apiPerfilEliminado => 'Perfil eliminado';

  @override
  String get apiCategoriaCreada => 'Categoría creada';

  @override
  String get apiCategoriaActualizada => 'Categoría actualizada';

  @override
  String get apiBackupArchivoInvalido => 'Archivo de backup inválido';

  @override
  String apiBackupRestaurado(int perfiles, int categorias, int juegos) {
    return 'Backup restaurado: $perfiles perfil(es), $categorias categoría(s), $juegos juego(s)';
  }
}
