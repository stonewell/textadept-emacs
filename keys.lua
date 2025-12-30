local M = {}

local E = require 'emacs.editing'
local I = require 'emacs.interactive'

local function m(path) return textadept.menu.menubar[path][2] end

function nothing() end

function M.enable()
  keys['ctrl+s'] = function() keys.mode = 'find_incremental'; find_incr(); end  
  keys['ctrl+r'] = function() keys.mode = 'find_incremental'; find_incr(); end  

  -- Incremental search keymap (you need recent version of textadept)
  keys.find_incremental = {
    ['ctrl+s'] = ui.find.incremental,
    ['\n'] = function() gui.command_entry.finish_mode(nothing) end,
    ['esc'] = function() keys.mode = nil end
  }

  -- keys.filter_through['\n'] =
  --   { ui.command_entry.finish_mode, textadept.editing.filter_through }

  -- Emacs-like key bindings
  -- do not bind 'cl' (used by other modes), 'ct cl' will redraw
  -- do not bind 'c ' (used for auto completion), set mark is 'cr'

  keys['ctrl+a'] = buffer.vc_home
  keys['ctrl+e'] = buffer.line_end
  keys['meta+<'] = function() E.save_mark(buffer.document_start) end
  keys['meta+>'] = function() E.save_mark(buffer.document_end) end

  keys['ctrl+f'] = I.repeatable(buffer.char_right)
  keys['ctrl+b'] = I.repeatable(buffer.char_left)
  keys['meta+f'] = I.repeatable(buffer.word_right)
  keys['meta+b'] = I.repeatable(buffer.word_left)

  keys['ctrl+d'] = I.repeatable(buffer.clear)
  keys['meta+d'] = E.move_cut(I.repeatable(buffer.word_right))
  keys['ctrl+meta+h'] = E.move_cut(I.repeatable(buffer.del_word_left)) -- not working

  keys['ctrl+k'] = E.move_cut(E.line_end)
  keys['meta+^'] = textadept.editing.join_lines

  keys['ctrl+n'] = I.repeatable(buffer.line_down)
  keys['ctrl+p'] = I.repeatable(buffer.line_up)

  keys['ctrl+v'] = buffer.page_down
  keys['meta+v'] = buffer.page_up

  keys['ctrl+u'] = I.numeric_prefix

  keys['ctrl+r'] = E.set_mark
  keys['ctrl+w'] = E.with_region(E.cut)
  keys['meta+w'] = E.with_region(E.copy)
  keys['ctrl+y'] = buffer.paste

  keys['meta+ '] = E.just_one_space
  keys['meta+|+ '] = {ui.command_entry.enter_mode, 'filter_through'}

  keys['ctrl+_'] = I.repeatable(buffer.undo)

  -- Custom key bindings can go here
  keys['ctrl+t'] = {
    ['b'] = textadept.run.run,
    ['f'] = ui.find.focus,
    ['ctrl+g'] = function() I.wrap(buffer.goto_line, I.PROMPT('Goto line:')) end,
    ['ctrl+l'] = buffer.vertical_centre_caret,
  }

  -- Emacs ctl-x key map
  keys['ctrl+x'] = {
    ['b'] = I.switch_buffer,
    ['k'] = I.pick_buffer('Kill Buffer:', buffer.close),
    ['r'] = buffer.reload,
    ['ctrl+c'] = quit,
    ['ctrl+f'] = io.open_file,
    ['ctrl+r'] = io.open_recent_file,
    ['ctrl+s'] = buffer.save,
    ['ctrl+w'] = buffer.save_as,
    ['ctrl+x'] = E.exchange_caret_and_mark,
  }

end

return M
