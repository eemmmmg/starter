vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
  { "gen.nvim", lazy = false },
  { "conform.nvim", lazy = false },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

--------------------------------------------------------------------- NVIM TREE START
local function open_nvim_tree()
  require("nvim-tree.api").tree.toggle(false, true)
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- Make :bd and :q behave as usual when tree is visible
vim.api.nvim_create_autocmd({ "BufEnter", "QuitPre" }, {
  nested = false,
  callback = function(e)
    local tree = require("nvim-tree.api").tree

    -- Nothing to do if tree is not opened
    if not tree.is_visible() then
      return
    end

    -- How many focusable windows do we have? (excluding e.g. incline status window)
    local winCount = 0
    for _, winId in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(winId).focusable then
        winCount = winCount + 1
      end
    end

    -- We want to quit and only one window besides tree is left
    if e.event == "QuitPre" and winCount == 2 then
      vim.api.nvim_cmd({ cmd = "qall" }, {})
    end

    -- :bd was probably issued an only tree window is left
    -- Behave as if tree was closed (see `:h :bd`)
    if e.event == "BufEnter" and winCount == 1 then
      -- Required to avoid "Vim:E444: Cannot close last window"
      vim.defer_fn(function()
        -- close nvim-tree: will go to the last buffer used before closing
        tree.toggle { find_file = true, focus = true }
        -- re-open nivm-tree
        tree.toggle { find_file = true, focus = false }
      end, 10)
    end
  end,
})
--------------------------------------------------------------------- NVIM TREE END

--vim.api.nvim_create_autocmd("FileType", {
--  pattern = "kotlin",
--  callback = function()
--    vim.opt.shiftwidth = 4
--    vim.opt.tabstop = 4
--   vim.opt.softtabstop = 4
--  end,
--})

--vim.api.nvim_create_autocmd("FileType", {
--  pattern = "java",
--  callback = function()
--    vim.opt.shiftwidth = 4
--    vim.opt.tabstop = 4
--    vim.opt.softtabstop = 4
--  end,
--})

--------------------------------------------------------------------- OLLAMA GEN.NVIM START
require("gen").prompts = {
  Fix_Code = {
    prompt = "Look at the following code and identify and fix bugs or problems. Make the necessary changes. Also do not explain what you did or comment on anything just provide code in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
    replace = true,
    extract = "```$filetype\n(.-)```",
  },
  Improve_Performance = {
    prompt = "Look at the following code and try to improve performance while maintaining readability. Make the necessary changes. Also do not explain what you did or comment on anything just provide code in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
    replace = true,
    extract = "```$filetype\n(.-)```",
  },
  Improve_Readability = {
    prompt = "Look at the following code and enhance it for readability while keeping in mind performance. Make the necessary changes. Also do not explain what you did or comment on anything just provide code in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
    replace = true,
    extract = "```$filetype\n(.-)```",
  },
  Add_Comments = {
    prompt = "Look at the following code and add a concise comment explaining the primary purpose, and explain any parameters and what they're used for. Also do not explain what you did or comment on anything just provide the commented code in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
    replace = true,
    extract = "```$filetype\n(.-)```",
  },
  Simplify = {
    prompt = "Look at the following code and simplify it as much as possible. Make the necessary changes. Also do not explain what you did or comment on anything just provide the commented code in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
    replace = true,
    extract = "```$filetype\n(.-)```",
  },
  Create_Unit_Tests = {
    prompt = "Look at the following code and create unit tests. Do not mock any private methods or variables. Create a comment and provide the unit tests code. Also do not explain what you did or comment on anything just provide the commented code in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
    replace = false,
    extract = "",
  },
  Review_Code = {
    prompt = "Review the following code and make concise suggestions to improve readability, improve performance, fix any obvious bugs, etc.:\n```$filetype\n...\n```:\n```$filetype\n$text\n```",
    replace = false,
    extract = "",
  },
  Chat = { prompt = "$input" },
  Ask_About_Code = {
    prompt = "Regarding the following code, $input\n```$filetype\n...\n```:\n```$filetype\n$text\n```",
  },
}
--------------------------------------------------------------------- OLLAMA GEN.NVIM END

--------------------------------------------------------------------- CONFIRM.NVIM START
--require("conform").setup({
--  formatters_by_ft = {
--    lua = { "stylua" },
--    -- You can customize some of the format options for the filetype (:help conform.format)
--    rust = { "rustfmt" },
--    kotlin = { "ktfmt" },
--    java = { "google-java-format" }
--  },
--})
require("conform").formatters.ktfmt = {
  prepend_args = { "--kotlinlang-style" },
}
--------------------------------------------------------------------- CONFIRM.NVIM END
