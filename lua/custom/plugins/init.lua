-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
  {
    '3rd/image.nvim',
    lazy = false,
    build = false, -- disable luarocks rock install; magick_cli processor doesn't need it
    opts = {
      backend = 'kitty',
      processor = 'magick_cli',
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { 'markdown', 'vimwiki' },
        },
      },
      max_width_window_percentage = 80,
      max_height_window_percentage = 50,
      hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
    },
  },
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup {
        keymaps = {
          accept_suggestion = '<C-Enter>',
          clear_suggestion = '<C-]>',
          accept_word = '<C-j>',
        },
      }
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        transparent_background = true,
      }

      -- setup must be called before loading
      vim.cmd.colorscheme 'catppuccin-mocha'
    end,
  },
  { 'ellisonleao/gruvbox.nvim', priority = 1000, config = true, opts = function() end },
  {
    'taigrr/blast.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'taigrr/neocrush.nvim',
    event = 'VeryLazy',
    opts = {},
  },
}
