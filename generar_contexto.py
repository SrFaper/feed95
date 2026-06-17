#!/usr/bin/env python3
"""
generar_contexto.py
Genera contexto_feed95.md con el contenido de los archivos relevantes del proyecto.
Uso: python generar_contexto.py [ruta_raiz_proyecto]
     Si no se pasa ruta, usa el directorio actual.
"""

import os
import sys

# ── Archivos a incluir (rutas relativas desde la raíz del repo) ──────────────
ARCHIVOS = [
    "README.md",
    ".github/workflows/build-apk.yml",
    ".github/workflows/build-exe.yml",
    "frontend/pubspec.yaml",
    "frontend/l10n.yaml",
    "frontend/lib/main.dart",
    # Modelos
    "frontend/lib/models/juego.dart",
    "frontend/lib/models/usuario.dart",
    "frontend/lib/models/categoria.dart",
    # Servicios
    "frontend/lib/services/api_service.dart",
    "frontend/lib/services/steam_service.dart",
    "frontend/lib/services/epic_service.dart",
    "frontend/lib/services/igdb_service.dart",
    "frontend/lib/services/f95_service.dart",
    # Screens
    "frontend/lib/screens/home_screen.dart",
    "frontend/lib/screens/juegos_screen.dart",
    "frontend/lib/screens/juego_detalle_screen.dart",
    "frontend/lib/screens/juego_form_screen.dart",
    "frontend/lib/screens/perfiles_screen.dart",
    "frontend/lib/screens/perfil_screen.dart",
    "frontend/lib/screens/registro_screen.dart",
    "frontend/lib/screens/login_screen.dart",
    "frontend/lib/screens/f95_config_screen.dart",
    "frontend/lib/screens/igdb_config_screen.dart",
    # Widgets
    "frontend/lib/widgets/avatar_usuario.dart",
    # Tests
    "frontend/test/api_service_test.dart",
    # Internacionalización
    "frontend/lib/l10n/app_es.arb",
    "frontend/lib/l10n/app_en.arb",
    "frontend/lib/l10n/app_zh.arb",
]

EXTENSION_LANG = {
    ".dart": "dart",
    ".yaml": "yaml",
    ".yml":  "yaml",
    ".md":   "markdown",
    ".json": "json",
    ".arb":  "json",
}

def leer_archivo(ruta_abs):
    try:
        with open(ruta_abs, encoding="utf-8") as f:
            return f.read()
    except FileNotFoundError:
        return None
    except Exception as e:
        return f"[Error leyendo archivo: {e}]"

def lang_para(ruta):
    _, ext = os.path.splitext(ruta)
    return EXTENSION_LANG.get(ext.lower(), "")

def main():
    raiz = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()
    raiz = os.path.abspath(raiz)
    salida = os.path.join(raiz, "contexto_feed95.md")

    lineas = ["# Contexto Feed95\n",
              "_Generado automáticamente. No editar a mano._\n\n"]

    incluidos = 0
    omitidos  = []

    for rel in ARCHIVOS:
        abs_path = os.path.join(raiz, rel.replace("/", os.sep))
        contenido = leer_archivo(abs_path)

        if contenido is None:
            omitidos.append(rel)
            continue

        lang = lang_para(rel)
        lineas.append(f"## `{rel}`\n\n")
        lineas.append(f"```{lang}\n")
        lineas.append(contenido)
        if not contenido.endswith("\n"):
            lineas.append("\n")
        lineas.append("```\n\n")
        incluidos += 1

    if omitidos:
        lineas.append("## Archivos no encontrados\n\n")
        for o in omitidos:
            lineas.append(f"- `{o}`\n")
        lineas.append("\n")

    with open(salida, "w", encoding="utf-8") as f:
        f.writelines(lineas)

    print(f"✓ {salida}")
    print(f"  Incluidos : {incluidos}")
    if omitidos:
        print(f"  Omitidos  : {len(omitidos)} (no encontrados)")
        for o in omitidos:
            print(f"    - {o}")

if __name__ == "__main__":
    main()
