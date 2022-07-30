# config files, where do they go?

traditional vim has the config file at `~/.vimrc`. we like to use neovim,
though, and neovim places it in `~/.config/nvim/init.vim`.

# useful vim options

These are basic options that we always use

you can set these in your `init.vim`. To understand what they do, use the colon
prompt in neovim, for example if you are in normal mode, you can type `:help
hiden` to get a detailed explanation.

- `set ignorecase` and `set smartcase`: these are both related to the
  functionality of search

- `syntax enable`: enables syntax highlighting, this is huge for making code
  easier to read and write, but it'll work best if you find a colorscheme that
  is both comfortable to look at, and that clearly distinguishes between
  different types of code objects in a way that your eyes can quickly
  differentiate.

- `colorscheme XXXX`: in normal mode, if you type `:colorscheme ` (make sure
  there's a blank space at the end) and then hit the `<Tab>` button, the
  autocomplete will show you the available color schemes. You should pick one
  that works for you. You can also use your plug-in manager to install
  additional color schemes, for instance
  [monokai](https://github.com/tanvirtin/monokai.nvim) or
  [gruvbox](https://github.com/morhetz/gruvbox)

- `set hidden`: keeps buffers open (including undo history, etc) when you
  switch over to another one

- `set relativenumber` and `set number`: `number` shows the current line number
  on the left of the editor. `relativenumber` shows, for each line, the number
  of lines up or down from the current cursor position.

- `set colorcolumn=80`: this adds a line of color at 80 characters wide, which
  is helpful when you're coding to help you notice when a line has gotten too
  long.

# nvim plugins

There are various plugin managers for neovim,
[vim-plug](https://github.com/junegunn/vim-plug) works pretty well

Here are a couple of useful plugins you can install once you've got vim-plug
set up:

- [Ultisnips](https://github.com/sirver/UltiSnips)
- [vim-commentary](https://github.com/tpope/vim-commentary)

