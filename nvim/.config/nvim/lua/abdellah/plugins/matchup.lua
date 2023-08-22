return {
  'andymass/vim-matchup',
  config = function()
    -- disable awkward offscreen matching
    vim.cmd([[let g:matchup_matchparen_offscreen = {}]])
  end,
  event = 'BufReadPost',
}
