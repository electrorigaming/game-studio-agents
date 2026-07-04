# Plan de Implementación con Claude Code
## Adaptación de game-studio-agents para La Base de Sky (Pokémon Essentials v21.1/v22)

**Fecha**: 2026-07-04
**Base**: Consolida y corrige `PLAN-ADAPTACION.md`, integra la evaluación de 7 skills externas y convierte las 7 fases en sesiones ejecutables de Claude Code.

---

## Parte 1 — Evaluación de las 7 skills externas

### Resumen

| # | Skill | Veredicto | Modo de uso |
|---|-------|-----------|-------------|
| 1 | **Everything Claude Code (ECC)** | ⚠️ No instalar el plugin | Solo `AgentShield` vía `npx` como auditoría puntual en Fase 7 |
| 2 | **Find Skills (vercel-labs/skills)** | ✅ Adoptar | Herramienta de gestión (`npx skills`) para instalar/actualizar las demás skills |
| 3 | **Superpowers** | ⚠️ Adopción parcial | 3 skills sueltas: `systematic-debugging`, `verification-before-completion`, `writing-skills`. NO el plugin completo |
| 4 | **UI UX Pro Max** | ❌ Descartar | UI web/móvil; no aplica a MUI/RGSS |
| 5 | **Karpathy Guidelines** | ✅ Adoptar | Anexar los 4 principios al `CLAUDE.md` adaptado |
| 6 | **Spec-Kit** | 🔶 Diferir | Opt-in post-adaptación, solo para features grandes (plugins complejos) |
| 7 | **PixelRAG** | ❌ Descartar | RAG visual con GPU; la wiki ya está en markdown local (Grep basta) |

### 1.1 Find Skills (`vercel-labs/skills`) — ✅ ADOPTAR como herramienta

No es una skill de conocimiento sino el CLI del ecosistema de skills (`npx skills add/find/list/update/remove`). Detecta Claude Code, instala en `.claude/skills/` (mismo layout que usa el framework) y permite instalación selectiva por nombre — exactamente lo que se necesita para traer solo las piezas útiles de Superpowers sin arrastrar el resto.

**Costo de contexto: cero** (es tooling de terminal, no inyecta nada en las sesiones).

```bash
# Uso principal en este proyecto
npx skills add obra/superpowers --skill systematic-debugging \
  --skill verification-before-completion --skill writing-skills \
  -a claude-code -y

npx skills list      # auditar lo instalado
npx skills update    # mantener al día
```

### 1.2 Karpathy Guidelines (`multica-ai/andrej-karpathy-skills`) — ✅ ADOPTAR

Un único archivo (~70-100 líneas) con 4 principios: **Think Before Coding** (declarar supuestos, preguntar ante ambigüedad), **Simplicity First** (mínimo código que resuelve el problema), **Surgical Changes** (tocar solo lo necesario, respetar código que no se entiende) y **Goal-Driven Execution** (criterios de éxito verificables + loop).

**Por qué encaja**: "Surgical Changes" es literalmente la disciplina requerida al trabajar sobre los scripts core de Essentials (usar `alias`, no reescribir; no borrar código ajeno "de paso"). Y "Think Before Coding" refuerza el protocolo existente del framework (Pregunta → Opciones → Decisión → Borrador → Aprobación) en lugar de competir con él.

**Integración recomendada**: anexar al final del `CLAUDE.md` adaptado (no instalar como plugin, para mantener una sola fuente de verdad versionada en el fork). Se descarga una vez y se pega en la Sesión 5.

### 1.3 Superpowers (`obra/superpowers`) — ⚠️ ADOPCIÓN PARCIAL

El plugin completo instala una **metodología entera** (brainstorming → worktrees → writing-plans → subagent-driven development → TDD) con hook de inicio de sesión que inyecta su bootstrap. Eso **colisiona directamente** con el ciclo de vida propio de game-studio-agents (49 agentes jerárquicos, su propio `/brainstorm`, modos de revisión `full/lean/solo`, protocolo de aprobación). Instalar ambos = dos metodologías peleando por dirigir la sesión.

Sin embargo, 3 de sus skills son **neutrales a la metodología** y de altísimo valor aquí:

| Skill | Por qué sirve en este proyecto |
|-------|-------------------------------|
| `systematic-debugging` | Depurar RGSS/mkxp sin debugger real es doloroso; el proceso de 4 fases de causa raíz aplica perfecto a crashes de `Scripts.rxdata` |
| `verification-before-completion` | Obliga a verificar (compilar PBS, arrancar `Game.exe`) antes de declarar "listo" — clave con un motor que falla en runtime |
| `writing-skills` | Metodología para escribir las **4 skills nuevas del framework** (Fase 4) con calidad de producción |

**Descartar de Superpowers**: `test-driven-development` (RGSS no trae harness de tests), `using-git-worktrees` y `subagent-driven-development` (el framework ya orquesta subagentes a su manera).

### 1.4 Everything Claude Code / ECC (`affaan-m/ECC`) — ⚠️ NO instalar el plugin; usar AgentShield puntualmente

ECC es enorme: 67 agentes, ~271 skills, hooks, reglas multi-lenguaje (TS/Python/Go/Java/Rust...) orientados a desarrollo web/backend genérico. Instalarlo junto al framework de 49 agentes + 73 skills produciría:

- **Colisión de hooks** (ambos registran hooks de sesión/herramientas).
- **Duplicación de flujos** (`/plan`, `/code-review`, agentes reviewer vs. los del framework).
- **Consumo masivo de contexto** — el propio README de ECC advierte que demasiadas superficies reducen la ventana efectiva.
- Cero contenido específico de Ruby/RGSS/RPG Maker.

**Uso quirúrgico que SÍ vale la pena**: su herramienta de seguridad **AgentShield** audita configuraciones de Claude Code (`CLAUDE.md`, `settings.json`, hooks, agentes, skills) buscando errores de configuración, secretos e inyecciones — exactamente el tipo de artefacto que esta adaptación produce. Se ejecuta sin instalar nada permanente:

```bash
cd game-studio-agents
npx ecc-agentshield scan            # auditoría en Fase 7
npx ecc-agentshield scan --fix      # autocorregir hallazgos seguros
```

Opcional a futuro (no ahora): `continuous-learning-v2` para extraer patrones de sesiones.

### 1.5 Spec-Kit (`github/spec-kit`) — 🔶 DIFERIR (opt-in para features grandes)

Metodología spec-driven con CLI `specify` y comandos `/speckit.constitution|specify|clarify|plan|tasks|implement|analyze|checklist`. Solapa funcionalmente con `/brainstorm` + `/design-system` + las plantillas GDD del framework. Sus comandos van con namespace `/speckit.*`, así que **no colisiona técnicamente**, pero adoptar dos metodologías de diseño durante la adaptación añade ruido sin beneficio.

**Recomendación**: no usarlo para la adaptación del framework. Reevaluarlo **después** (checkpoint al cierre de la Sesión 6) para features grandes y acotadas — p. ej. un plugin de sistema de misiones o un minijuego — donde `constitution → spec → clarify → tasks → implement` aporta trazabilidad real. Si se adopta entonces:

- `/speckit.constitution` debe codificar los principios del proyecto: *la wiki es ley*, sintaxis PBS estricta, prohibido modificar scripts core (solo `alias`/plugins), aprobación humana antes de escribir.
- Los `specs/` generados viven en el repo del juego (rama `juego-*`), no en el framework.

### 1.6 UI UX Pro Max — ❌ DESCARTAR

Genera design systems para stacks web/móvil (React, Next.js, Vue, Tailwind, SwiftUI, Flutter, JavaFX...): 67 estilos de UI web, paletas, tipografías de Google Fonts, checklists de accesibilidad WCAG. **Nada de eso aplica** a la UI del juego: MUI (Modular UI de La Base de Sky) es Ruby/RGSS sobre sprites y bitmaps a resolución de RPG Maker XP. Las decisiones de UI del juego se rigen por `wiki_markdown/04-Interfaz/`, no por Tailwind.

Único caso marginal futuro: si se construye una **web promocional** del juego. Anotarlo y descartar por ahora.

### 1.7 PixelRAG (`StarTrail-org/PixelRAG`) — ❌ DESCARTAR

