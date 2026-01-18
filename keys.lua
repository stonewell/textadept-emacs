local M = {}

local E = require 'emacs.editing'
local I = require 'emacs.interactive'
local isearch = require 'isearch'
local textredux = require 'textredux'

local function m(path) return textadept.menu.menubar[path][2] end

function nothing() end

function M.enable()
  keys['ctrl+s'] = function()
    isearch.search.start_search(true, false)
  end
  keys['ctrl+r'] = function()
        isearch.search.start_search(true, false)
  end

  -- keys.filter_through['\n'] =
  --   { ui.command_entry.finish_mode, textadept.editing.filter_through }

  -- Emacs-like key bindings
  -- do not bind 'cl' (used by other modes), 'ct cl' will redraw
  -- do not bind 'c ' (used for auto completion), set mark is 'cr'

  keys['ctrl+a'] = buffer.vc_home
  keys['ctrl+e'] = buffer.line_end
  keys['alt+<'] = function() E.save_mark(buffer.document_start) end
  keys['alt+>'] = function() E.save_mark(buffer.document_end) end

  keys['ctrl+f'] = I.repeatable(buffer.char_right)
  keys['ctrl+b'] = I.repeatable(buffer.char_left)
  keys['alt+f'] = I.repeatable(buffer.word_right)
  keys['alt+b'] = I.repeatable(buffer.word_left)

  keys['ctrl+d'] = I.repeatable(buffer.clear)
  keys['alt+d'] = E.move_cut(I.repeatable(buffer.word_right))
  keys['ctrl+alt+h'] = E.move_cut(I.repeatable(buffer.del_word_left)) -- not working

  keys['ctrl+g'] = E.cancel

  keys['ctrl+k'] = E.move_cut(E.line_end)
  keys['alt+^'] = textadept.editing.join_lines

  keys['ctrl+n'] = I.repeatable(buffer.line_down)
  keys['ctrl+p'] = I.repeatable(buffer.line_up)

  keys['ctrl+v'] = buffer.page_down
  keys['alt+v'] = buffer.page_up

  keys['ctrl+u'] = I.numeric_prefix

  keys['ctrl+ '] = E.set_mark
  keys['ctrl+w'] = E.with_region(E.cut)
  keys['alt+w'] = E.with_region(E.copy)

  keys['ctrl+y'] = buffer.paste

  keys['alt+ '] = E.just_one_space
  -- keys['alt+|+ '] = {ui.command_entry.enter_mode, 'filter_through'}

  keys['ctrl+_'] = I.repeatable(buffer.undo)

  -- Custom key bindings can go here
  keys['ctrl+t'] = {
    ['b'] = textadept.run.run,
    ['f'] = ui.find.focus,
    ['ctrl+g'] = function() I.wrap(buffer.goto_line, I.PROMPT('Goto line:')) end,
    ['ctrl+l'] = buffer.vertical_centre_caret,
  }

  -- Emacs ctl-x key map
  local fn_dispatch = {
    ['open'] = textredux.fs.open_file,
    ['switchbuffer'] = textredux.buffer_list.show,
    ['saveas'] = textredux.fs.save_buffer_as,
    ['open_recent'] = textredux.core.filteredlist.wrap(io.open_recent_file),
    -- ['switchbuffer_project'] = textredux.core.filteredlist.wrap(util.show_project_buffers),

    -- ['open_recent'] = io.open_recent_file,
  }

  keys['ctrl+x'] = {
    ['0'] = function() view:unsplit() end,
    ['b'] = fn_dispatch['switchbuffer'],
    ['h'] = buffer.select_all,
    ['k'] = fn_dispatch['switchbuffer'],
    ['r'] = buffer.reload,
    ['ctrl+c'] = quit,
    ['ctrl+f'] = fn_dispatch['open'],
    ['ctrl+r'] = fn_dispatch['open_recent'],
    ['ctrl+s'] = buffer.save,
    ['ctrl+w'] = fn_dispatch['saveas'],
    ['ctrl+x'] = E.exchange_caret_and_mark,
  }

end

return M
