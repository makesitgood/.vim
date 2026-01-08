vim.g.python3_host_prog = '/usr/bin/python3'
vim.g.loaded_python_provider = 0

require("config.lazy")

vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')
--hi clear SignColumn

vim.o.equalalways = false
vim.opt.compatible = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.encoding = 'utf-8'
vim.opt.hidden = true
vim.opt.cmdheight = 2
vim.opt.updatetime = 300
vim.opt.cursorline = false
vim.opt.cursorcolumn = false
vim.opt.synmaxcol = 200
vim.opt.wrap = false
vim.opt.ttimeoutlen = 100
vim.opt.number = true
vim.opt.completeopt = 'menu,menuone,noinsert,noselect'
vim.opt.showmode = true
vim.opt.hlsearch = true
vim.opt.smartcase = true
vim.opt.linespace = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.smarttab = true
vim.opt.cindent = true
--vim.opt.backup = false
--vim.opt.writebackup = false
--vim.opt.noswapfile 
vim.opt.foldmethod = 'syntax'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
--vim.opt.t_Co = 256
vim.opt.guifont = 'FiraCode Nerd Font:h12'
--vim.opt.guifont = 'JetBrainsMono Nerd Font:h12'
vim.opt.wildignore = '*.class,*.jar,*.swf,*.swc,*.git,*.jpg,*.png,*.mp3,*.pyc,*/build/*,*/node_modules/*,*/bower_components/*'

vim.g.neovide_transparency = 0.9

if vim.env.TERM == nil then
    vim.env.TERM = "xterm-256color"
end

-- " Close buffer without closing window

local function delete_cur_buffer_not_close_window()
  if vim.bo.modified then
    vim.api.nvim_echo({{
      'E89: no write since last change',
      'ErrorMsg'
    }}, true, {})
    return
  end

  local oldbuf = vim.api.nvim_get_current_buf()
  local oldwin = vim.api.nvim_get_current_win()
  
  -- Check if we're in a single buffer situation
  local buffer_count = 0
  for _ in pairs(vim.fn.getbufinfo({buflisted = 1})) do
    buffer_count = buffer_count + 1
  end
  
  -- If there's only one buffer, create a new one before deleting
  if buffer_count <= 1 then
    vim.cmd('enew')
    vim.cmd(oldbuf .. 'bd')
    return
  end
  
  -- Multiple windows case
  if #vim.api.nvim_list_wins() == 1 then
    -- Single window but multiple buffers
    if vim.fn.buflisted(vim.fn.bufnr('#')) == 1 then
      vim.cmd('b#')  -- Switch to alternate buffer
    else
      vim.cmd('bn')  -- Switch to next buffer
    end
    vim.cmd(oldbuf .. 'bd')
  else 
    -- Multiple windows
    while true do -- all windows that display oldbuf will remain open
      if vim.fn.buflisted(vim.fn.bufnr('#')) == 1 then
        vim.cmd('b#')
      else
        vim.cmd('bn')
        local curbuf = vim.api.nvim_get_current_buf()
        if curbuf == oldbuf then
          vim.cmd('enew') -- oldbuf is the only buffer, create one
        end
      end
      
      local win = vim.fn.bufwinnr(oldbuf)
      if win == -1 then
        break
      else -- there are other windows that display oldbuf
        vim.cmd(win .. 'wincmd w')
      end
    end
    
    -- delete oldbuf and restore window to oldwin
    vim.cmd(oldbuf .. 'bd')
    vim.api.nvim_set_current_win(oldwin)
  end
end
_G.delete_cur_buffer_not_close_window = delete_cur_buffer_not_close_window
-- " Plugin configs

vim.g.bclose_multiple = 1
vim.g.NERDTreeIgnore = {'^node_modules$', 'pyc$'}

-- autocommands

vim.api.nvim_create_autocmd('CompleteDone', {
	pattern = {'*'},
	command = 'pclose'
})
vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = {'*.go'},
	command = 'lua go_org_imports()'
})

-- mappings
local function map(mode, combo, mapping, opts)
	local options = {noremap = true}
	if opts then
		options = vim.tbl_extend('force', options, opts)
	end

    if type(mapping) == "function" then
        vim.keymap.set(mode, combo, mapping, options)
    else
        vim.api.nvim_set_keymap(mode, combo, mapping, options)
    end
