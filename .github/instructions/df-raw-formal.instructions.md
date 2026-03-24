---
description: "Use when editing Dwarf Fortress raw text files; prioritize formal in-repo sources and avoid invented tags"
applyTo: "Mods/**/*.txt"
---

# Dwarf Fortress Raw Source Policy

- Prefer formal project sources in this order:
  1. `vanilla/*/objects/*.txt`
  2. `Mods/SOP_GR/Guide_*.md`
  3. Existing files in `Mods/SOP_GR/objects/**`
- Do not invent tag names, reaction tokens, or job tokens.
- If a tag or token cannot be verified in project sources, ask for confirmation or mark uncertainty clearly.
- Keep raw syntax strict and conservative: bracket tags, uppercase token style, and vanilla-compatible naming.