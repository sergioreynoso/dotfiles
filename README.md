# My Dotfiles

Personal dotfiles repository managed with GNU Stow for symlinking configuration files. Includes configurations for Neovim, Zsh, and Tmux.

## Requirements

Ensure you have the following installed on your system:

### Git
```bash
brew install git
```

### Stow
```bash
brew install stow
```

## Installation

Clone the dotfiles repo and use GNU Stow to create symlinks:

```bash
git clone https://github.com/sergioreynoso/dotfiles.git
cd dotfiles
stow .
```

This creates symlinks from the dotfiles directory to the home directory, allowing version control of configuration files.

## What's Included

### Neovim

**Location:** `.config/nvim/`

Modern Neovim configuration using lazy.nvim plugin manager and native LSP support (Neovim 0.11+).

**Key Features:**
- Lazy.nvim for plugin management
- LSP support via Mason and nvim-lspconfig
- Autocompletion with nvim-cmp
- Fuzzy finding with Telescope
- File explorer with nvim-tree
- Syntax highlighting with Treesitter
- Auto-formatting and linting

**Plugin Structure:**
```
.config/nvim/lua/sergio/
├── core/           # Core settings and keymaps
├── plugins/        # Plugin configurations
│   └── lsp/        # LSP-specific configs
└── lazy.lua        # Plugin manager bootstrap
```

**Key Keybindings:**
- Leader key: `Space`
- `jj` - Exit insert mode
- `<leader>wv/wh` - Split windows vertically/horizontally
- `<Tab>/<S-Tab>` - Navigate between buffers
- `<C-h/j/k/l>` - Navigate between windows

**LSP Servers Configured:**
- TypeScript/JavaScript (ts_ls)
- HTML, CSS, Tailwind
- Lua (lua_ls)
- Go (gopls)
- Python (pylsp)
- And more...

### Tmux

**Location:** `.tmux.conf`

Terminal multiplexer configuration with vim-style keybindings and seamless Neovim integration.

**Key Features:**
- True color support (256-color)
- Prefix: `Ctrl+b`
- Split panes: `|` (vertical), `-` (horizontal)
- Vim-style pane resizing: `h/j/k/l` with prefix
- Mouse support enabled
- Session persistence with tmux-resurrect

**Plugins (via TPM):**
- vim-tmux-navigator - Seamless vim/tmux navigation
- tmux-resurrect - Session persistence
- tmux-continuum - Auto-save sessions

### Zsh

**Location:** `.zshrc`

Shell configuration using Oh-My-Zsh framework with Powerlevel10k theme.

**Features:**
- Theme: Powerlevel10k
- Plugins: git, zsh-autosuggestions, zsh-syntax-highlighting

## Usage

### Modifying Neovim Plugins

1. Add new plugin configs in `.config/nvim/lua/sergio/plugins/`
2. For LSP-related plugins, use `.config/nvim/lua/sergio/plugins/lsp/`
3. Lazy.nvim will auto-detect and load new plugin files
4. Use `:Lazy` to manage plugins and `:Mason` to manage LSP servers

### Applying Configuration Changes

- After modifying dotfiles, run `stow .` to update symlinks if needed
- Most changes take effect immediately or after restarting the application
- Tmux: Reload with `<prefix>r`
- Zsh: Restart terminal or run `source ~/.zshrc`

### Git Workflow

- Modified files are in the dotfiles directory, not home directory
- Commit changes from this repository
- Symlinks in home directory point to files here

## Notes

- Neovim requires version 0.11+ for full LSP support
- Tmux Plugin Manager (TPM) must be installed for tmux plugins
- Oh-My-Zsh and Powerlevel10k should be installed for the Zsh configuration

## License

Personal configuration files - use at your own discretion.
