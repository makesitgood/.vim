return {
  'nvim-telescope/telescope.nvim',
  name = 'nvim-telescope',
  dependencies = {'plenary.nvim'},
  config = function()
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    local multi_open = function(prompt_bufnr)
      local picker = action_state.get_current_picker(prompt_bufnr)
      local multi_selection = picker:get_multi_selection()

      if #multi_selection > 1 then
        actions.close(prompt_bufnr)
        for _, entry in ipairs(multi_selection) do
          vim.cmd(string.format("edit %s", entry.value))
        end
      else
        actions.select_default(prompt_bufnr)
      end
    end

    require('telescope').setup({
      -- Don't set default mappings, leave them as-is for other plugins
    })
    
    -- Create a custom find_files command with multi-open
    vim.api.nvim_create_user_command('TelescopeFindFilesMulti', function()
      require('telescope.builtin').find_files({
        attach_mappings = function(_, map)
          map('i', '<CR>', multi_open)
          map('n', '<CR>', multi_open)
          return true
        end,
      })
    end, {})
  end
}
