-- Leader
-- =========================================================
vim.g.mapleader = " "

-- =========================================================
-- Basic options
-- =========================================================
vim.o.number = true
vim.o.relativenumber = true
vim.o.updatetime = 250

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.completeopt = "menu,menuone,noselect"

-- =========================================================
-- Plugins
-- =========================================================

vim.pack.add({

    {
		src = "https://github.com/rose-pine/neovim",
		name = "rose-pine",
	},
    --Mason
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    -- LSP
    "https://github.com/neovim/nvim-lspconfig",

    -- Theme
    "https://github.com/catppuccin/nvim",

    -- Go
    "https://github.com/ray-x/go.nvim",

    -- File explorer
    "https://github.com/stevearc/oil.nvim",
    -- Icon
    "https://github.com/nvim-tree/nvim-web-devicons",

    -- Autopairs
    "https://github.com/windwp/nvim-autopairs",

    -- FZF
    "https://github.com/ibhagwan/fzf-lua",

    -- DAP
    "https://github.com/mfussenegger/nvim-dap",

    "https://github.com/leoluz/nvim-dap-go",
    "https://github.com/rcarriga/nvim-dap-ui",

    -- Treesitter
    "https://github.com/nvim-treesitter/nvim-treesitter",


    -- Completion (STABLE)
    "https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/hrsh7th/cmp-nvim-lsp",
    "https://github.com/hrsh7th/cmp-buffer",
    "https://github.com/hrsh7th/cmp-path",
})


-- =========================================================
-- Filetype matching
-- =========================================================
vim.filetype.add({
    extension = {
        tmpl = "gotmpl",
        gohtml = "gotmpl",
    },
})

-- =========================================================
-- Mason
-- =========================================================
require("mason").setup()
require("mason-lspconfig").setup({
  -- automatic_enable = false,   -- Set to true if you want auto-setup for all installed servers
})
-- =========================================================
-- Treesitter
-- =========================================================

require('nvim-treesitter').setup {
    ensure_installed = {
        "lua", "rust", "javascript", "zig",
        "go", "bash", "json", "yaml", "markdown", "c_sharp", "svelte"
    },

    -- 2. Automatically install missing parsers when opening a file

    auto_install = true,

    -- 3. Enable syntax highlighting (This safely replaces your vim.treesitter.start() autocmd)
    highlight = {

        enable = true,
        
        -- Disable this if you experience slow parsing on massive files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))

            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        -- Set to true if you rely on legacy vim syntax for indentation
        additional_vim_regex_highlighting = false,
    },

    -- Optional: Enable indentation based on treesitter
    indent = {
        enable = true
    },
}

-- The native Neovim way (from the docs you found)
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "go", "lua", "bash", "json", "yaml", "markdown",
        "c_sharp", "rust", "javascript", "zig","svelte"
    },
    callback = function()
        -- pcall ensures that if a parser is missing, it fails silently 
        -- instead of crashing Neovim.
        pcall(vim.treesitter.start)
    end,
})

-- =========================================================
-- Colors
-- =========================================================
require("rose-pine").setup()
vim.cmd("colorscheme rose-pine")
-- =========================================================
-- Go plugin
-- =========================================================
require("go").setup({
    goimports = "gopls",
    gofmt = "gofumpt",
})

-- =========================================================
-- Oil
-- =========================================================
require("oil").setup({
  default_file_explorer = true,
  columns = {
    "icon",
  },
  keymaps = {
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
  },
})

-- =========================================================
-- Autopairs (NO CR CONFLICT)
-- =========================================================
require("nvim-autopairs").setup({
    map_cr = false,
    check_ts = false,
})

-- =========================================================
-- FZF
-- =========================================================
require("fzf-lua").setup({})
vim.keymap.set("n", "<leader>ff", function()
    require("fzf-lua").files()
end, { desc = "FZF Files" })
vim.keymap.set("n", "<leader>fg", function()
    require("fzf-lua").live_grep()
end, { desc = "FZF Live Grep" })
vim.keymap.set("n", "<leader>fb", function()
    require("fzf-lua").buffers()
end, { desc = "FZF Buffers" })
vim.keymap.set("n", "<leader>fh", function()
    require("fzf-lua").help_tags()
end, { desc = "FZF Help Tags" })
vim.keymap.set("n", "<leader>fx", function()
    require("fzf-lua").diagnostics_document()
end, { desc = "FZF Diagnostics Document" })
vim.keymap.set("n", "<leader>fX", function()
    require("fzf-lua").diagnostics_workspace()
end, { desc = "FZF Diagnostics Workspace" })
-- =========================================================
-- CMP (Completion - STABLE)
-- =========================================================
local cmp = require("cmp")

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),

        ["<CR>"] = cmp.mapping.confirm({ select = true }),

        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
    }),

    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
    },
})

-- =========================================================
-- LSP
-- =========================================================

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config = vim.lsp.config or {}


vim.lsp.config.gopls = {
    capabilities = capabilities,
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            staticcheck = true,
        },
    },
}

vim.lsp.enable("gopls")
vim.lsp.enable("lua_ls")
-- =========================================================
-- LSP keymaps
-- =========================================================
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local buf = args.buf

        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end


        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gr", vim.lsp.buf.references, "References")
        map("n", "K", vim.lsp.buf.hover, "Hover")

        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("n", "<leader>fm", vim.lsp.buf.format, "Format")

        -- Go organize imports (IMPORTANT)
        map("n", "<leader>i", function()
            vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports" } },

                apply = true,
            })
        end, "Organize Imports")
    end,
})

-- =========================================================
-- Diagnostics
-- =========================================================
vim.diagnostic.config({
    virtual_text = true,

    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
    end,
})

-- =========================================================
-- Auto format Go
-- =========================================================
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- =========================================================
-- DAP
-- =========================================================
local dap = require("dap")
local dapui = require("dapui")
require("dap-go").setup({})
dapui.setup()

vim.keymap.set("n", "<leader>du", dapui.toggle)

dap.listeners.after.event_initialized["dapui"] = function()
    dapui.open()
end

dap.listeners.before.event_terminated["dapui"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui"] = function()
    dapui.close()
end

-- =========================================================
-- Keymaps
-- =========================================================
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.keymap.set("n", "<C-p>", "<CMD>Oil<CR>")
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })