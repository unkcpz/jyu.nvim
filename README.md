# NeoVim config from scratch

- julia
- rust
- python
- lua

## Usage

If you are interested in using the same setup I used (which is my collection of all the plugins, by any changes you also code in rust/julia/python), you can clone the repo to your neovim config folder.

```bash
git clone https://github.com/unkcpz/jyu.nvim.git ~/.config/nvim
```

Please first make sure you did [install the neovim](https://github.com/neovim/neovim?tab=readme-ov-file#install-from-package) and check the pre-requisites section (don't worry if you forget some of it, the neovim start will throw warnings to ask you to install them). 
If you can start nvim without seeing warnings then everything should be fine. 
You can then input `:checkhealth` in nvim to see if there are warnings that you need to fix.

Now in your terminal run `nvim` to edit your file and enjoy it!
(I recommend to have a look at [`alacritty`](https://alacritty.org/), and I recommend to use [`tmux`](https://github.com/tmux/tmux/wiki), the terminal multiplexer since the julia and python interpret require it to directly send the code to run as you have in julia notebook), 

## Pre-requirements

The config requires:

- A [nerd font](https://www.nerdfonts.com/font-downloads) installed in system and setup for your terminal to show the pretty icons. I use `MesloLGSDZ mono`.
- `ripgrep`
- `lazygit`
- `stylua`
- `fd`
- `rust-analyzer` 

For `ruff` and `ruff-lsp` to work, need python `venv`.
For `html` need npm (use node.js package version manager `nvm` to install it). ICF: `nvm.fish`.

Require `ripgrep` for telescope fzf search.

For the font

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

## Keybindings

### Julia and Python run like jupyter notebook

I use [`vim-slime`](https://github.com/jpalardy/vim-slime) to do this.
First I open a tmux window with my julia/python code in editting. 
I split a tmux window on the left with running julia/ipython REPL.

Then I do `<space> -> r -> c` to config slime to send to tmux window `default`, and tmux target panel `.1` which is the one opened on the left.

In the julia/python code, for the "cell" you want to run, separate the lines with `# %%` such as below, the section will be executed on the left panel.

```julia
# %%
using DFTK
using FowardDiff

# %%
3 + 4
```

### General and cheatsheet

(coming)


