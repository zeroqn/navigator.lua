local M = {}
local ListView = require "guihua.listview"
local TextView = require "guihua.textview"
local util = require "navigator.util"
local log = require"navigator.util".log
local verbose = require"navigator.util".verbose
local api = vim.api

function M.new_preview(opts)
  return TextView:new({
    loc = "top_center",
    rect = {
<<<<<<< HEAD
      height = opts.height, -- opts.preview_heigh or 12, -- TODO 12
=======
      height = opts.preview_heigh or 12,
>>>>>>> 419f7d90e8639fee356c66e651b7279cab48ab3c
      width = opts.width or 100,
      pos_x = opts.pos_x or 0,
      pos_y = opts.pos_y or 4
    },
    -- data = display_data,
    relative = opts.relative,
<<<<<<< HEAD
    -- data = opts.items, -- either items or uri
    uri = opts.uri,
    syntax = opts.syntax,
    enter = opts.enter or false,
    range = opts.range,
    display_range = opts.display_range,
=======
    data = opts.items,
    syntax = opts.syntax,
    enter = opts.enter or false,
>>>>>>> 419f7d90e8639fee356c66e651b7279cab48ab3c
    hl_line = opts.hl_line
  })
end

function M._preview_location(opts) -- location, width, pos_x, pos_y
<<<<<<< HEAD
  local uri = opts.location.uri
=======
  local uri = opts.location.targetUri or opts.location.uri
>>>>>>> 419f7d90e8639fee356c66e651b7279cab48ab3c
  if opts.uri == nil then
    log("invalid/nil uri ")
    return
  end
  local bufnr = vim.uri_to_bufnr(uri)
  if not api.nvim_buf_is_loaded(bufnr) then vim.fn.bufload(bufnr) end
  --

<<<<<<< HEAD
  local display_range = opts.location.range
  -- if range.start == nil then
  --   print("error invalid range")
  --   return
  -- end
  -- if range.start.line == nil then
  --   range.start.line = range["end"].line - 1
  --   opts.lnum = range["end"].line + 1
  --   log(opts)
  -- end
  -- if range["end"].line == nil then
  --   range["end"].line = range.start.line + 1
  --   opts.lnum = range.start.line + 1
  --   log(opts)
  -- end
  -- TODO: preview height
  -- local contents = api.nvim_buf_get_lines(bufnr, range.start.line, range["end"].line, false)
  --
  local syntax = api.nvim_buf_get_option(bufnr, "ft")
  if syntax == nil or #syntax < 1 then syntax = "c" end

  -- verbose(syntax, contents)
  local win_opts = {
    syntax = syntax,
    width = opts.width,
    height = display_range['end'].line - display_range.start.line + 1,
    pos_x = opts.offset_x or 0,
    pos_y = opts.offset_y or 10,
    range = opts.range,
    display_range = display_range,
    uri = uri,
    allow_edit = true
  }
  -- win_opts.items = contents
  win_opts.hl_line = opts.lnum - display_range.start.line
  if win_opts.hl_line < 0 then win_opts.hl_line = 1 end
  verbose(opts.lnum, opts.range.start.line, win_opts.hl_line)
=======
  local range = opts.location.targetRange or opts.location.range
  if range.start == nil then
    print("error invalid range")
    return
  end
  if range.start.line == nil then
    range.start.line = range["end"].line - 1
    opts.lnum = range["end"].line + 1
    log(opts)
  end
  if range["end"].line == nil then
    range["end"].line = range.start.line + 1
    opts.lnum = range.start.line + 1
    log(opts)
  end
  local contents = api.nvim_buf_get_lines(bufnr, range.start.line, (range["end"].line or 1) + 10,
                                          false)
  --
  local syntax = api.nvim_buf_get_option(bufnr, "syntax")
  if syntax == nil or #syntax < 1 then syntax = api.nvim_buf_get_option(bufnr, "ft") end

  verbose(syntax, contents)
  local win_opts = {
    syntax = syntax,
    width = opts.width,
    pos_x = opts.offset_x or 0,
    pos_y = opts.offset_y or 10
  }
  win_opts.items = contents
  win_opts.hl_line = opts.lnum - range.start.line
  if win_opts.hl_line < 0 then win_opts.hl_line = 1 end
  verbose(opts.lnum, range.start.line, win_opts.hl_line)
>>>>>>> 419f7d90e8639fee356c66e651b7279cab48ab3c
  local w = M.new_preview(win_opts)

  return w
end

function M.preview_uri(opts) -- uri, width, line, col, offset_x, offset_y
  local line_beg = opts.lnum - 1
  if line_beg >= 2 then line_beg = line_beg - 2 end
