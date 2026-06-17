// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Feed95';

  @override
  String get btnCancelar => '取消';

  @override
  String get btnGuardar => '保存';

  @override
  String get btnEliminar => '删除';

  @override
  String get btnEditar => '编辑';

  @override
  String get btnAceptar => '确定';

  @override
  String get btnEnter => '进入';

  @override
  String get btnImportar => '导入';

  @override
  String get btnConfigurar => '配置';

  @override
  String get btnCrearPerfil => '创建档案';

  @override
  String get btnNuevoPerfil => '新建档案';

  @override
  String get loginSinCuenta => '还没有账号？点击此处创建';

  @override
  String get estadoPendiente => '待玩';

  @override
  String get estadoJugando => '正在游玩';

  @override
  String get estadoCompletado => '已通关';

  @override
  String get estadoAbandonado => '已弃坑';

  @override
  String get splashCargando => '正在加载...';

  @override
  String get homeTitle => 'Feed95';

  @override
  String homeBienvenido(String nombre) {
    return '欢迎，$nombre';
  }

  @override
  String get homeMiCatalogo => '我的库';

  @override
  String get homeStatJuegos => '游戏总数';

  @override
  String get homeStatCompletados => '已通关';

  @override
  String get homeStatJugando => '正在游玩';

  @override
  String get homeTooltipCambiarTema => '切换主题';

  @override
  String get homeTooltipCambiarPerfil => '切换档案';

  @override
  String get homeTooltipCerrarSesion => '退出登录';

  @override
  String get homeEditarPerfil => '编辑档案';

  @override
  String get homeModoExtendidoActivado => '扩展模式已开启';

  @override
  String get homeModoExtendidoDesactivado => '扩展模式已关闭';

  @override
  String get homeConfiguraciones => '配置与备份';

  @override
  String get homeSeccionConfiguraciones => '设置';

  @override
  String get homeSeccionSistema => '系统';

  @override
  String get homeConfigurarIGDB => '配置 IGDB';

  @override
  String get homeConfigurarF95 => '配置 F95Zone';

  @override
  String get homeExportarCopia => '导出备份';

  @override
  String get homeImportarCopia => '导入备份';

  @override
  String homeErrorExportar(String error) {
    return '导出失败：$error';
  }

  @override
  String homeErrorImportar(String error) {
    return '导入失败：$error';
  }

  @override
  String homeBackupGuardado(String ruta) {
    return '备份已保存至 $ruta';
  }

  @override
  String get homeBackupNoDisponibleWeb => '网页端不支持导出备份';

  @override
  String get homeImportarNoDisponibleWeb => '网页端不支持导入备份';

  @override
  String get homeDialogoImportarTitulo => '导入备份';

  @override
  String get homeDialogoImportarContenido => '备份中的档案和游戏将被添加。同名的现有档案将被忽略。';

  @override
  String get homeGuardarBackupEn => '保存备份至...';

  @override
  String get perfilesTitulo => 'Feed95 — 档案管理';

  @override
  String get perfilesVacio => '暂无档案';

  @override
  String get perfilesEliminarTitulo => '删除档案';

  @override
  String perfilesEliminarContenido(String nombre) {
    return '确定要删除 $nombre 吗？该档案下的所有游戏数据都将被清除。';
  }

  @override
  String get perfilesPasswordIncorrecta => '密码错误';

  @override
  String get perfilesInputPassword => '密码';

  @override
  String get registroTitulo => '新建档案';

  @override
  String get registroUsuario => '用户名';

  @override
  String get registroUsarPassword => '使用密码保护';

  @override
  String get registroAgregarImagen => '添加图片';

  @override
  String get registroPassword => '密码';

  @override
  String get registroRepetirPassword => '确认密码';

  @override
  String get registroColorPerfil => '档案个性颜色';

  @override
  String get registroTocaColor => '点击选择颜色';

  @override
  String get registroElegirColor => '选择一个颜色';

  @override
  String get registroCamposObligatorios => '请填写所有必填项';

  @override
  String get registroPasswordsNoCoinciden => '两次输入的密码不一致';

  @override
  String get registroColorAplicar => '应用';

  @override
  String get perfilTitulo => '编辑档案';

  @override
  String get perfilCambiarImagen => '更换头像';

  @override
  String get perfilQuitarImagen => '移除';

  @override
  String get perfilNuevaPassword => '新密码';

  @override
  String get perfilNuevaPasswordHint => '留空则不修改';

  @override
  String get perfilRepetirNuevaPassword => '确认新密码';

  @override
  String get perfilColorTitulo => '档案个性颜色';

  @override
  String get perfilColorTocar => '点击更改颜色';

  @override
  String get perfilGuardarCambios => '保存修改';

  @override
  String get perfilNombreVacio => '用户名不能为空';

  @override
  String get perfilActualizado => '档案更新成功';

  @override
  String get perfilesEliminarConfirmarTitulo => '确认删除';

  @override
  String get catalogoTitulo => '我的库';

  @override
  String get catalogoSecundarioNombre => 'NSFW';

  @override
  String get catalogoVacio => '当前库中没有游戏';

  @override
  String get catalogoVacioFiltros => '没有找到符合筛选条件的游戏';

  @override
  String get catalogoReordenarVacio => '没有可重新排序的游戏';

  @override
  String get catalogoBuscar => '搜索...';

  @override
  String get catalogoTooltipFiltros => '筛选与分类';

  @override
  String get catalogoTooltipReordenar => '重新排序';

  @override
  String get catalogoTooltipVerCatalogo => '查看游戏库';

  @override
  String get catalogoTooltipVistaLista => '列表视图';

  @override
  String get catalogoTooltipVistaGrid => '网格视图';

  @override
  String catalogoTooltipCatalogoSecundario(String nombre) {
    return '前往 $nombre';
  }

  @override
  String get catalogoTooltipCatalogoPrincipal => '返回主游戏库';

  @override
  String get catalogoSeccionEstado => '游玩状态';

  @override
  String get catalogoSeccionCategorias => '游戏分类';

  @override
  String get catalogoFiltroTodos => '全部状态';

  @override
  String get catalogoFiltroTodas => '全部分类';

  @override
  String get catalogoAsignarCategoria => '分配分类';

  @override
  String get catalogoSinCategoria => '未分类';

  @override
  String get categoriaNuevaTitulo => '新建分类';

  @override
  String get categoriaEditarTitulo => '编辑分类';

  @override
  String get categoriaNombreLabel => '分类名称';

  @override
  String get categoriaEliminarTitulo => '删除分类';

  @override
  String categoriaEliminarContenido(String nombre) {
    return '确定要删除分类 \"$nombre\" 吗？属于该分类的游戏将变为未分类状态。';
  }

  @override
  String get juegoDetalleTitulo => '游戏详情';

  @override
  String get juegoDetalleDescripcion => '简介';

  @override
  String get juegoDetalleImagenes => '屏幕截图';

  @override
  String get juegoDetalleJugar => '开始游戏';

  @override
  String get juegoDetalleEliminarTitulo => '删除游戏';

  @override
  String juegoDetalleEliminarContenido(String nombre) {
    return '确定要删除 \"$nombre\" 吗？此操作无法撤销。';
  }

  @override
  String juegoDetalleErrorEjecutable(String error) {
    return '无法启动游戏：$error';
  }

  @override
  String get juegoDetalleTooltipEditar => '编辑';

  @override
  String get juegoDetalleTooltipEliminar => '删除';

  @override
  String get juegoFormNuevoTitulo => '添加游戏';

  @override
  String get juegoFormEditarTitulo => '编辑游戏';

  @override
  String get juegoFormNombre => '游戏名称 *';

  @override
  String get juegoFormBuscarEn => '搜索平台：';

  @override
  String get juegoFormDescripcion => '简介';

  @override
  String get juegoFormImagenDetalle => '详情页背景图';

  @override
  String get juegoFormUrlImagenDetalle => '详情图 URL';

  @override
  String get juegoFormImagenGrid => '封面图 (Grid)';

  @override
  String get juegoFormUrlImagenGrid => '封面图 URL';

  @override
  String get juegoFormVersion => '版本';

  @override
  String get juegoFormCalificacion => '评分 (1-10)';

  @override
  String get juegoFormGeneros => '游戏标签 / 类型';

  @override
  String get juegoFormEstado => '游玩状态';

  @override
  String get juegoFormLanzador => '启动器';

  @override
  String get juegoFormRutaEjecutable => '可执行文件路径 (.exe)';

  @override
  String get juegoFormRutaEjecutableHint => 'C:\\juegos\\myjuego.exe';

  @override
  String get juegoFormBuscarArchivo => '浏览文件';

  @override
  String get juegoFormQuitarRuta => '清除路径';

  @override
  String get juegoFormBtnGuardar => '添加游戏';

  @override
  String get juegoFormBtnActualizar => '更新信息';

  @override
  String get juegoFormNombreObligatorio => '游戏名称为必填项';

  @override
  String get juegoFormNoBusqueda => '请输入名称以进行搜索';

  @override
  String get juegoFormSinResultadosSteam => '未在 Steam 上找到相关结果';

  @override
  String get juegoFormSinResultadosEpic => '未在 Epic Games 上找到相关结果';

  @override
  String get juegoFormSinResultadosIgdb => '未在 IGDB 上找到相关结果';

  @override
  String get juegoFormSinResultadosF95 => '未在 F95Zone 上找到相关结果';

  @override
  String get juegoFormErrorDetalles => '无法获取详细信息';

  @override
  String get juegoFormResultadosSteam => 'Steam 搜索结果';

  @override
  String get juegoFormResultadosEpic => 'Epic Games 搜索结果';

  @override
  String get juegoFormResultadosIgdb => 'IGDB 搜索结果';

  @override
  String get juegoFormResultadosF95 => 'F95Zone 搜索结果';

  @override
  String get juegoFormAgregado => '游戏成功添加到库中';

  @override
  String get juegoFormActualizado => '游戏信息更新成功';

  @override
  String get juegoFormEliminado => '游戏删除成功';

  @override
  String get igdbTitulo => 'IGDB';

  @override
  String get igdbConfiguradoTitulo => 'IGDB 已配置';

  @override
  String get igdbConfiguradoDescripcion => '凭据已保存在本地。现在可以在添加游戏时使用 IGDB 搜索。';

  @override
  String get igdbEliminarCredenciales => '清除凭据';

  @override
  String get igdbConfigurarTitulo => '配置 IGDB';

  @override
  String get igdbDescripcion =>
      'IGDB 是由 Twitch 运营的官方游戏数据库。它是完全免费的，涵盖了几乎所有的主流游戏。';

  @override
  String get igdbInstrucciones =>
      '如何获取凭据？\n1. 访问 dev.twitch.tv\n2. 使用你的 Twitch 账号登录\n3. 创建一个新应用（名称任意）\n4. 复制生成的 Client-ID 并创建 Client-Secret';

  @override
  String get igdbClientId => 'Client-ID';

  @override
  String get igdbClientSecret => 'Client-Secret';

  @override
  String get igdbGuardarVerificar => '保存并验证';

  @override
  String get igdbCamposObligatorios => '请填写两个输入框';

  @override
  String get igdbCredencialesInvalidas => '凭据无效，请检查你输入的数据。';

  @override
  String get igdbConfiguradoOk => 'IGDB 成功配置完成';

  @override
  String get igdbNecesitaConfiguracion => '需要先配置 IGDB 接口。';

  @override
  String get f95Titulo => 'F95Zone';

  @override
  String get f95SesionActivaTitulo => '会话处于活动状态';

  @override
  String get f95SesionActivaDescripcion =>
      '登录 Cookie 已安全保存在此设备中。现在可以使用 F95Zone 搜索功能。';

  @override
  String get f95CerrarSesion => '退出登录';

  @override
  String get f95SesionCerrada => '会话已关闭';

  @override
  String get f95ConectarTitulo => '连接到 F95Zone';

  @override
  String get f95ConectarDescripcion => '你的凭据仅用于直接登录官方平台。Cookie 将保存在你本地设备中。';

  @override
  String get f95Usuario => 'F95Zone 用户名';

  @override
  String get f95Password => '密码';

  @override
  String get f95IniciarSesion => '登录';

  @override
  String get f95CamposObligatorios => '请输入用户名和密码';

  @override
  String get f95SesionOk => '成功登录 F95Zone';

  @override
  String get f95ErrorSesion => '登录失败，请检查你的账号和密码。';

  @override
  String get f95NecesitaSesion => '请先登录你的 F95Zone 账号。';

  @override
  String get apiPerfilCreadoOk => '档案创建成功';

  @override
  String get apiNombreDuplicado => '该用户名已存在';

  @override
  String get apiPasswordIncorrecta => '密码错误';

  @override
  String get apiPerfilActualizadoOk => '档案更新成功';

  @override
  String get apiNombreEnUso => '该名称已被使用';

  @override
  String get apiPerfilEliminado => '档案已删除';

  @override
  String get apiCategoriaCreada => '分类创建成功';

  @override
  String get apiCategoriaActualizada => '分类更新成功';

  @override
  String get apiBackupArchivoInvalido => '无效的备份文件';

  @override
  String apiBackupRestaurado(int perfiles, int categorias, int juegos) {
    return '备份还原成功：已导入 $perfiles 个档案，$categorias 个分类，$juegos 个游戏';
  }
}
