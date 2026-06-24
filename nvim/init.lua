-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- Andy C++ (.ndc) tree-sitter support.
-- The `ndc` filetype is set by ftdetect/ndc.vim. The parser
-- (~/.config/nvim/parser/andy_cpp.so) and queries
-- (~/.config/nvim/queries/andy_cpp/) are installed manually, so this works
-- regardless of the nvim-treesitter branch.
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
