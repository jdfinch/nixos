# Print PWD once when an interactive shell starts
[[ -o interactive ]] && print -r -- "$PWD"

# After every directory change, run ls (use eza if available)
autoload -Uz add-zsh-hook

_ls_after_cd() {
  if (( $+commands[eza] )); then
    eza -la --group-directories-first
  else
    ls -la
  fi
}

add-zsh-hook chpwd _ls_after_cd
