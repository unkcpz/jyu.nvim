# NeoVim config from scratch

- julia
- rust
- python
- lazygit

## Pre-requirements

Use the meslo lg font

```bash
cd ~
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/Meslo.zip
mkdir -p .local/share/fonts
unzip Meslo.zip -d .local/share/fonts
cd .local/share/fonts
rm *Windows*
cd ~
rm Meslo.zip
fc-cache -fv
```

Install https://github.com/nvim-tree/nvim-web-devicons for icons in the nvim-tree and bottom panes

Install lazygit:

```bash
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
```

For `ruff` and `ruff-lsp` to work, need python `venv`.
For `html` need npm (use node.js package version manager `nvm` to install it). ICF: `nvm.fish`.

Require `ripgrep` for telescope fzf search.
