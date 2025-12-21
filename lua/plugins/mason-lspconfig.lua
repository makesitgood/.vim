return {
    'williamboman/mason-lspconfig.nvim',
    name = 'mason-lspconfig',
    dependencies = {'mason.nvim', 'nvim-treesitter/nvim-treesitter'},
    opts = {
        automatic_installation = true,
        ensure_installed = {
            "svelte",
            "ts_ls",  -- TypeScript/JavaScript
        },
    },
    config = function()
        local util = require('lspconfig.util')
        local path = util.path
        
        -- Use an on_attach function to only map the following keys
        -- after the language server attaches to the current buffer
        local on_attach = function(client, bufnr)
          -- Mappings.
          local opts = { noremap=true, silent=true, buffer=bufnr }
          
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
          vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)
        end
        
        -- Setup pyright using vim.lsp.config
        vim.lsp.config.pyright = {
            cmd = { 'pyright-langserver', '--stdio' },
            filetypes = { 'python' },
            root_markers = { '.git', 'pyproject.toml', 'setup.py', 'requirements.txt' },
            settings = {
                python = {
                    analysis = {
                        extraPaths = {
                            "/home/alex/Code/cjdev/services/cratejoy"
                        }
                    }
                }
            },
            before_init = function(params, config)
                config.settings.python.pythonPath = vim.fn.expand('$HOME/venv/bin/python')
            end,
        }
        
        -- Setup gopls using vim.lsp.config
        vim.lsp.config.gopls = {
            cmd = {'gopls', 'serve'},
            filetypes = {'go', 'gomod'},
            root_markers = {'go.work', 'go.mod', '.git'},
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                },
            },
        }
        
        -- Setup TypeScript/JavaScript
        vim.lsp.config.ts_ls = {
            cmd = {'typescript-language-server', '--stdio'},
            filetypes = {'javascript', 'javascriptreact', 'typescript', 'typescriptreact'},
            root_markers = {'package.json', 'tsconfig.json', 'jsconfig.json', '.git'},
        }
        
        -- Setup Svelte
        vim.lsp.config.svelte = {
            cmd = {'svelteserver', '--stdio'},
            filetypes = {'svelte'},
            root_markers = {'package.json', '.git'},
            on_new_config = function(config, root_dir)
                config.settings = vim.tbl_deep_extend('force', config.settings or {}, {
                    svelte = {
                        plugin = {
                            svelte = {
                                -- Exclude problematic directories
                                exclude = {'/run/**', '/dev/**', '/proc/**', '/sys/**'}
                            }
                        }
                    }
                })
            end,
        }
        
        -- Enable the configurations with vim.lsp.enable
        vim.lsp.enable('pyright')
        vim.lsp.enable('gopls')
        vim.lsp.enable('ts_ls')
        vim.lsp.enable('svelte')
        
        -- Set up autocmd to attach to buffers
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'python',
            callback = function(args)
                vim.lsp.start(vim.lsp.config.pyright, { 
                    bufnr = args.buf,
                    on_attach = on_attach
                })
            end,
        })
        
        vim.api.nvim_create_autocmd('FileType', {
            pattern = {'go', 'gomod'},
            callback = function(args)
                vim.lsp.start(vim.lsp.config.gopls, { 
                    bufnr = args.buf,
                    on_attach = on_attach
                })
            end,
        })
        
        vim.api.nvim_create_autocmd('FileType', {
            pattern = {'javascript', 'javascriptreact', 'typescript', 'typescriptreact'},
            callback = function(args)
                vim.lsp.start(vim.lsp.config.ts_ls, { 
                    bufnr = args.buf,
                    on_attach = on_attach
                })
            end,
        })
        
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'svelte',
            callback = function(args)
                vim.lsp.start(vim.lsp.config.svelte, { 
                    bufnr = args.buf,
                    on_attach = on_attach
                })
            end,
        })
    end
}
