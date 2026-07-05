# Materiales entrantes

Cuando tú (no un agente) ya encontraste algo que quieres incorporar — un plugin de la comunidad,
un tutorial, un script suelto — déjalo aquí en vez de solo describirlo de palabra. Da al skill
`/custom-extension` una fuente concreta que verificar en vez de tener que buscarla desde cero.

## Cómo dejar algo aquí

Crea una carpeta por idea/funcionalidad: `docs/custom-extensions/incoming/[nombre-funcionalidad]/`

Dentro, según lo que tengas:

- **`notas.md`** — el enlace (URL) de donde sale, y una descripción de qué hace. Aunque solo
  tengas un link, este archivo es el mínimo útil.
- **`scripts/`** — cualquier archivo `.rb` (o `.txt`, capturas, etc.) que ya hayas descargado del
  plugin/tutorial. Los agentes NO ejecutan ni instalan estos archivos automáticamente — se
  revisan primero.
- Cualquier `.md` que quieras pegar como referencia (p. ej. el README del plugin, un post de foro
  copiado) — igual que la wiki de La Base de Sky, pero para esta fuente puntual.

Ver `_ejemplo/` para la estructura esperada.

## Qué pasa después

Cuando corras `/custom-extension [nombre-funcionalidad]`, el skill busca primero en esta carpeta.
Si encuentra material, lo usa como fuente principal (verificándolo, no asumiéndolo a ciegas) en
vez de salir a buscar en internet desde cero. Tras implementarlo, el skill mueve el registro
final a `docs/custom-extensions/[slug].md` (ver `INDEX.md`) — esta carpeta `incoming/` es solo
para material crudo, sin procesar todavía.
