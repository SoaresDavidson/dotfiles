return {
  -- Treesitter highlighting/indentation for *.v files. The parser is named
  -- "systemverilog" and only claims that filetype, so also point the plain
  -- `verilog` filetype at it.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "systemverilog" } },
    init = function()
      vim.treesitter.language.register("systemverilog", "verilog")
    end,
  },

  -- Verible language server (installed via Mason as verible-verilog-ls).
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        verible = {},
      },
    },
  },
}