<<<<<<< HEAD
  local loc = {uri = opts.uri, range = {start = {line = line_beg}}}

  -- TODO: preview height
  loc.range["end"] = {line = opts.lnum + 12}
=======
  local loc = {uri = opts.uri, targetRange = {start = {line = line_beg}}}
  -- TODO: options for 8
  loc.targetRange["end"] = {line = opts.lnum + 8}
>>>>>>> 419f7d90e8639fee356c66e651b7279cab48ab3c
  opts.location = loc

  log("uri", opts.uri, opts.lnum, opts.location)
  return M._preview_location(opts)
end

function M.new_list_view(opts)
  local config = require("navigator").config_values()

  local items = opts.items
  local data = {}
<<<<<<< HEAD

=======
  if opts.rawdata then
    data = items
  else
    data = require"guihua.util".aggregate_filename(items, opts)
  end
>>>>>>> 419f7d90e8639fee356c66e651b7279cab48ab3c
  local wwidth = api.nvim_get_option("columns")
  local width = math.min(opts.width or config.width or 120, math.floor(wwidth * 0.8))
  local wheight = config.height or math.floor(api.nvim_get_option("lines") * 0.8)
  local prompt = opts.prompt or false
  opts.width = width
  if opts.rawdata then
    data = items
  else
    data = require"guihua.util".prepare_for_render(items, opts)
  end

  if data and not vim.tbl_isempty(data) then
    -- replace
    -- TODO: 10 vimrc opt
    if #data > 10 and opts.prompt == nil then prompt = true end

    local height = math.min(#data, math.floor(wheight / 2))
<<<<<<< HEAD
    local offset_y = height + 2 -- style shadow took 2 lines
=======
    local offset_y = height + 1
>>>>>>> 419f7d90e8639fee356c66e651b7279cab48ab3c
    if prompt then offset_y = offset_y + 1 end
    return ListView:new({
      loc = "top_center",
      prompt = prompt,
      relative = opts.relative,
      style = opts.style,
      api = opts.api,
      rect = {height = height, width = width, pos_x = 0, pos_y = 0},
<<<<<<< HEAD
      ft = opts.ft or 'guihua',
=======
>>>>>>> 419f7d90e8639fee356c66e651b7279cab48ab3c
      -- data = display_data,
      data = data,
      on_confirm = opts.on_confirm or function(pos)
        if pos == 0 then pos = 1 end
        local l = data[pos]
        if l.filename ~= nil then
          verbose("openfile ", l.filename, l.lnum, l.col)
          util.open_file_at(l.filename, l.lnum, l.col)
        end
      end,
      on_move = opts.on_move or function(pos)
        if pos == 0 then pos = 1 end
        local l = data[pos]
<<<<<<< HEAD
        verbose("on move", pos, l)
=======
>>>>>>> 419f7d90e8639fee356c66e651b7279cab48ab3c
        verbose("on move", pos, l.text or l, l.uri, l.filename)
        -- todo fix
        if l.uri == nil then l.uri = "file:///" .. l.filename end
        return M.preview_uri({
          uri = l.uri,
          width = width,
          lnum = l.lnum,
          col = l.col,
<<<<<<< HEAD
          range = l.range,
          offset_x = 0,
          offset_y = offset_y,
          border = "double"
=======
          offset_x = 0,
          offset_y = offset_y
>>>>>>> 419f7d90e8639fee356c66e651b7279cab48ab3c
        })
      end
    })
  end
end

return M

-- Doc

--[[
    -- each item should look like this
    -- update if API changes
    {
      call_by = { <table 1> },
      col = 40,
      display_filename = "./curry.js",
      filename = "/Users/ray.xu/lsp_test/js/curry.js",
      lnum = 4,
      range = {
        end = {
          character = 46,
          line = 3  -- note: C index
        },
        start = {
          character = 39,
          line = 3
        }
      },
      rpath = "js/curry.js",
      text = "      (sum, element, index) => (sum += element * vector2[index]),",
      uri = "file:///Users/ray.xu/lsp_test/js/curry.js"
    }
  --]]

-- on move item:
--[[

 call_by = { {
      kind = " ",
      node_scope = {
        end = {
          character = 1,
          line = 7
        },
        start = {
          character = 0,
          line = 0
        }
      },
      node_text = "curriedDot",
      type = "var"
    } },
  col = 22,
  display_filename = "./curry.js",
  filename = "/Users/ray.xu/lsp_test/js/curry.js",
  lnum = 4,
  range = {
    end = {
      character = 26,
      line = 3
    },
    start = {
      character = 21,
      line = 3
    }
  },
  rpath = "js/curry.js",
  text = "    4:        (sum, element, index) => (sum += element * vector     curriedDot()",
  uri = "file:///Users/ray.xu/lsp_test/js/curry.js"
--
]]
