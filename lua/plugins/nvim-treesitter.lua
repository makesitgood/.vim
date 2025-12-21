return {
  "nvim-treesitter/nvim-treesitter",
  name = "nvim-treesitter",
  version = false, -- last release is way too old and doesn't work on Windows
  build = ":TSUpdate",
  lazy = false, -- load treesitter early when opening a file from the cmdline
  -- cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  opts_extend = { "ensure_installed" },
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "bash",
      "c",
      "css",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "query",
      "regex",
      "svelte",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
  },
  config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
}
