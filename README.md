<div align="center">

# FEED95

**Catálogo personal de videojuegos · Personal video game catalog · 个人游戏库**

*Sin cuentas. Sin servidores. Sin internet. Solo tus juegos, en tu dispositivo.*

[![Releases](https://img.shields.io/badge/releases-github-blue?style=flat-square&logo=github)](https://github.com/SrFaper/feed95/releases)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg?style=flat-square)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?style=flat-square&logo=flutter)](https://flutter.dev)

</div>

---

## 🌐 Idioma / Language / 语言

- [Español](#español)
- [English](#english)
- [中文](#中文)

---

## Español

### ¿Qué es feed95?

Una app para llevar el registro de tus videojuegos, disponible en Windows y Android. Sin cuentas, sin nube, sin rastreo - todo queda guardado localmente en tu dispositivo.

### Características

| | |
|---|---|
| **Perfiles locales** | Múltiples perfiles con imagen, color de acento y contraseña opcional. |
| **100% offline** | Base de datos SQLite local. Tus datos no salen de tu dispositivo. |
| **Metadatos automáticos** | Importa portada, descripción, géneros y capturas desde Steam, Epic Games o IGDB. |
| **Categorías y filtros** | Organiza con categorías personalizadas. Filtra por estado, categoría o texto. |
| **Estados y calificaciones** | Pendiente, Jugando, Completado o Abandonado. Puntúa del 1 al 10. Reordena a mano. |
| **Catálogo secundario** | Un segundo catálogo separado bajo el mismo perfil. |
| **Lanzador integrado** | Vincula el `.exe` de cada juego y árrancalo desde la app. Solo Windows. |
| **Backup y restauración** | Exporta e importa tu colección en JSON entre dispositivos. |
| **Tema claro / oscuro** | La interfaz se adapta al color de acento de cada perfil. |

### Descarga

| Plataforma | Archivo |
|---|---|
| Android | [`feed95.apk`](https://github.com/SrFaper/feed95/releases) |
| Windows | [`feed95-windows.zip`](https://github.com/SrFaper/feed95/releases) |

**Android:** descarga el APK y ábrelo. Permite instalación desde fuentes desconocidas si el sistema lo pide.

**Windows:** extrae el ZIP en cualquier carpeta y ejecuta `feed95.exe`. No requiere instalación.

### Metadatos de juegos

| Fuente | Configuración |
|---|---|
| Steam | No requiere |
| Epic Games Store | No requiere |
| IGDB | Credenciales gratuitas de Twitch Developer |

Para IGDB: visita [dev.twitch.tv](https://dev.twitch.tv), crea una aplicación y pega tu Client-ID y Client-Secret en **Configuraciones → IGDB** dentro de la app.

### Tecnologías

[Flutter](https://flutter.dev) · [SQLite/sqflite](https://pub.dev/packages/sqflite) · [dio](https://pub.dev/packages/dio) · [flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker) · [file_picker](https://pub.dev/packages/file_picker) · [image_picker](https://pub.dev/packages/image_picker)

### Licencia

Distribuido bajo **GNU GPL v3.0** - puedes usar, copiar, modificar y distribuir este software, pero cualquier versión derivada debe mantener la misma licencia con el código fuente disponible. Ver [`LICENSE`](LICENSE).

### Avisos de terceros

feed95 consume APIs externas para obtener metadatos. Ninguno de estos servicios está afiliado al proyecto.

- **Steam/Valve** - datos vía `store.steampowered.com/api`. Steam es marca registrada de Valve Corporation.
- **Epic Games Store** - datos vía endpoint GraphQL público. No oficial ni respaldado por Epic Games.
- **IGDB** - datos provistos por [IGDB.com](https://www.igdb.com), propiedad de Twitch Interactive, Inc. Gratuito para proyectos no comerciales bajo el [Twitch Developer Service Agreement](https://www.twitch.tv/p/legal/developer-agreement/). Forks comerciales deben revisar los términos de forma independiente.

> Game data provided by IGDB.com

---

## English

### What is feed95?

An app to track your video games, available on Windows and Android. No accounts, no cloud, no tracking - everything is stored locally on your device.

### Features

| | |
|---|---|
| **Local profiles** | Multiple profiles with image, accent color, and optional password. |
| **100% offline** | Local SQLite database. Your data never leaves your device. |
| **Automatic metadata** | Import cover art, description, genres, and screenshots from Steam, Epic Games, or IGDB. |
| **Categories & filters** | Organize with custom categories. Filter by status, category, or text. |
| **Statuses & ratings** | Pending, Playing, Completed, or Abandoned. Rate from 1 to 10. Reorder manually. |
| **Secondary catalog** | A second separate catalog under the same profile. |
| **Built-in launcher** | Link each game's `.exe` and launch it from the app. Windows only. |
| **Backup & restore** | Export and import your collection as JSON across devices. |
| **Light / dark theme** | The interface adapts to each profile's accent color. |

### Download

| Platform | File |
|---|---|
| Android | [`feed95.apk`](https://github.com/SrFaper/feed95/releases) |
| Windows | [`feed95-windows.zip`](https://github.com/SrFaper/feed95/releases) |

**Android:** download the APK and open it. Allow installation from unknown sources if prompted.

**Windows:** extract the ZIP to any folder and run `feed95.exe`. No installation required.

### Game metadata

| Source | Setup |
|---|---|
| Steam | Not required |
| Epic Games Store | Not required |
| IGDB | Free Twitch Developer credentials |

For IGDB: visit [dev.twitch.tv](https://dev.twitch.tv), create an application, and paste your Client-ID and Client-Secret in **Settings → IGDB** inside the app.

### Built with

[Flutter](https://flutter.dev) · [SQLite/sqflite](https://pub.dev/packages/sqflite) · [dio](https://pub.dev/packages/dio) · [flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker) · [file_picker](https://pub.dev/packages/file_picker) · [image_picker](https://pub.dev/packages/image_picker)

### License

Distributed under **GNU GPL v3.0** - you can use, copy, modify, and distribute this software, but any derivative version must keep the same license with source code available. See [`LICENSE`](LICENSE).

### Third-party notices

feed95 uses external APIs to fetch metadata. None of these services are affiliated with this project.

- **Steam/Valve** - data via `store.steampowered.com/api`. Steam is a registered trademark of Valve Corporation.
- **Epic Games Store** - data via public GraphQL endpoint. Not officially documented or endorsed by Epic Games.
- **IGDB** - data provided by [IGDB.com](https://www.igdb.com), owned by Twitch Interactive, Inc. Free for non-commercial projects under the [Twitch Developer Service Agreement](https://www.twitch.tv/p/legal/developer-agreement/). Commercial forks must review terms independently.

> Game data provided by IGDB.com

---

## 中文

### feed95 是什么？

一款用于记录你的游戏收藏的应用，支持 Windows 和 Android。无需账号，无需云端，无追踪 - 所有数据均保存在你的本地设备上。

### 功能特性

| | |
|---|---|
| **本地档案** | 支持多个档案，每个档案可设置头像、主题色和可选密码。 |
| **完全离线** | 基于本地 SQLite 数据库，数据不会离开你的设备。 |
| **自动获取元数据** | 从 Steam、Epic Games 或 IGDB 一键导入封面、简介、标签和截图。 |
| **分类与筛选** | 使用自定义分类整理游戏，按状态、分类或关键词筛选。 |
| **状态与评分** | 支持待玩、正在游玩、已通关、已弃坑四种状态，评分 1-10 分，支持手动排序。 |
| **副游戏库** | 在同一档案下创建一个独立的第二游戏库。 |
| **内置启动器** | 关联每款游戏的 `.exe` 文件，直接从应用内启动。仅限 Windows。 |
| **备份与恢复** | 将收藏导出为 JSON 文件，可在任意设备上导入恢复。 |
| **亮色 / 暗色主题** | 界面自动适配每个档案的主题色。 |

### 下载

| 平台 | 文件 |
|---|---|
| Android | [`feed95.apk`](https://github.com/SrFaper/feed95/releases) |
| Windows | [`feed95-windows.zip`](https://github.com/SrFaper/feed95/releases) |

**Android：** 下载 APK 后直接打开安装。如系统提示，请允许安装来自未知来源的应用。

**Windows：** 将 ZIP 解压到任意文件夹，运行 `feed95.exe` 即可，无需安装。

### 游戏元数据来源

| 来源 | 是否需要配置 |
|---|---|
| Steam | 无需配置 |
| Epic Games Store | 无需配置 |
| IGDB | 需要免费的 Twitch 开发者凭据 |

配置 IGDB：访问 [dev.twitch.tv](https://dev.twitch.tv)，创建一个应用，然后将 Client-ID 和 Client-Secret 填入应用内的 **设置 → IGDB**。

### 技术栈

[Flutter](https://flutter.dev) · [SQLite/sqflite](https://pub.dev/packages/sqflite) · [dio](https://pub.dev/packages/dio) · [flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker) · [file_picker](https://pub.dev/packages/file_picker) · [image_picker](https://pub.dev/packages/image_picker)

### 开源许可

本项目基于 **GNU GPL v3.0** 协议发布 - 你可以自由使用、复制、修改和分发本软件，但任何衍生版本必须保持相同的许可协议并公开源代码。详见 [`LICENSE`](LICENSE)。

### 第三方声明

feed95 使用外部 API 获取游戏元数据，以下服务均与本项目无关联。

- **Steam/Valve** - 数据来源：`store.steampowered.com/api`。Steam 是 Valve Corporation 的注册商标。
- **Epic Games Store** - 数据来源：Epic Games Store 公开 GraphQL 接口，非官方，Epic Games 不对此背书。
- **IGDB** - 游戏数据由 [IGDB.com](https://www.igdb.com)（Twitch Interactive, Inc. 旗下）提供，非商业项目可免费使用，详见 [Twitch 开发者服务协议](https://www.twitch.tv/p/legal/developer-agreement/)。商业 Fork 需独立审查相关条款。

> Game data provided by IGDB.com

---

<div align="center">
feed95 &copy; 2026 · <a href="LICENSE">GPL v3.0</a>
</div>
