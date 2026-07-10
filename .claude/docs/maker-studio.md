# Maker Studio — segundo editor del proyecto

Maker Studio (https://github.com/Toskan4134/maker-studio) es un editor de mapas moderno,
reemplazo del editor gráfico de RPG Maker XP, que **lee y escribe los `.rxdata` directamente**
(sin conversión). App de escritorio (Tauri) para Windows/macOS/Linux, con paneles acoplables,
pinceles multi-tile, capas extendidas, multi-tileset, sombras, editor de eventos completo,
simulador del juego integrado y mods en JavaScript. Convive con RPG Maker XP: ambos editan
el mismo proyecto.

**Estado en este proyecto**: adoptado el 2026-07-10. Fork y clon hechos (`../maker-studio`).
Plugin del juego AÚN NO instalado (pendiente de la primera rama `game/*`). Prueba de
convivencia de re-guardado AÚN NO ejecutada (ver protocolo más abajo).

## Repos y modelo de actualización

| | valor |
|---|---|
| `origin` | `electrorigaming/maker-studio` (tu fork, GitHub) |
| `upstream` | `Toskan4134/maker-studio` (autor, GitHub) |
| Clon local | `../maker-studio` (carpeta hermana, como los demás repos) |
| Contenido | Solo docs + integraciones + releases — el código fuente del editor es privado |
| Licencia | GPL-3.0 (lo publicado: plugin Ruby + docs) |

`main` solo recibe de `upstream` (mismo principio que los otros repos). No hay ramas de
adaptación ni de juego aquí: lo que se instala en un juego es una COPIA del plugin, que vive
en la rama `game/*` de `la-base-de-sky`. Flujo de actualización: Paso 5 de
`.claude/docs/actualizaciones-la-base-de-sky.md`.

## Instalación (documentada — ejecutar cuando exista la rama `game/*`)

1. **App del editor** (manual, una vez): instalador desde
   https://github.com/Toskan4134/maker-studio/releases/latest (sin firmar — SmartScreen
   avisará la primera vez). Se auto-actualiza sola.
2. **Plugin del juego**: copiar
   `../maker-studio/Integrations/[LBDS1.2.0] Maker Studio/MakerStudio/` →
   `../la-base-de-sky/LA BASE DE SKY/Plugins/MakerStudio/`.
   - Requiere La Base de Sky **v1.2.0+** (la base actual es v1.2.0.1 ✓).
   - Se committea SOLO en la rama `game/[nombre]` — nunca en `main` (que espeja al upstream).
   - La carpeta debe llamarse exactamente `MakerStudio`.
3. **Abrirlo**: desde la app (seleccionar la carpeta con `Game.exe`) o, con el plugin
   instalado, desde el juego en modo Debug → F9 → "Maker Studio… → Open Maker Studio".

## Qué cubre cada editor

| Tarea | RPG Maker XP | Maker Studio |
|---|---|---|
| Pintar mapas, capas, autotiles | Sí | Sí (+ capas extendidas ilimitadas) |
| Eventos en mapa | Sí | Sí (editor completo) |
| Tilesets (passages, prioridades, terrain tags) | Sí | Sí (Database → Tilesets) |
| Switches / Variables / Eventos Comunes | Sí | Sí |
| Animaciones de batalla | Sí | Sí (con tweening y batch extra) |
| System (Title BGM, ajustes del proyecto) | Sí | **No** (pestaña deshabilitada) |
| Scripts (`Scripts.rxdata`) | Sí | Sí (+ "Open in VS Code" para scripts extraídos) |
| Actors/Items/etc. | No se usan (PBS los reemplaza) | Deshabilitadas |

Funciones **exclusivas de Maker Studio** (marcadas con badge "MS" en su interfaz): capas
extendidas, sombras dinámicas, fogs múltiples, Map Versions (variantes de mapa por
switch/variable), simulador integrado, mods JS. Todas requieren el plugin `MakerStudio`
en el juego; sin él, el juego simplemente las ignora.

## Reglas de convivencia con RPG Maker XP

- Ambos escriben los mismos `.rxdata`: **no tengas el mismo mapa abierto en los dos a la vez**.
- Los datos exclusivos MS se guardan como adiciones puras (`@extended_layers`) dentro del
  `.rxdata`; los mapas siguen ABRIENDO bien en RPG Maker XP.
- ⚠️ **Riesgo pendiente de verificar**: re-GUARDAR desde RPG Maker XP un mapa que ya tiene
  datos MS podría descartar `@extended_layers` (no documentado por el autor). Hasta
  verificarlo, regla práctica: **mapa tocado con funciones MS → se edita solo en Maker Studio**.
- Red de seguridad: cada guardado de MS respalda en `Data/map-backups/` (últimos 10 por
  archivo) y `Data/Scripts.rxdata.bak`.

### Protocolo de prueba de convivencia (pendiente)

1. Con el plugin instalado, crear un mapa desechable en Maker Studio; añadir una capa
   extendida y una sombra; guardar.
2. Abrir el proyecto en RPG Maker XP, editar un tile cualquiera de ESE mapa, guardar y cerrar.
3. Reabrir el mapa en Maker Studio: ¿siguen la capa extendida y la sombra?
   - **Sí** → convivencia total; actualizar este doc y borrar la regla práctica.
   - **No** → confirmado: mapas con funciones MS se editan solo en MS; actualizar este doc.
4. Arrancar `Game.exe` (Debug) y verificar que el mapa carga sin errores.

## Documentación

- `../maker-studio/docs/es/` — guías de usuario **en español** (local)
- https://makerstudio.toskan.es — docs online
- https://github.com/Toskan4134/maker-studio-mods — API de mods JS
