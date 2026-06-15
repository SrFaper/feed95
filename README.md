<div align="center">

# feed95

**Catálogo personal de videojuegos para Windows y Android.**
**Personal video game catalog for Windows and Android.**

Sin cuentas. Sin servidores. Sin internet. Solo tus juegos, en tu dispositivo.
No accounts. No servers. No internet. Just your games, on your device.

</div>

---

## Español

### Características

- **Múltiples perfiles locales** - Cada perfil tiene su propia contraseña, color de acento e imagen. Comparte el dispositivo sin mezclar catálogos.
- **100% offline** - Todo se guarda en una base de datos SQLite local. Sin cuentas, sin nube, sin conexión obligatoria. Tus datos no salen de tu dispositivo.
- **Búsqueda automática de metadatos** - Importa portada, descripción, géneros y capturas desde Steam, Epic Games o IGDB con un clic.
- **Categorías y filtros** - Organiza tu catálogo con categorías personalizadas. Filtra por estado, categoría o búsqueda de texto.
- **Estados y calificaciones** - Marca cada juego como Pendiente, Jugando, Completado o Abandonado. Puntúa del 1 al 10. Reordena tu catálogo a mano.
- **Catálogo secundario opcional** - Un segundo catálogo separado del principal, ideal para mantener colecciones distintas bajo el mismo perfil.
- **Lanzador integrado** - Vincula el ejecutable de cada juego y árrancalo directo desde la app. Solo en Windows.
- **Backup y restauración** - Exporta toda tu colección a un archivo JSON e impórtala en cualquier dispositivo cuando quieras.
- **Tema claro / oscuro con acento personalizable** - La interfaz se adapta al color que elijas para cada perfil.

### Descarga e instalación

**Android**

