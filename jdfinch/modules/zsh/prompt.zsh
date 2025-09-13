# Fixed-width (32) prompt: quiet cwd, bold white symbol
# - cwd is right-aligned within 30 cols (left-padded), left-truncated with "..."
# - a single space + symbol make up the remaining 2 cols
# - total width (cwd + space + symbol) = 32
setopt PROMPT_SUBST

_fixed_cwd_field() {
  local maxlen=${1:-32}
  local field=$(( maxlen - 2 ))   # allow " <symbol>" at the end
  local p=${PWD/#$HOME/~}

  if (( ${#p} > field )); then
    # left-truncate; keep last (field-3), prefix "..."
    p="...${p: -$((field - 3))}"
  fi

  # left-pad to width 'field' (right-align)
  printf "%*s" "$field" "$p"
}

precmd() {
  local maxlen=32
  local sym="⮞"   # fancy prompt glyph; alternatives: ➜  ❱  ⮞

  # dim/quiet cwd, then space + bold white symbol
  PROMPT="%F{240}$(_fixed_cwd_field $maxlen)%f %B%F{white}${sym}%f %b"
  RPROMPT=
}
