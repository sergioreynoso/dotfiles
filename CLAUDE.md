# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository managed with GNU Stow for symlinking configuration files to the home directory. The primary configurations include Neovim, Zsh, and Tmux.

## Installation and Setup

**Requirements:**
- Git: `brew install git`
- GNU Stow: `brew install stow`

**Installation:**
```bash
git clone git@github.com/sergioreynoso/dotfiles.git
cd dotfiles
stow .
```

This creates symlinks from the dotfiles directory to the home directory, allowing version control of configuration files.

## Architecture

### Neovim Configuration

**Location:** `.config/nvim/`

**Entry Point:** `init.lua` loads two main modules:
- `sergio.core` - Core Neovim settings and keymaps
- `sergio.lazy` - Plugin manager setup (lazy.nvim)

**Plugin Management:**
- Uses lazy.nvim as the plugin manager (installed automatically on first run)
- Plugins are auto-loaded from `sergio.plugins` and `sergio.plugins.lsp` modules
- Plugin lock file: `lazy-lock.json` tracks installed plugin versions

**Directory Structure:**
```
.config/nvim/lua/sergio/
├── core/
│   ├── init.lua       # Core module loader
│   ├── keymaps.lua    # Custom keybindings
│   └── options.lua    # Vim options/settings
├── plugins/
│   ├── lsp/
│   │   ├── lspconfig.lua  # LSP server configurations
│   │   └── mason.lua      # LSP installer (Mason)
│   ├── auto-completion.lua
│   ├── telescope.lua
│   ├── nvim-tree.lua
│   ├── treesitter.lua
│   ├── lualine.lua
│   └── [other plugin configs]
└── lazy.lua           # lazy.nvim bootstrap
```

**Key Design Patterns:**
- Each plugin has its own configuration file in `plugins/`
- LSP-related plugins are isolated in `plugins/lsp/`
- lazy.nvim auto-imports all files from plugin directories
- Leader key is set to Space (`<leader>` = ` `)

**Important Keybindings:**
- `jj` - Exit insert mode
- `<leader>wv/wh` - Split windows vertically/horizontally
- `<Tab>/<S-Tab>` - Navigate between buffers
- `<C-h/j/k/l>` - Navigate between windows
- Tab management is intentionally disabled (user preference)

### Tmux Configuration

**Location:** `.tmux.conf`

**Key Features:**
- True color support (256-color)
- Custom prefix: Default Ctrl+b (commented option to change to Ctrl+a)
- Split keybindings: `|` for vertical, `-` for horizontal
- Vim-style pane resizing: `h/j/k/l` with prefix
- Mouse support enabled
- Vim-style copy mode keybindings

**Plugins (via TPM):**
- `christoomey/vim-tmux-navigator` - Seamless vim/tmux navigation with Ctrl+hjkl
- `tmux-resurrect` - Session persistence across restarts
- `tmux-continuum` - Auto-saves sessions every 15 minutes

**Plugin Manager:** TPM (Tmux Plugin Manager) installed in `~/.tmux/plugins/tpm`

### Zsh Configuration

**Location:** `.zshrc`

**Shell Framework:** Oh-My-Zsh
- Installation path: `$HOME/.oh-my-zsh`
- Theme: Powerlevel10k (`powerlevel10k/powerlevel10k`)

**Plugins:**
- git
- zsh-autosuggestions
- zsh-syntax-highlighting

## Working with This Repository

**Modifying Neovim Plugins:**
1. Add new plugin configs in `.config/nvim/lua/sergio/plugins/`
2. For LSP-related plugins, use `.config/nvim/lua/sergio/plugins/lsp/`
3. lazy.nvim will auto-detect and load new plugin files
4. No need to manually update an init file for plugins

**Testing Neovim Changes:**
- Open Neovim and changes are automatically applied (lazy.nvim auto-reloads)
- Use `:Lazy` to manage plugins
- Use `:Mason` to manage LSP servers

**Applying Configuration Changes:**
- After modifying dotfiles, run `stow .` to update symlinks if needed
- Most changes take effect immediately or after restarting the application
- Tmux: Reload with `<prefix>r`
- Zsh: Restart terminal or `source ~/.zshrc`

**Git Workflow:**
- Modified files are in the dotfiles directory, not home directory
- Commit changes from this repository
- Symlinks in home directory point to files here
