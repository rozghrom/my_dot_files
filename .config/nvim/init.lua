vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup({
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "nvim-treesitter/nvim-treesitter",  build = ":TSUpdate" },
    { "VonHeikemen/lsp-zero.nvim",        branch = "v3.x" },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip" },
    { "hrsh7th/cmp-nvim-lua" },
    { "ellisonleao/gruvbox.nvim",         priority = 1000,    config = true, opts = ... },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    {
        "romgrk/barbar.nvim",
        dependencies = {
            "lewis6991/gitsigns.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        init = function() vim.g.barbar_auto_setup = false end,
        opts = {},
        version = "^1.0.0",
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({
                view = {
                    side = "right",
                },
            })
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        'numToStr/Comment.nvim',
        opts = {},
        lazy = false,
    },
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },
    {
        "andrewferrier/wrapping.nvim",
        config = function()
            require("wrapping").setup()
        end
    },
    { "lukas-reineke/indent-blankline.nvim",      main = "ibl",  opts = {} },
})

vim.cmd.colorscheme("gruvbox")

local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(_, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })

    vim.keymap.set("n", "<C-i>", vim.lsp.buf.hover)
end)

local cmp = require("cmp")

cmp.setup({
    preselect = "item",
    completion = {
        completeopt = "menu,menuone,noinsert"
    },
    mapping = {
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    },
})

require("mason").setup({})
require("mason-lspconfig").setup({
    sources = {
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
    },
    ensure_installed = {},
    handlers = {
        function(server_name)
            require("lspconfig")[server_name].setup({})
        end,
    },
})

require('lspconfig').gdscript.setup({})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

require('telescope').load_extension('fzf')

require("nvim-treesitter.configs").setup({
    ensure_installed = { "javascript", "typescript", "svelte", "astro", "lua", "vim", "vimdoc", "query" },
    highlight = {
        enable = true,
    },
})

require("barbar").setup({
    sidebar_filetypes = {
        NvimTree = {
            align = "right",
        },
    },
    icons = {
        separator = { left = "", right = "" }
    }
})

require("lualine").setup({
    options = {
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        globalstatus = true,
    },
})

require('Comment').setup()

require("ibl").setup({ scope = { enabled = false } })

vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.autoindent = true
vim.o.smartindent = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.wrap = false

vim.o.scl = "no"

vim.opt.fillchars = { eob = " " }

vim.api.nvim_create_autocmd("BufWrite", {
    callback = function()
        vim.lsp.buf.format()
    end
})

vim.keymap.set("n", "<leader>tt", "<Cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>tf", "<Cmd>NvimTreeFocus<CR>")

vim.keymap.set("n", "J", "<Cmd>BufferPrevious<CR>")
vim.keymap.set("n", "K", "<Cmd>BufferNext<CR>")
vim.keymap.set("n", "<C-left>", "<Cmd>BufferMovePrevious<CR>")
vim.keymap.set("n", "<C-right>", "<Cmd>BufferMoveNext<CR>")
vim.keymap.set("n", "<C-1>", "<Cmd>BufferGoto 1<CR>")
vim.keymap.set("n", "<C-2>", "<Cmd>BufferGoto 2<CR>")
vim.keymap.set("n", "<C-3>", "<Cmd>BufferGoto 3<CR>")
vim.keymap.set("n", "<C-4>", "<Cmd>BufferGoto 4<CR>")
vim.keymap.set("n", "<C-5>", "<Cmd>BufferGoto 5<CR>")
vim.keymap.set("n", "<C-6>", "<Cmd>BufferGoto 6<CR>")
vim.keymap.set("n", "<C-7>", "<Cmd>BufferGoto 7<CR>")
vim.keymap.set("n", "<C-8>", "<Cmd>BufferGoto 8<CR>")
vim.keymap.set("n", "<C-9>", "<Cmd>BufferGoto 9<CR>")
vim.keymap.set("n", "<C-0>", "<Cmd>BufferLast<CR>")
vim.keymap.set("n", "<C-x>", "<Cmd>BufferClose<CR>")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-s>", "<Cmd>w<CR>")
vim.keymap.set("n", "<C-q>", "<Cmd>qa<CR>")

vim.keymap.set("n", "<leader>w", "<C-w>")

vim.keymap.set("n", "<leader>o", "o<Esc>")
vim.keymap.set("n", "<leader>O", "O<Esc>")

vim.keymap.set("n", "<C-c>", "<Cmd>noh<CR>")

vim.cmd([[
    noremap <expr> j v:count ? 'j' : 'gj'
    noremap <expr> k v:count ? 'k' : 'gk'
]])