Framework de RAG visual: renderiza documentos web/PDF como screenshots, los embebe con Qwen3-VL (requiere **GPU CUDA**), indexa en FAISS y sirve una API de búsqueda. Proyecto muy temprano (28 stars, sin releases).

Por qué no aplica:

1. La wiki **ya está descargada en markdown local** (`wiki_markdown/`). `Grep`/`Glob` sobre texto es la estrategia de recuperación correcta: determinista, gratuita, sin GPU y sin índice que mantener.
2. Su plugin de Claude Code solo captura **páginas web/PDF**, no la ventana de `Game.exe`, así que tampoco sirve para verificar visualmente el juego.
3. Añadiría una dependencia pesada (Playwright + modelo VLM + FAISS) para resolver un problema que no existe.

---

## Parte 2 — Revisión del PLAN-ADAPTACION.md: correcciones obligatorias antes de implementar

El plan existente es sólido en estrategia de repos, fases y listas de archivos. Estos hallazgos deben corregirse **durante** la implementación (están integrados en los prompts de la Parte 3):

### C1 · Sintaxis PBS inconsistente en el borrador de reglas
El borrador de `pbs-files.md` dice "fields are `key: value`" pero sus ejemplos usan `Key = Value`. En Essentials v20+ (por tanto v21.1/v22) el formato es `Clave = Valor`. **Regla de oro**: la sesión que escriba `pbs-files.md` debe leer primero 3-4 archivos PBS reales de `la-base-de-sky/.../PBS/` y la página `08-Herramientas/pbs.md` de la wiki, y derivar la sintaxis de ahí — nunca de memoria del modelo ni del borrador.

### C2 · Versión de Ruby probablemente incorrecta
El borrador fija "compatible with Ruby 1.9.3 (RPG Maker XP version)". El RGSS clásico de RMXP es Ruby 1.8.x, y Essentials moderno (v20+) corre sobre **mkxp-z con Ruby 3.x**. Además el plan lista `RGSS104E.dll` (runtime clásico), lo que contradice lo anterior. **Acción**: la Sesión 1 debe detectar el runtime real (buscar `mkxp.json`, DLLs x64, versión declarada en scripts) y esa versión detectada es la que se escribe en `ruby-scripts.md`.

### C3 · API de eventos desactualizada en el borrador de plugins
`essentials-plugins.md` (borrador) usa `Events.onBattleStart += proc {...}` — API de v17/v18. En v20+ fue reemplazada por `EventHandlers.add(:on_xyz, :nombre, proc {...})`. **Acción**: verificar la API real en los scripts extraídos y en la wiki antes de escribir la regla; usar la forma encontrada.

### C4 · Llamadas con prefijo `Kernel.` obsoletas
`Kernel.pbMessageDisplay` y similares perdieron el prefijo en versiones modernas (`pbMessage` a secas). Mismo tratamiento que C1/C3: derivar de código real.

### C5 · Entorno Windows y hooks POSIX
`Game.exe` corre en Windows; los 12 hooks del framework son `sh` POSIX. **Acción en Sesión 1**: verificar que los hooks corren bajo Git Bash en Windows y que `ruby` está en el PATH para `scripts_extract.rb`/`scripts_combine.rb` (o documentar el método oficial de la base si es otro).

### C6 · Rutas de wiki hipotéticas
Las rutas del plan (`04-Interfaz/mui-interfaz.md`, `08-Herramientas/pbs.md`, etc.) son plausibles pero no verificadas. **Acción**: toda ruta de wiki escrita en un agente, regla o skill debe validarse con `Glob` en el momento de escribirla. El índice `wiki-reference.md` (Sesión 1) se genera exclusivamente desde el árbol real de `wiki_markdown/`.

### C7 · Regla de eventos apunta a archivos inexistentes
`rpgmaker-events.md` (borrador) declara `paths: Data/Events/*.json` — RMXP guarda los eventos **dentro** de `MapXXX.rxdata` (binario), no en JSON editable. **Acción**: redefinir la regla como guía de *script calls dentro de eventos* (aplicable cuando un agente sugiere código para pegar en el editor de RPG Maker) con scope en `**/*.rb` y documentación, o fusionarla con `ruby-scripts.md`.

