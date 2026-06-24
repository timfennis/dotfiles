-- ~/.config/nvim/init.lua
-- Minimal Neovim config. No plugin manager — just settings, a keymap, and the
-- custom `ndc` (Andy C++) language support at the bottom.

-- ──────────────────────────────────────────────────────────────────────────
-- General settings (ported from the old IdeaVim config)
-- ──────────────────────────────────────────────────────────────────────────
-- Leader key = space. Must be set before any <leader> mappings are defined.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true             -- set nu
vim.opt.relativenumber = true     -- set rnu
vim.opt.visualbell = true         -- set visualbell
vim.opt.fixendofline = false      -- set nofixendofline

vim.opt.tabstop = 4               -- set tabstop=4
vim.opt.shiftwidth = 4            -- set shiftwidth=4
vim.opt.expandtab = true          -- set expandtab

vim.opt.clipboard = "unnamedplus" -- set clipboard+=unnamedplus (use system clipboard)

vim.cmd.syntax("on")              -- syntax on (on by default in Neovim, kept explicit)

vim.opt.termguicolors = true      -- enable 24-bit colors (needed by the colorscheme)
require("onedark").setup({ style = "warmer" })
require("onedark").load()

-- IdeaVim-only settings have no Neovim equivalent and are dropped:
--   set ideajoin, set clipboard^=ideaput

-- gu -> go to definition (your `:action GotoDeclaration`, via the built-in LSP).
vim.keymap.set("n", "gu", vim.lsp.buf.definition, { desc = "Go to definition" })

-- <leader>qq -> quit all (LazyVim's :qa binding). <leader>q on its own was just
-- a which-key menu group there, so the real key is the double-q.
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Briefly highlight yanked text (built in, no plugin needed).
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Built-in LSP autocomplete: pop up completions as you type, for any server
-- that supports it. Accept with <C-y>, cancel with <C-e>, navigate with
-- <C-n>/<C-p>. Manual trigger is <C-x><C-o>.
--
-- noselect/noinsert: show the menu but don't preselect or auto-insert the first
-- entry — nothing is chosen until you pick it explicitly. The menu follows your
-- typing instead of typing for you.
vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

-- ──────────────────────────────────────────────────────────────────────────
-- Andy C++ (.ndc) support
-- ──────────────────────────────────────────────────────────────────────────
-- Tree-sitter highlighting. The `ndc` filetype is set by ftdetect/ndc.vim. The
-- parser (~/.config/nvim/parser/andy_cpp.so) and queries
-- (~/.config/nvim/queries/andy_cpp/) are installed manually, so this works
-- without nvim-treesitter.
vim.treesitter.language.register("andy_cpp", "ndc")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ndc",
  callback = function(args)
    pcall(vim.treesitter.start, args.buf, "andy_cpp")
  end,
})

-- Andy C++ language server (`ndc lsp`, stdio): hover, completion, go-to-definition,
-- document symbols and inlay hints. Uses Neovim's native LSP config (0.11+).
vim.lsp.config("ndc_lsp", {
  cmd = { "ndc", "lsp" },
  filetypes = { "ndc" },
  -- Single .ndc files are common; fall back to the file's directory when no .git.
  root_markers = { ".git" },
})
vim.lsp.enable("ndc_lsp")

-- Turn on inlay hints once the ndc server attaches.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "ndc_lsp" then
      pcall(vim.lsp.inlay_hint.enable, true, { bufnr = args.buf })
    end
  end,
})
