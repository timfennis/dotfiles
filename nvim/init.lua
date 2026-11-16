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

-- <C-s> -> save, from normal, insert, visual and select mode (LazyVim's binding).
-- Ends in normal mode. Replaces Neovim's default insert-mode <C-s> (LSP
-- signature help).
vim.keymap.set({ "n", "i", "x", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Briefly highlight yanked text (built in, no plugin needed).
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Completion: blink.cmp (pack/plugins/start/blink.cmp, pinned to a release tag
-- so it can fetch its prebuilt fuzzy-matcher binary). Unlike the built-in
-- vim.lsp.completion autotrigger, it pops up while typing plain identifiers,
-- not just on server trigger characters like `.`.
-- Accept with <C-y>, cancel with <C-e>, navigate with <C-n>/<C-p>,
-- manual trigger / docs with <C-space>.
vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }  -- still used by <C-x> modes
require("blink.cmp").setup({
  -- Match the old behaviour: show the menu but don't preselect or auto-insert
  -- the first entry — nothing is chosen until you pick it explicitly.
  completion = {
    list = { selection = { preselect = false, auto_insert = false } },
  },
})

-- Show language-server diagnostics inline.
vim.diagnostic.config({ virtual_text = true })

-- Advertise blink's completion capabilities to every LSP server.
vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

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

-- <leader>r runs the buffer (or, in visual mode, the selection) with
-- `ndc run --eval`, so it doesn't need saving. Output goes to a terminal split
-- at the bottom that is replaced on each run; focus stays in the code. The
-- script's stdin is that terminal (<C-w>j then i to type into it, <C-c> to stop).
local ndc_run_buf
local function ndc_run(lines)
  if ndc_run_buf and vim.api.nvim_buf_is_valid(ndc_run_buf) then
    vim.api.nvim_buf_delete(ndc_run_buf, { force = true })
  end
  vim.cmd("botright 15new")
  ndc_run_buf = vim.api.nvim_get_current_buf()
  vim.fn.jobstart({ "ndc", "run", "--eval", table.concat(lines, "\n") }, { term = true })
  vim.cmd.wincmd("p")
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ndc",
  callback = function(args)
    vim.keymap.set("n", "<leader>r", function()
      ndc_run(vim.api.nvim_buf_get_lines(0, 0, -1, false))
    end, { buffer = args.buf, desc = "Run Andy C++ buffer" })
    vim.keymap.set("x", "<leader>r", function()
      ndc_run(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() }))
      vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
    end, { buffer = args.buf, desc = "Run Andy C++ selection" })
  end,
})
