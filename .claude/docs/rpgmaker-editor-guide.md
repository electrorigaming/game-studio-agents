# Guía de tareas del editor RPG Maker XP

Algunas tareas de La Base de Sky **no se hacen editando texto ni Ruby** — se hacen dentro del
editor gráfico de RPG Maker XP (una aplicación Windows con licencia propia, distinta de
`Game.exe`/mkxp-z que solo *ejecuta* el juego ya compilado). Ningún agente de este framework
puede manipular esa interfaz gráfica directamente. Cuando una tarea requiere el editor, el
agente debe **darle al usuario instrucciones paso a paso**, no intentar escribir o parchear los
archivos `.rxdata` binarios a mano.

**Cómo abrir el proyecto**: RPG Maker XP → *Archivo → Abrir proyecto* → selecciona el `.rxproj`
dentro de `../la-base-de-sky/LA BASE DE SKY/` (ver
`../wiki-la-base-de-sky/wiki_markdown/01-Inicio/01-Inicio/instalacion.md`).

## Tabla de referencia

| Tarea | Dónde en el editor | Página de wiki |
|-------|---------------------|-----------------|
| Animaciones de ataque (partículas, destellos, SE por movimiento) | `F9` (Base de Datos) → pestaña **Animations** | `03-Combate/01-Combate/animaciones-ataque.md` |
| Tilesets (passages, prioridades, terrain tags, autotiles) | `F9` (Base de Datos) → pestaña **Tilesets** | `05-Mundo/tilesets.md` |
| Pintar mapas (tiles, capas, colocar eventos) | Doble clic en un mapa del árbol de la izquierda | `05-Mundo/mapas.md`, `05-Mundo/mapas-ejemplo.md` |
| Colocar/configurar un evento en un mapa (gráfico, movimiento, disparador) | Doble clic en el mapa → doble clic en la casilla → editor de eventos | `05-Mundo/eventos.md` (los *script calls* que van dentro del evento están cubiertos por `.claude/rules/rpgmaker-events.md`) |
| Música de la pantalla de título (Title BGM) y ajustes generales del proyecto | `F9` (Base de Datos) → pestaña **System** | `06-Ubicaciones/intro-juego.md` |
| Imagen de la pantalla de título | Colocar el archivo directamente en `Graphics/Titles1/` — no requiere entrada en Base de Datos | `06-Ubicaciones/intro-juego.md` |
| Cualquier gráfico nuevo (personajes, tilesets, iconos, battlers, UI...) | Copiar el archivo directamente en la subcarpeta de `Graphics/` correspondiente (ver tabla de convenciones en `.claude/docs/technical-preferences.md`) — este proyecto usa carpetas sueltas, no un Resource Manager con archivo empaquetado | — |

**No se usan** las pestañas clásicas de RPG Maker XP `Actors`, `Classes`, `Skills`, `Troops`,
`Items`, `Weapons`, `Armors` — Pokémon Essentials reemplaza todo ese contenido con datos PBS
(`pokemon.txt`, `moves.txt`, `trainers.txt`, `items.txt`...). Verificado: solo hay una referencia
residual a `$data_actors` en todo el código base, en el manejador genérico del comando de evento
"Cambiar Nombre de Héroe" (`Data/Scripts/009_Game processing/005_Interpreter_Commands.rb:1092`),
sin uso práctico en el gameplay de Pokémon.

## Cómo dar las instrucciones

Cuando una tarea requiera el editor, sigue este patrón (ejemplo real):

> "Esto se configura en el editor de RPG Maker XP, no en un archivo de texto. Pasos:
> 1. Abre RPG Maker XP con el proyecto cargado.
> 2. Pulsa `F9` para abrir la Base de Datos.
> 3. Ve a la pestaña **Animations**.
> 4. [...pasos específicos de la tarea...]
> 5. Guarda el proyecto (`Ctrl+S`).
> Cuando termines, avísame y seguimos con [siguiente paso relacionado, p. ej. vincular la
> animación al movimiento en `moves.txt`]."

Después de que el usuario confirme que hizo el cambio en el editor, continúa con cualquier parte
que sí sea texto/PBS/script (p. ej. crear el movimiento en `moves.txt` que referencia la
animación por nombre).
