return {
    'williamboman/mason-lspconfig.nvim',
    name = 'mason-lspconfig',
    dependencies = {'mason.nvim', 'nvim-treesitter/nvim-treesitter'},
    config = function()
        require('mason-lspconfig').setup({
            automatic_installation = false,
            ensure_installed = {
                "svelte",
                "ts_ls",  -- TypeScript/JavaScript
            },
        })
        
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
          
          -- Debug: confirm on_attach ran
          print("LSP attached: " .. client.name .. " to buffer " .. bufnr)
        end
        
        -- Setup pyright using vim.lsp.config
        vim.lsp.config.pyright = {
            cmd = { 'pyright-langserver', '--stdio' },
            filetypes = { 'python' },
            root_markers = { '.git', 'pyproject.toml', 'setup.py', 'requirements.txt' },
            on_attach = on_attach,
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
            on_attach = on_attach,
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
            on_attach = on_attach,
        }
        
        -- Setup Svelte with fixed root_dir to prevent scanning system directories
        vim.lsp.config.svelte = {
            cmd = {'svelteserver', '--stdio'},
            filetypes = {'svelte'},
            on_attach = on_attach,
            root_markers = {'package.json', 'svelte.config.js', 'svelte.config.mjs', 'svelte.config.cjs', '.git'},
            settings = {
                svelte = {
                    plugin = {
                        svelte = {
                            compilerWarnings = {
                                -- Optionally suppress some warnings
                                ['a11y-aria-attributes'] = 'ignore',
                                ['a11y-incorrect-aria-attribute-type'] = 'ignore',
                            }
                        }
                    }
                }
            },
        }
        
        -- Enable the configurations - this will auto-start LSPs based on filetype
        vim.lsp.enable('pyright')
        vim.lsp.enable('gopls')
        vim.lsp.enable('ts_ls')
        vim.lsp.enable('svelte')
    end
}