---

## Parte 3 — Plan de ejecución: sesiones de Claude Code

### Principios transversales

1. **Una sesión = una fase = un commit revisable** en la rama `adapted-essentials` del fork de `game-studio-agents`.
2. **Claude Code se lanza desde `game-studio-agents/`**, no desde la raíz del workspace: los agentes, skills, hooks y reglas de `.claude/` solo se descubren cuando ese directorio es la raíz del proyecto (no se cargan desde subcarpetas). El acceso a los repos hermanos se otorga con `--add-dir` o, de forma permanente, con `permissions.additionalDirectories` en `.claude/settings.json` (se configura en la Sesión 0). **Consecuencia**: toda ruta hacia los otros repos se escribe relativa al framework: `../la-base-de-sky/...`, `../wiki-la-base-de-sky/...`, `../prompts/...`.
3. **Anti-alucinación**: ningún agente/regla/skill afirma sintaxis, API o rutas sin haber leído primero la fuente (archivo PBS real, script `.rb`, página de wiki verificada con `Glob`). Esto neutraliza C1-C4 y C6.
4. **Cada sesión termina verificando sus criterios de aceptación** antes de commitear (`verification-before-completion` aplica desde la Sesión 1).
5. Los prompts de abajo se pegan tal cual al iniciar cada sesión (ajustar rutas si el workspace difiere).

---

### Sesión 0 — Preparación del entorno (manual + terminal, sin Claude Code)

**Objetivo**: repos configurados y skills externas instaladas.

```bash
# 1. Repos (seguir la sección "Estrategia de Repositorios" de PLAN-ADAPTACION.md):
#    - Fork de Claude-Code-Game-Studios → remotes origin/upstream + rama adapted-essentials
#    - Fork de La-Base-de-Sky (GitLab) → remotes + rama base limpia
#    - git init + primer push de wiki-la-base-de-sky (con .gitignore, requirements.txt, README)

# 2. Skills externas seleccionadas (Superpowers parcial, vía Find Skills).
#    Scope por defecto = PROYECTO: instala en ./.claude/skills/ y queda versionado en
#    el fork. --copy fuerza archivos reales en vez de symlinks (evita problemas con
#    git en Windows). NO usar -g (eso las mandaría a ~/.claude, fuera del repo).
cd game-studio-agents
npx skills add obra/superpowers \
  --skill systematic-debugging \
  --skill verification-before-completion \
  --skill writing-skills \
  -a claude-code --copy -y

# 3. Descargar guías Karpathy al workspace (se anexan a CLAUDE.md en la Sesión 5):
curl -L https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md \
  -o ../prompts/karpathy-guidelines.md

# 4. Dar acceso permanente a los repos hermanos: añadir en
#    game-studio-agents/.claude/settings.json →
#    "permissions": { "additionalDirectories": ["../la-base-de-sky", "../wiki-la-base-de-sky", "../prompts"] }
#    (o, si se prefiere no tocar settings.json aún, lanzar cada sesión con:
#     claude --add-dir ../la-base-de-sky --add-dir ../wiki-la-base-de-sky --add-dir ../prompts)

# 5. Verificar herramientas:
git --version && ruby -v && claude --version   # Claude Code >= 2.1
```

**Criterios de aceptación**: las carpetas `systematic-debugging/`, `verification-before-completion/` y `writing-skills/` existen como archivos reales (no symlinks) dentro de `game-studio-agents/.claude/skills/` y `npx skills list` las muestra con scope de proyecto; los 3 repos responden a `git remote -v` con origin (fork propio) y upstream (original); `prompts/karpathy-guidelines.md` existe; al lanzar `claude` desde `game-studio-agents/` los slash commands del framework aparecen disponibles y Claude puede listar `../wiki-la-base-de-sky/wiki_markdown/` sin pedir permiso extra.

---

### Sesión 1 — Fase 1: Diagnóstico e infraestructura

**Objetivo**: inventario verificado del terreno real antes de tocar nada.

**Prompt para Claude Code**:

```text
Fase 1 de la adaptación (contexto en ../prompts/cc.md y ../AGENTS.md; los repos hermanos
están en ../la-base-de-sky y ../wiki-la-base-de-sky). NO modifiques todavía ningún
agente, regla ni skill. Genera dos entregables:

A) production/diagnostico-essentials.md con:
   1. Auditoría de .claude/agents/: lista completa de agentes con
      clasificación MANTENER / ADAPTAR / DESACTIVAR y una línea de justificación.
   2. Estado de scripts de La Base de Sky (../la-base-de-sky): ¿existen .rb extraídos o
      solo Data/Scripts.rxdata?
      ¿Funcionan scripts_extract.rb y scripts_combine.rb? Ejecuta la extracción en una
      copia de prueba y reporta el resultado (cantidad de archivos, errores).
   3. Runtime real: busca mkxp.json, DLLs, y la versión de Ruby que usa la base
      (mkxp-z/Ruby 3.x vs RGSS clásico). Esta versión gobernará las reglas de la Fase 3.
   4. Inventario PBS: lista los archivos de PBS/ con conteo de secciones de 2-3 de ellos,
      y transcribe 10 líneas reales de pokemon.txt y moves.txt como muestra de sintaxis.
   5. API vigente: busca en los scripts si el sistema de eventos usa EventHandlers.add o
      Events.onXYZ, y si las llamadas usan prefijo Kernel. o no. Cita archivo y línea.
   6. Hooks en Windows: ejecuta los 12 hooks de .claude/hooks/ bajo el shell disponible y
      reporta cuáles corren limpios.

B) .claude/docs/wiki-reference.md: índice de referencia generado EXCLUSIVAMENTE con
   Glob sobre ../wiki-la-base-de-sky/wiki_markdown/ (solo rutas que existen). Escribe
   TODAS las rutas en formato ../wiki-la-base-de-sky/wiki_markdown/... para que
   funcionen desde la raíz del framework. Organiza por dominio de agente:
   02-Pokemon → essentials-specialist + pbs-compiler-specialist; 03-Combate →
   essentials-specialist + level-designer; 04-Interfaz → ui-programmer; 05-Mundo →
   level-designer; 08-Herramientas → pbs-compiler-specialist + ruby-rgss-specialist.

Protocolo: muéstrame el borrador de cada archivo y pide aprobación antes de escribir.
```

**Criterios de aceptación**: el diagnóstico responde las 6 preguntas con evidencia (rutas y líneas citadas); `wiki-reference.md` no contiene ninguna ruta inexistente (verificar con un spot-check de 5 rutas); commit `fase-1: diagnostico e indice de wiki`.

---

### Sesión 2 — Fase 2: Definición de agentes

**Objetivo**: 3 agentes nuevos, 4 adaptados, 15 desactivados.

**Prompt para Claude Code**:

```text
Fase 2. Lee primero production/diagnostico-essentials.md y .claude/docs/wiki-reference.md.
Usa la skill writing-skills como guía de calidad para redactar.

1. DESACTIVAR: mueve a .claude/agents/disabled/ los 15 agentes de motor identificados en
   el diagnóstico (godot-*, unity-*, unreal-*/ue-*).

2. CREAR (frontmatter YAML + system prompt, siguiendo el formato de los agentes existentes):
   - essentials-specialist.md: arquitectura de Pokémon Essentials, eventos RPG Maker,
     variables globales ($game_player, $player, $game_map...) según lo hallado en el
     diagnóstico. Reporta a lead-programmer.
   - ruby-rgss-specialist.md: Ruby en la versión DETECTADA en la Fase 1, API RGSS/mkxp,
     orden de carga de scripts, desarrollo de plugins, dispose de Sprite/Viewport/Bitmap.
   - pbs-compiler-specialist.md: sintaxis PBS real (la de las muestras del diagnóstico),
     validación de IDs y referencias cruzadas, compilación.
   Los tres DEBEN incluir una sección "Fuentes de Referencia Obligatorias" con rutas
   tomadas de wiki-reference.md, y el protocolo Pregunta → Opciones → Decisión →
   Borrador → Aprobación.

3. ADAPTAR: level-designer.md (mapas/tilesets/eventos RMXP, refs a 05-Mundo/),
   gameplay-programmer.md (Ruby/RGSS en vez de GDScript/C#, refs a 03-Combate/),
   ui-programmer.md (MUI en vez de Godot/Unity UI, refs a 04-Interfaz/),
   lead-programmer.md (routing hacia los 3 especialistas nuevos).

Borrador + aprobación por archivo. Al final, verifica que ningún agente activo mencione
Unity, Godot ni Unreal (grep) y que todas las rutas de wiki citadas existan.
```

