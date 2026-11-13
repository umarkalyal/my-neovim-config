
local M = {}

local state = {
  terminals = {},
  current = 1,
  next_id = 1,
  open = false,

  origin_win = nil,
  term_win = nil,
  list_win = nil,
  list_buf = nil,
}

local api = vim.api

-- Utility functions
local function valid_win(win)
  return win ~= nil and api.nvim_win_is_valid(win)
end

local function valid_buf(buf)
  return buf ~= nil and api.nvim_buf_is_valid(buf)
end

local function selected()
  return state.terminals[state.current]
end

local function focus_sidebar()
  if valid_win(state.list_win) then
    api.nvim_set_current_win(state.list_win)
  end
end

local function focus_terminal(insert)
  if valid_win(state.term_win) then
    api.nvim_set_current_win(state.term_win)
    if insert ~= false then
      vim.cmd("startinsert")
    end
  end
end

M.focus_sidebar = focus_sidebar
M.focus_terminal = focus_terminal

-- Refresh terminal sidebar
local function refresh()
  if not valid_buf(state.list_buf) then
    return
  end

  local lines = {}

  for i, term in ipairs(state.terminals) do
    local marker = i == state.current and "● " or "  "
    local status = vim.fn.jobwait({ term.job }, 0)[1]

    local suffix = status == -1 and "" or " [exited]"

    lines[#lines + 1] = marker .. term.name .. suffix
  end

  if #lines == 0 then
    lines = { "  No terminals" }
  end

  api.nvim_set_option_value("modifiable", true, {
    buf = state.list_buf,
  })

  api.nvim_buf_set_lines(
    state.list_buf,
    0,
    -1,
    false,
    lines
  )

  api.nvim_set_option_value("modifiable", false, {
    buf = state.list_buf,
  })

  if valid_win(state.list_win) then
    api.nvim_win_set_cursor(state.list_win, {
      math.max(1, state.current),
      0,
    })
  end
end

-- Terminal navigation keymaps
local function setup_terminal_maps(buf)
  local opts = {
    buffer = buf,
    silent = true,
  }

  vim.keymap.set(
    "t",
    "<S-j>",
    [[<C-\><C-n><Cmd>lua require("config.terminal-manager").next()<CR>]],
    opts
  )

  vim.keymap.set(
    "t",
    "<S-k>",
    [[<C-\><C-n><Cmd>lua require("config.terminal-manager").previous()<CR>]],
    opts
  )

  vim.keymap.set("n", "<S-j>", M.next, opts)
  vim.keymap.set("n", "<S-k>", M.previous, opts)

  -- Focus terminal list sidebar
  vim.keymap.set("n", "<M-l>", focus_sidebar, vim.tbl_extend("force", opts, { desc = "Focus terminal list" }))
  vim.keymap.set("t", "<M-l>", [[<C-\><C-n><Cmd>lua require("config.terminal-manager").focus_sidebar()<CR>]], vim.tbl_extend("force", opts, { desc = "Focus terminal list" }))
end

-- Create a new independent terminal
function M.new_terminal()
  local id = state.next_id
  state.next_id = id + 1

  local buf = api.nvim_create_buf(false, true)

  api.nvim_set_option_value("bufhidden", "hide", {
    buf = buf,
  })

  api.nvim_set_option_value("swapfile", false, {
    buf = buf,
  })

  local job

  api.nvim_buf_call(buf, function()
    job = vim.fn.termopen(vim.o.shell)
  end)

  setup_terminal_maps(buf)

  local term = {
    id = id,
    buf = buf,
    job = job,
    name = vim.fn.fnamemodify(vim.o.shell, ":t") .. " " .. id,
  }

  table.insert(state.terminals, term)
  state.current = #state.terminals

  refresh()

  if state.open then
    M.select(state.current)
  end
end

-- Select terminal by index
function M.select(index, opts)
  opts = opts or {}
  if #state.terminals == 0 then
    return
  end

  index = ((index - 1) % #state.terminals) + 1
  state.current = index

  local term = selected()

  if valid_win(state.term_win) and valid_buf(term.buf) then
    api.nvim_win_set_buf(state.term_win, term.buf)
  end

  refresh()

  if opts.focus == false then
    return
  end

  focus_terminal(opts.insert ~= false)
end

-- Next terminal
function M.next()
  if state.open then
    M.select(state.current + 1)
  end
end

-- Previous terminal
function M.previous()
  if state.open then
    M.select(state.current - 1)
  end
end

-- Remove a terminal entry by index without closing the whole panel
local function remove_terminal_at(index, opts)
  opts = opts or {}
  local term = state.terminals[index]
  if not term then
    return
  end

  local was_current = index == state.current
  local removing_buf = term.buf

  if opts.stop_job ~= false then
    local status = vim.fn.jobwait({ term.job }, 0)[1]
    if status == -1 then
      pcall(vim.fn.jobstop, term.job)
    end
  end

  table.remove(state.terminals, index)

  if #state.terminals == 0 then
    state.current = 1
    if valid_buf(removing_buf) then
      pcall(api.nvim_buf_delete, removing_buf, { force = true })
    end
    -- Keep panel usable with a fresh terminal
    M.new_terminal()
    return
  end

  if state.current > index then
    state.current = state.current - 1
  elseif state.current > #state.terminals then
    state.current = #state.terminals
  end
  state.current = math.max(1, state.current)

  -- If the removed terminal is currently shown, switch window first so panel stays open
  if state.open and valid_win(state.term_win) and valid_buf(removing_buf) then
    local ok, current_buf = pcall(api.nvim_win_get_buf, state.term_win)
    if ok and current_buf == removing_buf then
      local next_term = selected()
      if next_term and valid_buf(next_term.buf) then
        pcall(api.nvim_win_set_buf, state.term_win, next_term.buf)
      end
    end
  end

  if valid_buf(removing_buf) then
    pcall(api.nvim_buf_delete, removing_buf, { force = true })
  end

  if state.open then
    if opts.focus_list then
      M.select(state.current, { focus = false })
      focus_sidebar()
    elseif was_current or opts.focus_terminal then
      M.select(state.current)
    else
      refresh()
    end
  else
    refresh()
  end
end

-- Close selected terminal
function M.close_terminal(opts)
  opts = opts or {}
  if #state.terminals == 0 then
    return
  end
  remove_terminal_at(state.current, {
    stop_job = true,
    focus_list = opts.focus_list,
    focus_terminal = opts.focus_terminal,
  })
end

-- Remove terminal by buffer (used when shell exits naturally)
local function remove_terminal_by_buf(buf)
  for i, term in ipairs(state.terminals) do
    if term.buf == buf then
      remove_terminal_at(i, { stop_job = false })
      return
    end
  end
  refresh()
end

-- Reset internal UI state if the panel was partially closed externally
local function reset_panel_state()
  state.open = false
  state.list_win = nil
  state.term_win = nil
  state.list_buf = nil
  state.origin_win = nil
end

-- Open terminal panel
function M.open()
  if state.open and valid_win(state.term_win) and valid_win(state.list_win) then
    M.select(state.current)
    return
  end

  if state.open then
    reset_panel_state()
  end

  if #state.terminals == 0 then
    M.new_terminal()
  end

  state.origin_win = api.nvim_get_current_win()

  -- Create bottom terminal area
  vim.cmd("botright 15split")

  state.term_win = api.nvim_get_current_win()
  vim.wo[state.term_win].winfixheight = true

  -- Use a temporary unlisted scratch buffer until the real terminal buffer is shown
  local scratch = api.nvim_create_buf(false, true)
  api.nvim_win_set_buf(state.term_win, scratch)

  -- Create right-side terminal list inside the bottom area
  vim.cmd("rightbelow 26vsplit")

  state.list_win = api.nvim_get_current_win()

  state.list_buf = api.nvim_create_buf(false, true)

  api.nvim_win_set_buf(state.list_win, state.list_buf)

  -- Sidebar buffer settings
  api.nvim_set_option_value("buftype", "nofile", { buf = state.list_buf })
  api.nvim_set_option_value("bufhidden", "wipe", { buf = state.list_buf })
  api.nvim_set_option_value("swapfile", false, { buf = state.list_buf })
  api.nvim_set_option_value("modifiable", false, { buf = state.list_buf })
  api.nvim_set_option_value("filetype", "terminal-list", { buf = state.list_buf })

  -- Sidebar window settings
  vim.wo[state.list_win].number = false
  vim.wo[state.list_win].relativenumber = false
  vim.wo[state.list_win].signcolumn = "no"
  vim.wo[state.list_win].winfixwidth = true
  vim.wo[state.list_win].cursorline = true
  api.nvim_win_set_width(state.list_win, 26)

  state.open = true

  -- Sidebar keymaps
  local opts = {
    buffer = state.list_buf,
    silent = true,
    nowait = true,
  }

  -- Select terminal using Enter (shows terminal and moves focus to it)
  vim.keymap.set("n", "<CR>", function()
    local row = api.nvim_win_get_cursor(0)[1]
    M.select(row)
  end, opts)

  -- Add terminal
  vim.keymap.set("n", "a", M.new_terminal, opts)

  -- Close selected terminal (removes only that terminal, keeps panel open)
  vim.keymap.set("n", "x", function()
    M.close_terminal({ focus_list = true })
  end, opts)

  -- Hide panel
  vim.keymap.set("n", "q", M.close, opts)

  -- Navigate terminals
  vim.keymap.set("n", "<S-j>", M.next, opts)
  vim.keymap.set("n", "<S-k>", M.previous, opts)

  -- Focus active terminal pane
  vim.keymap.set("n", "<M-h>", function()
    focus_terminal(false)
  end, opts)

  refresh()
  M.select(state.current)
end

-- Hide panel without killing terminal processes
function M.close()
  if not state.open and not valid_win(state.list_win) and not valid_win(state.term_win) then
    reset_panel_state()
    return
  end

  state.open = false

  local origin = state.origin_win
  local list_win = state.list_win
  local term_win = state.term_win

  if valid_win(list_win) then
    pcall(api.nvim_win_close, list_win, true)
  end

  if valid_win(term_win) then
    pcall(api.nvim_win_close, term_win, true)
  end

  state.list_win = nil
  state.term_win = nil
  state.list_buf = nil

  if valid_win(origin) then
    pcall(api.nvim_set_current_win, origin)
  end

  state.origin_win = nil
end

-- Toggle terminal panel
function M.toggle()
  if state.open then
    M.close()
  else
    M.open()
  end
end

-- Initialize keymaps and autocmds
function M.setup()
  -- Ctrl + /
  vim.keymap.set(
    { "n", "t" },
    "<C-_>",
    M.toggle,
    {
      desc = "Toggle terminal panel",
      silent = true,
    }
  )

  -- New terminal (Ctrl+Shift+`)
  vim.keymap.set(
    { "n", "t" },
    "<C-S-`>",
    function()
      M.new_terminal()
    end,
    {
      desc = "New terminal",
      silent = true,
    }
  )

  -- Close terminal
  vim.keymap.set(
    "n",
    "<leader>tx",
    M.close_terminal,
    {
      desc = "Close selected terminal",
      silent = true,
    }
  )

  -- Refresh sidebar when terminal exits and keep panel state consistent
  local group = api.nvim_create_augroup(
    "TerminalManager",
    { clear = true }
  )

  api.nvim_create_autocmd("TermClose", {
    group = group,
    callback = function(args)
      vim.schedule(function()
        remove_terminal_by_buf(args.buf)
      end)
    end,
  })

  api.nvim_create_autocmd("WinClosed", {
    group = group,
    callback = function(args)
      local closed = tonumber(args.match)
      if not state.open then
        return
      end
      if closed == state.term_win or closed == state.list_win then
        vim.schedule(function()
          if state.open then
            M.close()
          end
        end)
      end
    end,
  })
end

return M

