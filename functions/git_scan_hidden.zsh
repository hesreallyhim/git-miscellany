# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 Really Him

git_scan_hidden() {
  set -euo nounset
  set -o pipefail

  local usage
  usage=$'Usage:\n'\
$'  git_scan_hidden --help\n'\
$'  git_scan_hidden file <path>\n'\
$'  git_scan_hidden url <raw_url>\n'\
$'  git_scan_hidden gh-blob <owner/repo> <sha> <path/in/repo>\n'\
$'  git_scan_hidden pr-diff <owner/repo> <pr_number>\n'\
$'  git_scan_hidden commit-diff <owner/repo> <sha>\n\n'\
$'Examples:\n'\
$'  git_scan_hidden file ./README.md\n'\
$'  git_scan_hidden url "https://github.com/OWNER/REPO/pull/2.diff"\n'\
$'  git_scan_hidden gh-blob OWNER/REPO <sha> path/to/file\n'\
$'  git_scan_hidden pr-diff OWNER/REPO 2\n'\
$'  git_scan_hidden commit-diff OWNER/REPO 186a92\n'

  local mode="${1:-}"
  shift || true

  if [[ -z "$mode" || "$mode" == "--help" || "$mode" == "-h" ]]; then
    print -r -- "$usage"
    return 0
  fi

  local fetch_cmd=()

  case "$mode" in
    file)
      local path="${1:?path required}"
      fetch_cmd=(cat -- "$path")
      ;;
    url)
      local url="${1:?url required}"
      fetch_cmd=(curl -fsSL "$url")
      ;;
    gh-blob)
      local repo="${1:?owner/repo required}"
      local sha="${2:?sha required}"
      local path_in_repo="${3:?path/in/repo required}"
      fetch_cmd=(curl -fsSL "https://raw.githubusercontent.com/${repo}/${sha}/${path_in_repo}")
      ;;
    pr-diff)
      local repo="${1:?owner/repo required}"
      local pr="${2:?pr number required}"
      fetch_cmd=(curl -fsSL "https://github.com/${repo}/pull/${pr}.diff")
      ;;
    commit-diff)
      local repo="${1:?owner/repo required}"
      local sha="${2:?sha required}"
      fetch_cmd=(curl -fsSL "https://github.com/${repo}/commit/${sha}.diff")
      ;;
    *)
      print -u2 -- "$usage"
      return 64
      ;;
  esac

  local py
  py="$(cat <<'PY'
import sys, unicodedata

data = sys.stdin.buffer.read()
if not data:
    print("WARNING: empty input (fetch produced no bytes).")
    raise SystemExit(65)

s = data.decode("utf-8", errors="surrogateescape")

# Bidirectional control characters (high-risk, low-noise)
BIDI = {
  0x061C, 0x200E, 0x200F,
  0x202A, 0x202B, 0x202C, 0x202D, 0x202E,
  0x2066, 0x2067, 0x2068, 0x2069,
}

# Invisible / obfuscation-prone characters curated from invisible-characters.com
INVIS = {
  0x00A0,  # NO-BREAK SPACE
  0x00AD,  # SOFT HYPHEN
  0x034F,  # COMBINING GRAPHEME JOINER
  0x180B, 0x180C, 0x180D, 0x180E,  # Mongolian selectors/separator
  0x200B, 0x200C, 0x200D,          # ZWSP/ZWNJ/ZWJ
  0x202F,                          # NARROW NO-BREAK SPACE
  0x2060, 0x2061, 0x2062, 0x2063, 0x2064, 0x2065,  # WORD JOINER + invisible operators
  0x2800,                          # BRAILLE PATTERN BLANK
  0xFEFF,                          # BOM / zero-width no-break space
  0x115F, 0x1160,                  # Hangul fillers
  0x1680,                          # OGHAM SPACE MARK
  0x17B4, 0x17B5,                  # Khmer inherent vowels
}

ALLOW = {0x09, 0x0A, 0x0D}  # tab, LF, CR

line = 1
col = 0
hits = []

for ch in s:
    col += 1
    if ch == "\n":
        line += 1
        col = 0
        continue

    cp = ord(ch)
    cat = unicodedata.category(ch)

    if cp in BIDI or cp in INVIS or (cat in ("Cc", "Cf") and cp not in ALLOW):
        hits.append((line, col, cp, cat, unicodedata.name(ch, "UNNAMED")))

if not hits:
    print("OK: no suspicious control/format/bidi/invisible characters found.")
    raise SystemExit(0)

print(f"FOUND {len(hits)} suspicious characters:")
for ln, cl, cp, cat, name in hits:
    print(f"  line {ln}, col {cl}: U+{cp:04X}  {cat}  {name}")

raise SystemExit(2)
PY
)"

  "${fetch_cmd[@]}" | python3 -c "$py"
}
