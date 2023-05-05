local hop = pRequire("hop")
if hop then
  hop.setup({
    case_insensitive = false, -- Ignore case while searching
  })
  local directions = require('hop.hint').HintDirection
  keymap('', 'f', function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR })
  end)
  keymap('', 'F', function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR })
  end)
  keymap('', 't', function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = 1 })
  end)
  keymap('', 'T', function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
  end)
  keymap('', '<leader><leader>b', function()
    hop.hint_words({ direction = directions.BEFORE_CURSOR })
  end)
  keymap('', '<leader><leader>w', function()
    hop.hint_words({ direction = directions.AFTER_CURSOR })
  end)
end
