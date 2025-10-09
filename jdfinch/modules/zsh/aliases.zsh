
alias renix='sudo nixos-rebuild switch --flake ~/nixos#raider'
alias rehome="home-manager switch --flake ~/nixos#jdfinch"


# Git quick commit: gcm "your message"
git-commit() {
  git add -A
  git status
  git commit -m "$1"
}

pip()  { uv pip "$@"; }
pip3() { uv pip "$@"; }
