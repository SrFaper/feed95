// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Feed95';

  @override
  String get btnCancelar => 'Cancel';

  @override
  String get btnGuardar => 'Save';

  @override
  String get btnEliminar => 'Delete';

  @override
  String get btnEditar => 'Edit';

  @override
  String get btnAceptar => 'OK';

  @override
  String get btnEnter => 'Enter';

  @override
  String get btnImportar => 'Import';

  @override
  String get btnConfigurar => 'Configure';

  @override
  String get btnCrearPerfil => 'Create profile';

  @override
  String get btnNuevoPerfil => 'New profile';

  @override
  String get loginSinCuenta => 'Don\'t have an account? Create one here';

  @override
  String get estadoPendiente => 'Pending';

  @override
  String get estadoJugando => 'Playing';

  @override
  String get estadoCompletado => 'Completed';

  @override
  String get estadoAbandonado => 'Abandoned';

  @override
  String get splashCargando => 'Loading...';

  @override
  String get homeTitle => 'Feed95';

  @override
  String homeBienvenido(String nombre) {
    return 'Welcome, $nombre';
  }

  @override
  String get homeMiCatalogo => 'My catalog';

  @override
  String get homeStatJuegos => 'Games';

  @override
  String get homeStatCompletados => 'Completed';

  @override
  String get homeStatJugando => 'Playing';

  @override
  String get homeTooltipCambiarTema => 'Toggle theme';

  @override
  String get homeTooltipCambiarPerfil => 'Switch profile';

  @override
  String get homeTooltipCerrarSesion => 'Log out';

  @override
  String get homeEditarPerfil => 'Edit profile';

  @override
  String get homeModoExtendidoActivado => 'Extended mode enabled';

  @override
  String get homeModoExtendidoDesactivado => 'Extended mode disabled';

  @override
  String get homeConfiguraciones => 'Settings & Backup';

  @override
  String get homeSeccionConfiguraciones => 'SETTINGS';

  @override
  String get homeSeccionSistema => 'SYSTEM';

  @override
  String get homeConfigurarIGDB => 'Configure IGDB';

  @override
  String get homeConfigurarF95 => 'Configure F95Zone';

  @override
  String get homeExportarCopia => 'Export backup';

  @override
  String get homeImportarCopia => 'Import backup';

  @override
  String homeErrorExportar(String error) {
    return 'Export error: $error';
  }

  @override
  String homeErrorImportar(String error) {
    return 'Import error: $error';
  }

  @override
  String homeBackupGuardado(String ruta) {
    return 'Backup saved to $ruta';
  }

  @override
  String get homeBackupNoDisponibleWeb =>
      'Export backup is not available on Web';

  @override
  String get homeImportarNoDisponibleWeb =>
      'Import backup is not available on Web';

  @override
  String get homeDialogoImportarTitulo => 'Import backup';

  @override
  String get homeDialogoImportarContenido =>
      'Profiles and games from the backup will be added. Profiles with the same name will be skipped.';

  @override
  String get homeGuardarBackupEn => 'Save backup to...';

  @override
  String get perfilesTitulo => 'Feed95 — Profiles';

  @override
  String get perfilesVacio => 'No profiles yet';

  @override
  String get perfilesEliminarTitulo => 'Delete profile';

  @override
  String perfilesEliminarContenido(String nombre) {
    return 'Delete $nombre? All their games will be removed.';
  }

  @override
  String get perfilesPasswordIncorrecta => 'Wrong password';

  @override
  String get perfilesInputPassword => 'Password';

  @override
  String get registroTitulo => 'New profile';

  @override
  String get registroUsuario => 'Username';

  @override
  String get registroPassword => 'Password';

  @override
  String get registroRepetirPassword => 'Repeat password';

  @override
  String get registroColorPerfil => 'Profile color';

  @override
  String get registroTocaColor => 'Tap to choose a color';

  @override
  String get registroElegirColor => 'Choose a color';

  @override
  String get registroCamposObligatorios => 'Please fill in all fields';

  @override
  String get registroPasswordsNoCoinciden => 'Passwords do not match';

  @override
  String get registroColorAplicar => 'Apply';

  @override
  String get perfilTitulo => 'Edit profile';

  @override
  String get perfilCambiarImagen => 'Change image';

  @override
  String get perfilQuitarImagen => 'Remove';

  @override
  String get perfilNuevaPassword => 'New password';

  @override
  String get perfilNuevaPasswordHint => 'Leave blank to keep current';

  @override
  String get perfilRepetirNuevaPassword => 'Repeat new password';

  @override
  String get perfilColorTitulo => 'Profile color';

  @override
  String get perfilColorTocar => 'Tap to change color';

  @override
  String get perfilGuardarCambios => 'Save changes';

  @override
  String get perfilNombreVacio => 'Name cannot be empty';

  @override
  String get perfilActualizado => 'Profile updated successfully';

  @override
  String get catalogoTitulo => 'My catalog';

  @override
  String get catalogoSecundarioNombre => 'NSFW';

  @override
  String get catalogoVacio => 'No games in this catalog';

  @override
  String get catalogoVacioFiltros => 'No games match those filters';

  @override
  String get catalogoReordenarVacio => 'No games to reorder';

  @override
  String get catalogoBuscar => 'Search...';

  @override
  String get catalogoTooltipFiltros => 'Filters & categories';

  @override
  String get catalogoTooltipReordenar => 'Reorder';

  @override
  String get catalogoTooltipVerCatalogo => 'View catalog';

  @override
  String get catalogoTooltipVistaLista => 'List view';

  @override
  String get catalogoTooltipVistaGrid => 'Grid view';

  @override
  String catalogoTooltipCatalogoSecundario(String nombre) {
    return 'Go to $nombre';
  }

  @override
  String get catalogoTooltipCatalogoPrincipal => 'Go to main catalog';

  @override
  String get catalogoSeccionEstado => 'Status';

  @override
  String get catalogoSeccionCategorias => 'Categories';

  @override
  String get catalogoFiltroTodos => 'All';

  @override
  String get catalogoFiltroTodas => 'All';

  @override
  String get catalogoAsignarCategoria => 'Assign category';

  @override
  String get catalogoSinCategoria => 'No category';

  @override
  String get categoriaNuevaTitulo => 'New category';

  @override
  String get categoriaEditarTitulo => 'Edit category';

  @override
  String get categoriaNombreLabel => 'Name';

  @override
  String get categoriaEliminarTitulo => 'Delete category';

  @override
  String categoriaEliminarContenido(String nombre) {
    return 'Delete \"$nombre\"? Games will lose this category.';
  }

  @override
  String get juegoDetalleTitulo => 'Detail';

  @override
  String get juegoDetalleDescripcion => 'Description';

  @override
  String get juegoDetalleImagenes => 'Screenshots';

  @override
  String get juegoDetalleJugar => 'Play';

  @override
  String get juegoDetalleEliminarTitulo => 'Delete game';

  @override
  String juegoDetalleEliminarContenido(String nombre) {
    return 'Delete \"$nombre\"? This action cannot be undone.';
  }

  @override
  String juegoDetalleErrorEjecutable(String error) {
    return 'Could not launch: $error';
  }

  @override
  String get juegoDetalleTooltipEditar => 'Edit';

  @override
  String get juegoDetalleTooltipEliminar => 'Delete';

  @override
  String get juegoFormNuevoTitulo => 'New game';

  @override
  String get juegoFormEditarTitulo => 'Edit game';

  @override
  String get juegoFormNombre => 'Name *';

  @override
  String get juegoFormBuscarEn => 'Search on:';

  @override
  String get juegoFormDescripcion => 'Description';

  @override
  String get juegoFormImagenDetalle => 'Detail image';

  @override
  String get juegoFormUrlImagenDetalle => 'Detail image URL';

  @override
  String get juegoFormImagenGrid => 'Grid image';

  @override
  String get juegoFormUrlImagenGrid => 'Grid image URL';

  @override
  String get juegoFormVersion => 'Version';

  @override
  String get juegoFormCalificacion => 'Rating (1-10)';

  @override
  String get juegoFormGeneros => 'Genres';

  @override
  String get juegoFormEstado => 'Status';

  @override
  String get juegoFormLanzador => 'Launcher';

  @override
  String get juegoFormRutaEjecutable => 'Executable path';

  @override
  String get juegoFormRutaEjecutableHint => 'C:\\games\\mygame.exe';

  @override
  String get juegoFormBuscarArchivo => 'Browse file';

  @override
  String get juegoFormQuitarRuta => 'Remove path';

  @override
  String get juegoFormBtnGuardar => 'Save';

  @override
  String get juegoFormBtnActualizar => 'Update';

  @override
  String get juegoFormNombreObligatorio => 'Name is required';

  @override
  String get juegoFormNoBusqueda => 'Enter a name to search';

  @override
  String get juegoFormSinResultadosSteam => 'No results found on Steam';

  @override
  String get juegoFormSinResultadosEpic => 'No results found on Epic';

  @override
  String get juegoFormSinResultadosIgdb => 'No results found on IGDB';

  @override
  String get juegoFormSinResultadosF95 => 'No results found on F95Zone';

  @override
  String get juegoFormErrorDetalles => 'Could not fetch details';

  @override
  String get juegoFormResultadosSteam => 'Steam results';

  @override
  String get juegoFormResultadosEpic => 'Epic Games results';

  @override
  String get juegoFormResultadosIgdb => 'IGDB results';

  @override
  String get juegoFormResultadosF95 => 'F95Zone results';

  @override
  String get juegoFormAgregado => 'Game added successfully';

  @override
  String get juegoFormActualizado => 'Game updated successfully';

  @override
  String get juegoFormEliminado => 'Game deleted successfully';

  @override
  String get igdbTitulo => 'IGDB';

  @override
  String get igdbConfiguradoTitulo => 'IGDB configured';

  @override
  String get igdbConfiguradoDescripcion =>
      'Credentials are saved locally. The IGDB button is available when adding games.';

  @override
  String get igdbEliminarCredenciales => 'Remove credentials';

  @override
  String get igdbConfigurarTitulo => 'Set up IGDB';

  @override
  String get igdbDescripcion =>
      'IGDB is Twitch\'s video game database. It\'s free and covers virtually any game.';

  @override
  String get igdbInstrucciones =>
      'How to get credentials?\n1. Go to dev.twitch.tv\n2. Sign in with your Twitch account\n3. Create a new application (any name)\n4. Copy the Client-ID and generate a Client-Secret';

  @override
  String get igdbClientId => 'Client-ID';

  @override
  String get igdbClientSecret => 'Client-Secret';

  @override
  String get igdbGuardarVerificar => 'Save and verify';

  @override
  String get igdbCamposObligatorios => 'Please fill in both fields';

  @override
  String get igdbCredencialesInvalidas =>
      'Invalid credentials. Please check your data.';

  @override
  String get igdbConfiguradoOk => 'IGDB configured successfully';

  @override
  String get igdbNecesitaConfiguracion => 'You need to configure IGDB first.';

  @override
  String get f95Titulo => 'F95Zone';

  @override
  String get f95SesionActivaTitulo => 'Active session';

  @override
  String get f95SesionActivaDescripcion =>
      'Session cookies are saved on your device. F95Zone search is available.';

  @override
  String get f95CerrarSesion => 'Log out';

  @override
  String get f95SesionCerrada => 'Session closed';

  @override
  String get f95ConectarTitulo => 'Connect to F95Zone';

  @override
  String get f95ConectarDescripcion =>
      'Your credentials are only used to log in. Cookies are stored locally on your device.';

  @override
  String get f95Usuario => 'F95Zone username';

  @override
  String get f95Password => 'Password';

  @override
  String get f95IniciarSesion => 'Log in';

  @override
  String get f95CamposObligatorios => 'Please enter your username and password';

  @override
  String get f95SesionOk => 'Logged in successfully';

  @override
  String get f95ErrorSesion =>
      'Could not log in. Please check your credentials.';

  @override
  String get f95NecesitaSesion => 'You need to log in to F95Zone first.';

  @override
  String get apiPerfilCreadoOk => 'Profile created successfully';

  @override
  String get apiNombreDuplicado => 'That username already exists';

  @override
  String get apiPasswordIncorrecta => 'Wrong password';

  @override
  String get apiPerfilActualizadoOk => 'Profile updated successfully';

  @override
  String get apiNombreEnUso => 'That name is already taken';

  @override
  String get apiPerfilEliminado => 'Profile deleted';

  @override
  String get apiCategoriaCreada => 'Category created';

  @override
  String get apiCategoriaActualizada => 'Category updated';

  @override
  String get apiBackupArchivoInvalido => 'Invalid backup file';

  @override
  String apiBackupRestaurado(int perfiles, int categorias, int juegos) {
    return 'Backup restored: $perfiles profile(s), $categorias categor(y/ies), $juegos game(s)';
  }
}
