-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/nvim-mini/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps'
require('mini.deps').setup({ path = { package = path_package } })

-----------------------------------------------------------------------------
-- Setup mini modules.
-----------------------------------------------------------------------------
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Now: Safely execute function immediately. --------------------------------
now(function() require('mini.icons').setup() end)
now(
  function()
    require('mini.statusline').setup()
    vim.opt.laststatus = 3
    vim.opt.cmdheight = 0
  end
)
now(function() require('mini.tabline').setup() end)
now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify({})
end)

-- Later: Execute function later. -------------------------------------------
-- Appearance
later(function() require('mini.cursorword').setup() end)

-- Text editing.
later(function() require('mini.align').setup() end)
later(function() require('mini.surround').setup() end)
later(function()
  require('mini.splitjoin').setup({ mappings = { toggle = '<Leader>j' } })
end)
later(function()
  require('mini.operators').setup({
    replace = { prefix = 'R' },
    exchange = { prefix = 'g/' },
  })

  vim.keymap.set('n', 'RR', 'R', { desc = 'Replace mode' })
end)

later(function()
  require('mini.pairs').setup({
    mappings = {
      ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
      ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
      ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },
      ['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },

      [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
      [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
      ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },
      ['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].' },

      ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
      ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
      ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
    },
  })
  require('mini.completion').setup()

  require('mini.snippets').setup()
  -- Stop session immediately after jumping to final tabstop.
  local fin_stop = function(args)
    if args.data.tabstop_to == '0' then MiniSnippets.session.stop() end
  end
  local au_opts = { pattern = 'MiniSnippetsSessionJump', callback = fin_stop }
  vim.api.nvim_create_autocmd('User', au_opts)

  local map_multistep = require('mini.keymap').map_multistep
  map_multistep('i', '<Tab>', { 'minisnippets_expand', 'minisnippets_next' })
  map_multistep('i', '<S-Tab>', { 'minisnippets_prev' })
  map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
  map_multistep('i', '<BS>', { 'minipairs_bs' })
  map_multistep('i', '<C-h>', { 'minipairs_bs' })
end)

-- General workflow
later(function() require('mini.bufremove').setup() end)
later(function() require('mini.jump').setup({ delay = { idle_stop = 10, }, }) end)

later(function()
  require('mini.diff').setup({
    view = {
      style = 'sign',
      signs = { add = '+', change = '~', delete = '-' }
    },
    mappings = {
      goto_first = '[C',
      goto_prev = '[c',
      goto_next = ']c',
      goto_last = ']C',
    }
  })
end)
later(function() require('mini.git').setup({}) end)

later(function()
  require('mini.files').setup()
  vim.api.nvim_create_user_command(
    'Files',
    function()
      MiniFiles.open()
    end,
    { desc = 'Open file exproler' }
  )
end)

later(function()
  require('mini.pick').setup({
    mappings = {
      caret_left = '<C-b>',
      caret_right = '<C-f>',
      delete_char = '<C-h>',
      scroll_left = '<NOP>',
      scroll_up = '<NOP>',
    },
  })
  vim.ui.select = MiniPick.ui_select
  -- mappings
  vim.keymap.set('n', '<Leader>f', function()
    MiniPick.builtin.files({ tool = 'rg' })
  end, { desc = 'mini.pick.files' })
  vim.keymap.set('n', '<Leader>b', function()
    MiniPick.builtin.buffers({})
  end, { desc = 'mini.pick.buffers' })
  vim.keymap.set('n', '<Leader>G', function()
    MiniPick.builtin.grep()
  end, { desc = 'mini.pick.grep' })
end)
later(function()
  require('mini.extra').setup()
  -- mappings
  vim.keymap.set('n', '<Leader>l', function()
    MiniExtra.pickers.buf_lines({ scope = 'current' })
  end, { desc = 'mini.pick.buffers' })
end)

-----------------------------------------------------------------------------
-- Other Plugins
-----------------------------------------------------------------------------
-- colorscheme
now(function()
  add({ source = "catppuccin/nvim", name = "catppuccin" })
  vim.cmd.colorscheme "catppuccin"
end)
