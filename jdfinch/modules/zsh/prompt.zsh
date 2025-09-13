# Truncate cwd from the left if longer than given length
_trunc_cwd() {
  local maxlen=$1
  local p=${PWD/#$HOME/~}
  if (( ${#p} > maxlen )); then
    p="...${p: -$maxlen}"
  fi
  print -r -- "$p"
}

# precmd is run before each prompt is displayed
precmd() {
  local maxlen=32   # change this if you want a different max
  PROMPT="%B%F{white}$(_trunc_cwd $maxlen)%f > %b"
  RPROMPT=
}
