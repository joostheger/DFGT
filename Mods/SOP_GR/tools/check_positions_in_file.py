import re
import sys
from pathlib import Path
from difflib import get_close_matches

ROOT = Path(__file__).resolve().parents[1]
FILE = ROOT / 'objects' / 'SOP_GR_entities' / 'objects' / 'entity_SOP_GR.txt'

text = FILE.read_text(encoding='utf-8')
lines = text.splitlines()

# collect defined positions
pos_def_re = re.compile(r"\[POSITION:([^\]]+)\]")
pos_defs = set(m.group(1) for m in pos_def_re.finditer(text))

# collect referenced positions and their line numbers
ref_patterns = {
    'APPOINTED_BY': re.compile(r"\[APPOINTED_BY:([^\]]+)\]"),
    'SUCCESSION_BY_POSITION': re.compile(r"\[SUCCESSION:BY_POSITION:([^\]]+)\]"),
    'REPLACED_BY': re.compile(r"\[REPLACED_BY:([^\]]+)\]")
}

refs = []
for i, ln in enumerate(lines, start=1):
    for tag, rx in ref_patterns.items():
        for m in rx.finditer(ln):
            name = m.group(1).strip()
            refs.append((tag, name, i, ln.strip()))

# find missing references
missing = []
for tag, name, lineno, snippet in refs:
    if name not in pos_defs:
        # ignore numeric or built-in-looking names? (none expected)
        missing.append((tag, name, lineno, snippet))

# helper suggestions
def suggest(name):
    # try exact uppercase variants and close matches
    candidates = list(pos_defs)
    up = name.upper()
    suggestions = []
    if up in pos_defs:
        suggestions.append(up)
    # common suffixes
    for suf in ('_SITE', '_SINGLE', '_ASNEEDED'):
        if (up + suf) in pos_defs and (up + suf) not in suggestions:
            suggestions.append(up + suf)
    # difflib
    matches = get_close_matches(name, candidates, n=3, cutoff=0.6)
    for m in matches:
        if m not in suggestions:
            suggestions.append(m)
    return suggestions

# output
print(f"Checked file: {FILE}\n")
print(f"Defined positions: {len(pos_defs)}")
print(f"Total position references scanned: {len(refs)}\n")

if not missing:
    print('? All referenced positions are defined in this file.')
    sys.exit(0)

print('?? Missing position definitions found:')
for tag, name, lineno, snippet in missing:
    sugg = suggest(name)
    stext = (', '.join(sugg) if sugg else 'none')
    print(f"- {tag} reference '{name}' at line {lineno}: {snippet}\n  suggestions: {stext}")

# exit with non-zero so CI/tools can catch it if needed
sys.exit(2)