end

vim.g.mapleader = " "

map('i', '<C-c>', '<Esc>')
map('', '-', ':nohls<cr>')
map('', '<leader>?', ':lua vim.diagnostic.open_float()<cr>')
map('v', '<C-y>', ":'<,'>w !xclip -selection clipboard<Cr><Cr>", {noremap = true})
map('v', '<C-v>', "<ESC>\"+p", {noremap = true})
map('t', '<Esc>', '<C-\\><C-n>', {noremap = true})
map('', '<leader>p', ':bprevious<CR>', {noremap = true})
map('', '<leader>n', ':bnext<CR>', {noremap = true})
map('i', 'jk', '<Esc>')
map('n', '<leader>*', ':Grepper -tool ag -cword -noprompt<cr>')
map('n', '<leader>g', ':Grepper -tool ag<cr>')
map('v', '<', '<gv', {noremap = true})
map('v', '>', '>gv', {noremap = true})
map('v', 'y', 'myy`y', {noremap = true})
map('v', 'Y', 'myY`y', {noremap = true})
map('c', 'w!!', 'w !sudo tee % >/dev/null')
map('n', '<C-p>', ':Telescope find_files<cr>', {noremap = true})
map('n', '<leader>b', ':Telescope buffers<cr>', {noremap = true})
map('n', '<leader>c', _G.delete_cur_buffer_not_close_window, {noremap = true})
map('n', '<leader>ac', ':CodeCompanionChat toggle<CR>')
map('v', '<leader>ae', ":'<,'>CodeCompanion /explain<CR>")
map('v', '<leader>at', ":'<,'>CodeCompanion /tests<CR>")
map('n', '<leader>aa', ':CodeCompanionActions<CR>')

-- Because I'm always typing :W to save
vim.api.nvim_create_user_command('W', 'w', {})


vim.cmd([[colorscheme kanagawa]])


vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN]  = "▲",
      [vim.diagnostic.severity.HINT]  = "⚑",
      [vim.diagnostic.severity.INFO]  = "»",
    },
  },
  virtual_text = true,
  underline = true,
  update_in_insert = false,
})

local presets = require("markview.presets");

require("markview").setup({
    markdown = {
        headings = presets.headings.slanted,
        horizontal_rules = presets.headings.arrowed
    }
});


-- ui/completion.lua (source anywhere that runs during startup)

-- 1. How the popup behaves
vim.opt.completeopt = { "menuone", "noselect", "noinsert", "popup" }  -- popup-doc window too :contentReference[oaicite:0]{index=0}
vim.opt.pumheight   = 12        -- at most 12 items
vim.opt.pumblend    = 10        -- 10-ish → subtle transparency :contentReference[oaicite:1]{index=1}
vim.opt.shortmess:append("c")   -- no "match 1 of 10" echo

-- 2. Accept or abort with familiar keys
vim.keymap.set("i", "<CR>",    function() return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>" end,
               { expr = true, desc = "confirm completion or newline" })        -- :contentReference[oaicite:2]{index=2}
vim.keymap.set("i", "<Esc>",   function() return vim.fn.pumvisible() == 1 and "<C-e>" or "<Esc>" end,
               { expr = true, desc = "cancel popup or normal Esc" })
-- lsp/attach.lua
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     local buf    = args.buf
--     if client and client:supports_method("textDocument/completion") then
--       -- built-in completion, auto-popup on triggerCharacters
--       vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })  -- :contentReference[oaicite:3]{index=3}
-- 
--       -- manual trigger when you want it
--       vim.keymap.set("i", "<C-Space>", vim.lsp.completion.trigger,
--                      { buffer = buf, desc = "trigger LSP completion" })
--     end
--   end,
-- })

function go_org_imports(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for cid, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
        end
    end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "codecompanion", -- Target the chat buffer's filetype
  group = vim.api.nvim_create_augroup("CodeCompanionResize", { clear = true }),
  callback = function()
    -- Set the width of the current window (the chat window) to 40 columns
    vim.cmd("vertical resize 40")
    
    -- Equalize the size of all *other* windows in the current tab/split group.
    -- This is important to ensure your code window gets a fair share back.
    vim.cmd("wincmd =")
  end,
})