**Criterios de aceptación**: `ls .claude/agents/*.md | wc -l` = 49 − 15 + 3; `grep -ril "unity\|godot\|unreal" .claude/agents/ --exclude-dir=disabled` vacío; frontmatter parseable en los 3 nuevos; commit `fase-2: agentes essentials`.

---

### Sesión 3 — Fase 3: Reglas de codificación

**Objetivo**: 4 reglas nuevas derivadas de fuentes reales, 2 adaptadas, 2 eliminadas. Aplica C1, C2, C3, C4 y C7.

**Prompt para Claude Code**:

```text
Fase 3. Antes de escribir CADA regla, lee la fuente primaria correspondiente y cita de
dónde sale cada afirmación:

1. .claude/rules/pbs-files.md (paths: PBS/*.txt): lee pokemon.txt, moves.txt,
   trainers.txt y encounters.txt reales + la página de PBS de la wiki
   (08-Herramientas, ruta según wiki-reference.md). Deriva de ahí: formato de sección
   [ID], separador clave = valor, listas, comentarios, campos obligatorios por archivo.
   Incluye 1 ejemplo correcto COPIADO de un archivo real y 3 violaciones típicas.

2. .claude/rules/ruby-scripts.md (paths: **/*.rb): versión de Ruby = la detectada en el
   diagnóstico (NO asumas 1.9.3). Reglas: dispose obligatorio de Sprite/Viewport/Bitmap,
   alias en vez de redefinir métodos core, no monkey-patching de scripts base, orden de
   carga, cuidado con update por frame, uso de pbMessage según la forma vigente hallada.

3. .claude/rules/essentials-plugins.md (paths: Plugins/**/*.rb): estructura
   Plugins/[Nombre]/, registro con PluginManager según meta.txt o el mecanismo real de
   la base, hooks de eventos con la API VIGENTE detectada (EventHandlers.add u otra),
   símbolos :SPECIES/:MOVE/:ITEM en vez de IDs, compatibilidad con guardado.

4. .claude/rules/rpgmaker-events.md: REDEFINIDA como guía de script calls dentro de
   eventos de RPG Maker (los eventos viven en Map*.rxdata binario, no hay JSON):
   pbTransferPlayer, $game_switches/$game_variables, pbFadeOutIn, etc., verificando cada
   función contra los scripts o la wiki. Scope: documentación y snippets que los agentes
   propongan para pegar en el editor.

5. ADAPTAR gameplay-code.md (Ruby en vez de GDScript, PBS en vez de config files,
   EventHandlers en vez de signals) y ui-code.md (MUI, ref a 04-Interfaz/).

6. ELIMINAR shader-code.md y network-code.md (mover a disabled/ o borrar).

Borrador + aprobación por archivo.
```

**Criterios de aceptación**: cada regla nueva cita al menos una fuente (archivo PBS/script/página wiki) que existe; los ejemplos de `pbs-files.md` coinciden carácter a carácter con el formato de los PBS reales; commit `fase-3: reglas rpgmaker/essentials`.

---

### Sesión 4 — Fase 4: Skills del framework

**Objetivo**: 4 skills nuevos, 4 modificados.

**Prompt para Claude Code**:

