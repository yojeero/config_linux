#!/usr/bin/env bash

Write system scripts in Bash
#!/usr/bin/env bash.

# home-manager home.nix

programs.zsh = {
  enable = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  history.size = 10000;
};