1. Descarga `feed95.apk` desde la sección de [Releases](https://github.com/SrFaper/feed95/releases).
2. Ábrelo en tu dispositivo. Si el sistema lo pide, permite la instalación desde fuentes desconocidas.

**Windows**

1. Descarga `feed95-windows.zip` desde la sección de [Releases](https://github.com/SrFaper/feed95/releases).
2. Extrae el contenido en la carpeta que prefieras.
3. Ejecuta `feed95.exe`. No requiere instalación.

### Búsqueda de metadatos

feed95 puede importar información de juegos desde tres fuentes:

| Fuente | Requiere configuración |
|--------|----------------------|
| Steam | No |
| Epic Games Store | No |
| IGDB | Sí, credenciales gratuitas de Twitch Developer |

Para configurar IGDB: visita [dev.twitch.tv](https://dev.twitch.tv), crea una aplicación y copia tu Client-ID y Client-Secret en Configuraciones dentro de la app.

### Construido con

- [Flutter](https://flutter.dev/) - Framework multiplataforma
- [SQLite / sqflite](https://pub.dev/packages/sqflite) - Base de datos local
- [dio](https://pub.dev/packages/dio) + [cookie_jar](https://pub.dev/packages/cookie_jar) - Peticiones HTTP
- [flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker) - Selector de color de perfil
- [file_picker](https://pub.dev/packages/file_picker) / [image_picker](https://pub.dev/packages/image_picker) - Selección de archivos e imágenes

### Licencia

feed95 se distribuye bajo la licencia **GNU General Public License v3.0**. Consulta el archivo [`LICENSE`](LICENSE) para más detalles.

En cristiano: puedes usar, copiar, modificar y distribuir este software (incluso comercialmente), pero cualquier versión derivada debe distribuirse también bajo GPL v3 con el código fuente disponible.

### Avisos de terceros y atribución

feed95 utiliza datos de servicios externos para enriquecer el catálogo. Estos servicios no están afiliados al proyecto ni lo respaldan.

**Steam / Valve**
Los metadatos de juegos de Steam se obtienen a través de los endpoints públicos de la tienda de Steam (`store.steampowered.com/api`). Steam y el logotipo de Steam son marcas registradas de Valve Corporation. feed95 no está afiliado con Valve ni con Steam.

**Epic Games Store**
Los metadatos de Epic se obtienen a través del endpoint GraphQL público de la Epic Games Store. Este endpoint no está documentado oficialmente ni respaldado por Epic Games. feed95 no está afiliado con Epic Games.

**IGDB**
Los datos de videojuegos son provistos por [IGDB.com](https://www.igdb.com), propiedad de Twitch Interactive, Inc.

> Game data provided by IGDB.com

La API de IGDB es gratuita para proyectos no comerciales bajo los términos del [Twitch Developer Service Agreement](https://www.twitch.tv/p/legal/developer-agreement/). feed95 es un proyecto de código abierto sin monetización. Si realizas un fork comercial de este proyecto, deberás revisar los términos de uso de IGDB de forma independiente y considerar contactar a partner@igdb.com.

---

## English

### Features

- **Multiple local profiles** - Each profile has its own password, accent color, and image. Share a device without mixing catalogs.
- **100% offline** - Everything is stored in a local SQLite database. No accounts, no cloud, no required internet connection. Your data never leaves your device.
- **Automatic metadata search** - Import cover art, description, genres, and screenshots from Steam, Epic Games, or IGDB in one click.
- **Categories and filters** - Organize your catalog with custom categories. Filter by status, category, or text search.
- **Statuses and ratings** - Mark each game as Pending, Playing, Completed, or Abandoned. Rate from 1 to 10. Reorder your catalog manually.
- **Optional secondary catalog** - A second catalog separate from the main one, ideal for keeping distinct collections under the same profile.
- **Built-in launcher** - Link each game's executable and launch it directly from the app. Windows only.
- **Backup and restore** - Export your entire collection to a JSON file and import it on any device whenever you want.
- **Light / dark theme with custom accent** - The interface adapts to the color you choose for each profile.

### Download and Installation

**Android**

1. Download `feed95.apk` from the [Releases](https://github.com/SrFaper/feed95/releases) tab.
2. Open it on your device and allow installation from unknown sources if prompted.

**Windows**

1. Download `feed95-windows.zip` from the [Releases](https://github.com/SrFaper/feed95/releases) tab.
2. Extract the contents to any folder.
3. Run `feed95.exe`. No installation required.

### Metadata Search

feed95 can import game information from three sources:

| Source | Setup required |
|--------|---------------|
| Steam | No |
| Epic Games Store | No |
| IGDB | Yes, free Twitch Developer credentials |

To set up IGDB: visit [dev.twitch.tv](https://dev.twitch.tv), create an application, and enter your Client-ID and Client-Secret in the Settings section of the app.

### Built with

- [Flutter](https://flutter.dev/) - Cross-platform framework
- [SQLite / sqflite](https://pub.dev/packages/sqflite) - Local database
- [dio](https://pub.dev/packages/dio) + [cookie_jar](https://pub.dev/packages/cookie_jar) - HTTP requests
- [flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker) - Profile color picker
- [file_picker](https://pub.dev/packages/file_picker) / [image_picker](https://pub.dev/packages/image_picker) - File and image selection

### License

feed95 is distributed under the **GNU General Public License v3.0**. See the [`LICENSE`](LICENSE) file for details.

In practical terms: you can use, copy, modify, and distribute this software (including commercially), but any derivative version must also be distributed under GPL v3 with the source code available.

### Third-Party Notices and Attribution

feed95 uses data from external services to enrich the catalog. These services are not affiliated with this project and do not endorse it.

**Steam / Valve**
Steam game metadata is fetched through the public endpoints of the Steam store (`store.steampowered.com/api`). Steam and the Steam logo are registered trademarks of Valve Corporation. feed95 is not affiliated with Valve or Steam.

**Epic Games Store**
Epic metadata is fetched through the public GraphQL endpoint of the Epic Games Store. This endpoint is not officially documented or endorsed by Epic Games. feed95 is not affiliated with Epic Games.

**IGDB**
Video game data is provided by [IGDB.com](https://www.igdb.com), owned by Twitch Interactive, Inc.

> Game data provided by IGDB.com

The IGDB API is free for non-commercial projects under the terms of the [Twitch Developer Service Agreement](https://www.twitch.tv/p/legal/developer-agreement/). feed95 is a non-monetized open source project. If you create a commercial fork of this project, you must review IGDB's terms of use independently and consider reaching out to partner@igdb.com.

---

<div align="center">
feed95 &copy; 2026
</div>
