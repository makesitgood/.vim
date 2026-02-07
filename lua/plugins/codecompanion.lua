return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    ignore_warnings = true,
    display = {
        chat = {
            window = {
                width = 80,
            },
        },
    },
    adapters = {
        http = {
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                api_key = os.getenv("ANTHROPIC_API_KEY"),
              },
              schema = {
                model = {
                  -- default = "claude-sonnet-4-5-20250929",
                  default = "claude-haiku-4-5-20251001",
                },
              },
            })
          end,
        }
    },
    interactions = {  -- Changed from 'strategies' to 'interactions' (v18.0.0+)
      chat = {
        adapter = "anthropic",
        slash_commands = {
          ["file"] = {
            callback = "interactions.chat.slash_commands.builtin.file",
            description = "Select a file using Telescope",
            opts = {
              provider = "telescope",
              contains_code = true,
            },
          },
        },
        tools = {
          ["create_file"] = {
            opts = {
              require_approval_before = false,  -- Auto-approve file creation
            },
          },
          ["insert_edit_into_file"] = {
            opts = {
              require_approval_before = false,  -- Auto-approve file edits
              require_confirmation_after = true,  
            },
          },
          ["read_file"] = {
            opts = {
              require_approval_before = false,  -- Auto-approve file reads
            },
          },
        },
      },
      inline = {
        adapter = "anthropic",
      },
      cmd = {
        adapter = "anthropic",
      },
    },
    rules = {
      default = {
        description = "Collection of common files for all projects",
        files = {
          { path = "CLAUDE.md", parser = "claude" },
          { path = "CLAUDE.local.md", parser = "claude" },
          { path = "~/.claude/CLAUDE.md", parser = "claude" },
        },
      },
    },    
    opts = {
      log_level = "INFO",
    },
  },
}
