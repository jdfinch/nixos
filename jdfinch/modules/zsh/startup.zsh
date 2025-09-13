# Only for interactive shells
if [[ -o interactive ]]; then
  print -r -- "$PWD"

  # tree -L 1 if available, else fallback to ls
  if (( $+commands[tree] )); then
    tree -L 1 --noreport
  elif (( $+commands[eza] )); then
    eza --group-directories-first
  else
    ls
  fi
  echo ""
fi

# Hook for after every cd
autoload -Uz add-zsh-hook
_chpwd_list() {
  if (( $+commands[eza] )); then
    eza --group-directories-first
  else
    ls
  fi
}
add-zsh-hook chpwd _chpwd_list
