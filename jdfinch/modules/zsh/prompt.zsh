# Always render cwd as exactly (maxlen-2) chars, plus " >"
_fixed_cwd_prompt() {
  local maxlen=$1
  local p=${PWD/#$HOME/~}
  local promptlen=$((maxlen - 2))   # leave space for " >"

  if (( ${#p} > promptlen )); then
    # truncate from left
    p="...${p: -$((promptlen - 3))}"
  else
    # pad with spaces on right
    p="${p}$(printf '%*s' $((promptlen - ${#p})))"
  fi

  print -r -- "$p"
}

precmd() {
  local maxlen=32
  PROMPT="%B%F{white}$(_fixed_cwd_prompt $maxlen)%f > %b"
  RPROMPT=
}