```text
Fase 4. Usa writing-skills como guía. Sigue el formato SKILL.md del framework
(.claude/skills/*/SKILL.md).

CREAR:
1. setup-essentials: verificar instalación de la base (Game.exe, PBS/, scripts_extract.rb),
   actualizar CLAUDE.md y technical-preferences.md con el stack (pedir permiso), tabla de
   routing por extensión de archivo (PBS/*.txt → pbs-compiler-specialist; **/*.rb →
   ruby-rgss-specialist; Plugins/** → ruby-rgss-specialist; mapas/eventos →
   level-designer; assets → essentials-specialist), ofrecer probar /extract-scripts.
2. extract-scripts: verificar entorno → ejecutar ruby scripts_extract.rb en la carpeta de
   la base → verificar cantidad de .rb extraídos → resumen. Usa la invocación exacta que
   funcionó en el diagnóstico de la Fase 1.
3. combine-scripts: backup de Data/Scripts.rxdata → ruby scripts_combine.rb → comparar
   tamaños → resumen con recordatorio de probar el juego.
4. validate-pbs: además del SKILL.md, crea un script determinista
   (scripts/validate_pbs.rb o .py) que valide sintaxis de sección, IDs duplicados y
   referencias cruzadas (Evolutions→especies, movimientos de trainers→moves.txt...)
   usando el formato REAL derivado en la Fase 3. El skill lo ejecuta y formatea el
   reporte con veredicto COMPLETE / NEEDS FIXES.

MODIFICAR:
5. setup-engine: eliminar selección Godot/Unity/Unreal; redirigir a /setup-essentials.
6. brainstorm: sugerencias acotadas a mecánicas Pokémon (tipos, stats, habilidades,
   fórmulas de Essentials); consultar wiki antes de proponer.
7. design-system: plantillas GDD con bloque "PBS Entry" en formato real y referencia de
   wiki por sección.
8. code-review: revisar Ruby/RGSS + sintaxis PBS + uso correcto de variables globales;
   invocar validate_pbs cuando el cambio toque PBS/.

Borrador + aprobación por skill. Al final ejecuta /validate-pbs contra los PBS reales de
la base: debe salir limpio (la base oficial es el golden file).
```

**Criterios de aceptación**: `/validate-pbs all` sobre la base intacta reporta 0 errores (si reporta errores, el validador está mal, no la base); `/extract-scripts` seguido de `/combine-scripts` reproduce un `Scripts.rxdata` funcional; commit `fase-4: skills essentials`.

---

### Sesión 5 — Fases 5-6: Integración de wiki y configuración final

**Objetivo**: plantillas, `CLAUDE.md` definitivo con guías Karpathy, preferencias técnicas.

**Prompt para Claude Code**:

```text
Fases 5 y 6.

1. Plantillas en .claude/docs/templates/: pokemon-species.md, move-spec.md y
   trainer-spec.md. Cada una con secciones de diseño + bloque "PBS Entry" en el formato
   real (Fase 3) + "Implementation Notes" apuntando a la página de wiki correspondiente
   (rutas de wiki-reference.md).

2. Reescribir CLAUDE.md de game-studio-agents:
   - Technology Stack: RPG Maker XP + Pokémon Essentials v21.1/v22, Ruby (versión
     detectada), build vía scripts_combine.rb + compilación PBS, referencia
     wiki-la-base-de-sky/wiki_markdown/.
   - Project Structure (los 3 repos del workspace).
   - Referencia OBLIGATORIA a la wiki y a .claude/docs/wiki-reference.md antes de sugerir
     implementaciones.
   - Protocolo de colaboración intacto (Pregunta → Opciones → Decisión → Borrador →
     Aprobación; sin commits sin instrucción).
   - Al FINAL, anexar íntegro el contenido de ../prompts/karpathy-guidelines.md bajo el
     encabezado "## Guías de comportamiento (Karpathy)".

3. Actualizar .claude/docs/technical-preferences.md con convenciones de nombres (PBS,
   scripts, Graphics/, Audio/) y la tabla de routing de especialistas.

4. Actualizar .gitignore del framework según la sección "Archivos que NO se almacenan"
   de PLAN-ADAPTACION.md, y dejar src/, design/gdd/, assets/, prototypes/, tests/ con
   .gitkeep.

Borrador + aprobación por archivo.
```

**Criterios de aceptación**: `CLAUDE.md` no menciona Unity/Godot/Unreal; contiene las 4 guías Karpathy; las 3 plantillas producen bloques PBS que pasan `/validate-pbs`; commit `fase-5-6: wiki + configuracion final`.

---

### Sesión 6 — Fase 7: Verificación integral

**Objetivo**: probar que los agentes saben, consultan la wiki y producen artefactos válidos; auditar la configuración.

