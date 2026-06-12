<div align="center">

# feed95

**Catálogo personal de videojuegos para Windows y Android.**

Sin cuentas, sin servidores, sin internet. Solo tus juegos, en tu dispositivo.

[Descargar APK](https://github.com/SrFaper/feed95/releases/tag/beta) · [Descargar Windows](https://github.com/SrFaper/feed95/releases/tag/beta-windows) · [Ver Releases](https://github.com/SrFaper/feed95/releases)

</div>

---

## Características

- **Múltiples perfiles locales** — Cada perfil tiene su propia contraseña, color e imagen. Comparte el dispositivo sin mezclar catálogos.
- **100% offline** — Todo se guarda en una base de datos SQLite local. Sin cuentas, sin nube, sin conexión obligatoria.
- **Búsqueda automática de metadatos** — Importa portada, descripción y géneros directamente desde Steam, Epic Games o IGDB con un clic.
- **Estados y calificaciones** — Marca cada juego como Pendiente, Jugando, Completado o Abandonado. Puntúa del 1 al 10.
- **Catálogos separados** — Organiza tu colección con categorías y un catálogo secundario opcional.
- **Lanzador integrado** — Vincula el `.exe` de cada juego y árrancalo directo desde la app (Windows).
- **Backup y restauración** — Exporta toda tu colección a un JSON e impórtala cuando quieras, en cualquier dispositivo.
- **Tema claro / oscuro** — Con color de acento personalizable por perfil.

---

## Descarga e instalación

### Android
1. Descarga `feed95.apk` desde la sección de [Releases](https://github.com/SrFaper/feed95/releases).
2. Ábrelo en tu dispositivo. Si el sistema lo pide, permite la instalación desde fuentes desconocidas.

### Windows
1. Descarga `feed95-windows.zip` desde la sección de [Releases](https://github.com/SrFaper/feed95/releases).
2. Extrae el contenido en la carpeta que prefieras.
3. Ejecuta `feed95.exe`. No requiere instalación.

---

## Búsqueda de metadatos

feed95 puede importar información de juegos desde tres fuentes:

| Fuente | Requiere configuración |
|--------|----------------------|
| **Steam** | No |
| **Epic Games Store** | No |
| **IGDB** | Sí — credenciales gratuitas de Twitch Developer |

Para configurar IGDB: ve a [dev.twitch.tv](https://dev.twitch.tv), crea una aplicación y copia tu Client-ID y Client-Secret en *Configuraciones → IGDB*.

---

## Construido con

- [Flutter](https://flutter.dev/) — Framework multiplataforma
- [SQLite / sqflite](https://pub.dev/packages/sqflite) — Base de datos local
- [dio](https://pub.dev/packages/dio) + [cookie_jar](https://pub.dev/packages/cookie_jar) — Peticiones HTTP
- [flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker) — Selector de color de perfil
- [file_picker](https://pub.dev/packages/file_picker) / [image_picker](https://pub.dev/packages/image_picker) — Selección de archivos e imágenes

---

## Licencia

feed95 se distribuye bajo la licencia **GNU General Public License v3.0**.
Consulta el archivo [`LICENSE`](LICENSE) para más detalles.

En términos prácticos: puedes usar, copiar, modificar y distribuir este software (incluso comercialmente), pero cualquier versión derivada debe distribuirse también bajo GPL v3 con el código fuente disponible.

---

## Avisos de terceros y atribución

feed95 utiliza datos de servicios externos para enriquecer el catálogo. **Estos servicios no están afiliados al proyecto ni lo respaldan.**

### Steam / Valve
Los metadatos de juegos de Steam se obtienen a través de los endpoints públicos de la tienda de Steam (`store.steampowered.com/api`).
Steam y el logotipo de Steam son marcas registradas de Valve Corporation. feed95 no está afiliado con Valve ni con Steam.

### Epic Games Store
Los metadatos de Epic Games se obtienen a través del endpoint GraphQL público de la Epic Games Store. Este endpoint no está documentado oficialmente ni respaldado por Epic Games. feed95 no está afiliado con Epic Games.

### IGDB
Los metadatos de juegos provistos por IGDB se obtienen a través de la [API oficial de IGDB](https://api-docs.igdb.com/), propiedad de Twitch Interactive, Inc.

> Game data provided by IGDB.com

La API de IGDB es **gratuita para proyectos no comerciales** bajo los términos del [Twitch Developer Service Agreement](https://www.twitch.tv/p/legal/developer-agreement/). feed95 es un proyecto de código abierto sin monetización. Si haces un fork comercial de este proyecto, deberás revisar los términos de uso de IGDB de forma independiente.

---

## Download and Installation (English)

### Android
1. Download `feed95.apk` from the [Releases](https://github.com/SrFaper/feed95/releases) tab.
2. Open it on your device and allow installation from unknown sources if prompted.

### Windows
1. Download `feed95-windows.zip` from the [Releases](https://github.com/SrFaper/feed95/releases) tab.
2. Extract the contents to any folder and run `feed95.exe`. No installation required.

---

<div align="center">
feed95 © 2026
</div>
