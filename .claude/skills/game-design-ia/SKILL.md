---
name: game-design-ia
description: "Referencia maestra del proyecto Game-Design-IA. Úsala cuando el usuario pregunte cómo funciona el proyecto o el framework, qué repo/rama/documento corresponde a algo, dónde está documentado un tema (implementación, guías, uso, actualizaciones), o pida regenerar el documento maestro docs/GAME-DESIGN-IA.md."
argument-hint: "[pregunta | update]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Bash, AskUserQuestion
---

# Game-Design-IA — Referencia Maestra

Punto de entrada único para entender el proyecto: los tres repos
(`game-studio-agents`, `../la-base-de-sky`, `../wiki-la-base-de-sky`), su modelo de
ramas, las guías de uso y actualización, y dónde está documentado cada tema.

**Fuente principal**: `docs/GAME-DESIGN-IA.md` (el documento maestro). Este skill lo
consulta, lo mantiene, y responde preguntas remitiendo siempre al documento canónico
que corresponda — **nunca respondas de memoria si un doc canónico cubre el tema**.

---

## Modo 1: Responder una pregunta — `/game-design-ia [pregunta]` (o sin argumento)

1. Lee `docs/GAME-DESIGN-IA.md`.
   - Si no existe, ofrece regenerarlo (Modo 2) y usa mientras tanto las fuentes de la
     tabla de abajo.
2. **Sin argumento**: presenta un resumen breve del proyecto (secciones 1-3 del doc
   maestro) más el índice de documentos canónicos (sección 6), y pregunta qué tema
   quiere explorar el usuario.
3. **Con pregunta**: identifica el tema y responde leyendo el documento canónico que lo
   cubre — no solo el doc maestro:

   | Tema de la pregunta | Fuente a leer |
   |---------------------|---------------|
   | Qué es el proyecto, estructura del workspace | `docs/GAME-DESIGN-IA.md` + `../AGENTS.md` |
   | Cómo usar el framework, fases, qué skill sigue | `docs/GUIA-DE-USO.md` |
   | Ramas, remotes, dónde va cada archivo | `.claude/docs/technical-preferences.md` § Version Control Strategy |
   | Actualizaciones (base, wiki o plantilla) | `.claude/docs/actualizaciones-la-base-de-sky.md` |
   | Cómo implementar algo en el juego | `.claude/docs/wiki-reference.md` → la página de wiki que indique |
   | Reglas de código (PBS, Ruby, eventos, plugins, UI) | `.claude/rules/[la regla correspondiente].md` |
   | Agentes, jerarquía, coordinación | `.claude/docs/coordination-rules.md` |
   | Protocolo de colaboración | `docs/COLLABORATIVE-DESIGN-PRINCIPLE.md` |
   | Historial de cambios | `git log` (comandos en la sección 7 del doc maestro) |

4. En la respuesta, **cita siempre la ruta del documento fuente** (y sección si aplica)
   para que el usuario pueda profundizar.
5. Si el tema no está cubierto por ningún documento canónico, dilo explícitamente y
   ofrece: investigarlo en el código/wiki, o documentarlo (proponiendo en qué archivo
   canónico debería vivir — no en el doc maestro, que es solo índice).
6. Si la pregunta es "¿qué hago ahora?" o de progreso, redirige a `/help`,
   `/project-stage-detect` o `/sprint-status` según corresponda.

---

## Modo 2: Regenerar el doc maestro — `/game-design-ia update`

Ejecutar cuando cambió algo estructural: modelo de ramas, documentos canónicos
nuevos/movidos, cambios de remotes, secciones nuevas en las guías.

1. Lee el `docs/GAME-DESIGN-IA.md` actual.
2. Releé las fuentes canónicas: `../AGENTS.md`, `CLAUDE.md`,
   `.claude/docs/technical-preferences.md`, `docs/GUIA-DE-USO.md`,
   `.claude/docs/actualizaciones-la-base-de-sky.md`, `.claude/docs/wiki-reference.md`.
3. Verifica los datos factuales contra la realidad, no contra la memoria:
   - Remotes: `git remote -v` en los tres repos.
   - Ramas: `git branch --format='%(refname:short)'` en los tres repos.
   - Que cada documento indexado en la sección 6 exista (Glob).
4. Presenta un resumen de las diferencias encontradas (qué secciones cambiarían y por
   qué) y pregunta: "¿Puedo escribir estos cambios en `docs/GAME-DESIGN-IA.md`?"
5. Solo tras aprobación, aplica los cambios con Edit. No commitees sin instrucción.

**Principios del doc maestro** (mantener al editarlo):
- Es un **índice con contexto**, no un duplicado: la única información original que
  contiene es la tabla consolidada del modelo de ramas de los tres repos (sección 3).
  Todo lo demás resume en 1-3 líneas y remite al doc canónico.
- Complementa `../AGENTS.md` (vista de workspace), no lo absorbe.
- Sin changelog propio: el historial es `git log` (sección 7).
- Vive en `adapted-essentials-oc` (es un archivo de framework, no de un juego).

---

## Casos límite

- **El usuario pregunta por un juego concreto** (su GDD, sus epics): eso vive en la rama
  `game/[nombre]` de este repo — si la rama actual no es esa, indícalo antes de buscar.
- **Contradicción entre el doc maestro y un doc canónico**: el canónico gana; señala la
  discrepancia y ofrece correr el Modo 2.
- **Pregunta sobre Claude Code en sí** (no sobre este proyecto): fuera de alcance de
  este skill; responde directamente o usa el agente `claude-code-guide`.