**Batería de pruebas** (registrar resultados en `production/verificacion-fase7.md`):

| # | Prueba | Cómo | Pasa si… |
|---|--------|------|----------|
| 1 | Conocimiento | Preguntar a cada agente nuevo 3 conceptos de Essentials (p. ej. "¿cómo se define una evolución por objeto?") | Responde con la mecánica correcta de v21 y cita la página de wiki |
| 2 | Referencia obligatoria | Pedir una implementación sin dar contexto ("añade un movimiento que drene PP") | El agente hace Grep/lee la wiki ANTES de proponer, y lo evidencia |
| 3 | Golden path E2E | `/setup-essentials` → `/brainstorm` (mini-concepto) → `/design-system` → crear 1 Pokémon + 1 movimiento + 1 entrenador → `/validate-pbs` | PBS válidos, compilación OK, `Game.exe` arranca y el contenido aparece en el juego |
| 4 | Ciclo de scripts | `/extract-scripts` → edición trivial (un comentario) → `/combine-scripts` | El juego arranca sin errores de script |
| 5 | Formato PBS | Pedir un Pokémon deliberadamente mal especificado (stats de 7 valores) | El agente detecta y corrige el error de formato, no lo replica |
| 6 | Protocolo | Cualquier tarea de escritura | Pregunta antes de usar Write/Edit; ofrece opciones; no commitea solo |
| 7 | Hooks | Disparar los hooks de commit/assets en Windows (Git Bash) | Corren sin fallos de sintaxis POSIX |
| 8 | Auditoría de configuración | `npx ecc-agentshield scan` en `game-studio-agents/` | Sin hallazgos críticos (corregir los que salgan y re-escanear) |

**Criterios de cierre**: las 8 pruebas en verde; commit `fase-7: verificacion` + tag `v1.0-essentials`; **checkpoint Spec-Kit**: decidir si se adopta para la primera feature grande del juego.

---

## Parte 4 — Cronograma, entregables y riesgos

### Cronograma

| Sesión | Fase(s) | Entregables clave | Estimación |
|--------|---------|-------------------|------------|
| 0 | Preparación | Repos + 3 skills de Superpowers + guías Karpathy descargadas | 0.5 día |
| 1 | Diagnóstico | `diagnostico-essentials.md`, `wiki-reference.md` | 0.5-1 día |
| 2 | Agentes | 3 nuevos, 4 adaptados, 15 desactivados | 1 día |
| 3 | Reglas | 4 nuevas (derivadas de fuentes reales), 2 adaptadas, 2 fuera | 1 día |
| 4 | Skills | 4 nuevos (+ `validate_pbs` determinista), 4 modificados | 1-2 días |
| 5 | Wiki + config | Plantillas, `CLAUDE.md` + Karpathy, preferencias, `.gitignore` | 0.5-1 día |
| 6 | Verificación | Batería de 8 pruebas + AgentShield + tag | 1 día |

### Riesgos y mitigaciones

| Riesgo | Mitigación |
|--------|-----------|
| Reglas escritas de memoria (sintaxis PBS, API de eventos, versión Ruby) | C1-C4: toda regla se deriva de archivos reales + wiki, con cita de fuente; el diagnóstico (Sesión 1) fija los hechos |
| Rutas de wiki inventadas en agentes/reglas | C6: `wiki-reference.md` generado solo con `Glob`; verificación de rutas al cierre de cada sesión |
| Hooks POSIX fallan en Windows | C5: prueba explícita en Sesiones 1 y 6 |
| Colisión de metodologías externas | Adopción parcial: sin plugin de Superpowers, sin ECC, Spec-Kit diferido |
| Validador PBS más estricto que el compilador real | Los PBS de la base oficial son el golden file: el validador debe pasarlos en limpio antes de usarse contra contenido nuevo |
| Divergencia con upstream del framework | `git fetch upstream` + merge manual, protegiendo CLAUDE.md, agents/, rules/, skills/ (ya documentado en PLAN-ADAPTACION.md) |

### Próximo paso inmediato

Ejecutar la **Sesión 0** (terminal) y lanzar Claude Code desde `game-studio-agents/` con el prompt de la **Sesión 1**.
