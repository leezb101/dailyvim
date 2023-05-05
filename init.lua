require("insis").setup({
  frontend = {
    enable = true,
    prisma = true,
    vue = true,
    format_on_save = true,
    -- code_actions = "eslint_d",
    ---@type "eslint_d" | "prettier"
    formatter = "prettier",
    cspell = false,
    -- extra lsp command provided by typescript.nvim
    typescript = {
      keys = {
        ts_organize = "gs",
        ts_rename_file = "gR",
        ts_add_missing_import = "ga",
        ts_remove_unused = "gu",
        ts_fix_all = "gf",
        ts_goto_source = "gD",
      },
    },
  },
})
