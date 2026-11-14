-- Custom terminal manager module.
-- Provides a VS Code-like terminal panel: active terminal on the left, terminal list on the right.
-- Supports multiple terminals, switching, create/remove, focus navigation, and panel toggle.

local M = {}

-- -----------------------------------------------------------------------------
-- Module state (in-memory, local to this module)
-- -----------------------------------------------------------------------------
local state = {
  terminals = {},  -- Managed terminal entries: { id, buf, job, name }
  current = 1,     -- Index of the currently selected terminal in `terminals`
  next_id = 1,     -- Incrementing ID used for terminal naming
  open = false,    -- Whether the panel UI is currently open

  origin_win = nil, -- Window that was active before opening the panel (to restore focus on close)
  term_win = nil,   -- Window showing the active terminal buffer (left side)
  list_win = nil,   -- Window showing the terminal list sidebar (right side)
  list_buf = nil,   -- Scratch buffer used to render the terminal list
}

local api = vim.api

-- -----------------------------------------------------------------------------
-- Utility helpers
-- -----------------------------------------------------------------------------

-- Check whether a window handle is still valid.
local function valid_win(win)
  return win ~= nil and api.nvim_win_is_valid(win)
end

-- Check whether a buffer handle is still valid.
local function valid_buf(buf)
  return buf ~= nil and api.nvim_buf_is_valid(buf)
end

-- Return the currently selected terminal entry (or nil if none).
local function selected()
  return state.terminals[state.current]
end

-- Focus the terminal list sidebar window (if open).
local function focus_sidebar()
  if valid_win(state.list_win) then
    api.nvim_set_current_win(state.list_win)
  end
end

-- Focus the active terminal window (if open), optionally entering insert mode.
local function focus_terminal(insert)
  if valid_win(state.term_win) then
    api.nvim_set_current_win(state.term_win)
    if insert ~= false then
      vim.cmd("startinsert")
    end
  end
end

-- Expose focus helpers for keymaps that call via `require(...).focus_sidebar()`.
M.focus_sidebar = focus_sidebar
M.focus_terminal = focus_terminal

-- -----------------------------------------------------------------------------
-- Sidebar rendering
-- -----------------------------------------------------------------------------

-- Refresh the terminal list sidebar contents and cursor position.
local function refresh()
  -- Nothing to render if the sidebar buffer is gone.
  if not valid_buf(state.list_buf) then
    return
  end

  local lines = {}

  -- Render each managed terminal as a line with selection marker and status.
  for i, term in ipairs(state.terminals) do
    local marker = i == state.current and "● " or "  "
    local status = vim.fn.jobwait({ term.job }, 0)[1]
    local suffix = status == -1 and "" or " [exited]" -- -1 means job still running
    lines[#lines + 1] = marker .. term.name .. suffix
  end

  -- Fallback text when there are no terminals (defensive; manager usually keeps one).
  if #lines == 0 then
    lines = { "  No terminals" }
  end

  -- Temporarily make the scratch buffer modifiable to update its lines.
  api.nvim_set_option_value("modifiable", true, { buf = state.list_buf })
  api.nvim_buf_set_lines(state.list_buf, 0, -1, false, lines)
  api.nvim_set_option_value("modifiable", false, { buf = state.list_buf })

  -- Keep sidebar cursor aligned with the currently selected terminal.
  if valid_win(state.list_win) then
    api.nvim_win_set_cursor(state.list_win, {
      math.max(1, state.current),
      0,
    })
  end
end

-- -----------------------------------------------------------------------------
-- Per-terminal buffer keymaps (navigation and focus)
-- -----------------------------------------------------------------------------

-- Set keymaps on a managed terminal buffer for switching terminals and focusing the sidebar.
local function setup_terminal_maps(buf)
  local opts = {
    buffer = buf,
    silent = true,
  }

  -- Next terminal (terminal mode): leave terminal mode, then switch.
  vim.keymap.set(
    "t",
    "<S-j>",
    [[<C-\><C-n><Cmd>lua require("config.terminal-manager").next()<CR>]],
    opts
  )

  -- Previous terminal (terminal mode): leave terminal mode, then switch.
  vim.keymap.set(
    "t",
    "<S-k>",
    [[<C-\><C-n><Cmd>lua require("config.terminal-manager").previous()<CR>]],
    opts
  )

  -- Next/previous terminal in normal mode (e.g. after <Esc><Esc> in terminal buffer).
  vim.keymap.set("n", "<S-j>", M.next, opts)
  vim.keymap.set("n", "<S-k>", M.previous, opts)

  -- Focus the terminal list sidebar from the active terminal buffer.
  vim.keymap.set("n", "<M-l>", focus_sidebar, vim.tbl_extend("force", opts, { desc = "Focus terminal list" }))
  vim.keymap.set(
    "t",
    "<M-l>",
    [[<C-\><C-n><Cmd>lua require("config.terminal-manager").focus_sidebar()<CR>]],
    vim.tbl_extend("force", opts, { desc = "Focus terminal list" })
  )
end

-- -----------------------------------------------------------------------------
-- Terminal lifecycle: create/select/navigate/remove
-- -----------------------------------------------------------------------------

-- Create a new terminal job/buffer, register it, and show it if the panel is open.
function M.new_terminal()
  -- Allocate a unique ID for display/name purposes.
  local id = state.next_id
  state.next_id = id + 1

  -- Create an unlisted scratch buffer to host the terminal.
  local buf = api.nvim_create_buf(false, true)

  -- Hide (do not wipe) terminal buffer when not displayed so the job can keep running.
  api.nvim_set_option_value("bufhidden", "hide", { buf = buf })
  api.nvim_set_option_value("swapfile", false, { buf = buf })

  -- Start the user's shell in the new buffer.
  local job
  api.nvim_buf_call(buf, function()
    job = vim.fn.termopen(vim.o.shell)
  end)

  -- Attach terminal-local navigation/focus keymaps.
  setup_terminal_maps(buf)

  -- Track the terminal in module state.
  local term = {
    id = id,
    buf = buf,
    job = job,
    name = vim.fn.fnamemodify(vim.o.shell, ":t") .. " " .. id,
  }

  table.insert(state.terminals, term)
  state.current = #state.terminals

  -- Update sidebar and focus/show the new terminal when panel is open.
  refresh()

  if state.open then
    M.select(state.current)
  end
end

-- Select and display a terminal by index (wraps around). Can optionally avoid focusing/insert.
function M.select(index, opts)
  opts = opts or {}
  if #state.terminals == 0 then
    return
  end

  -- Wrap index into valid range (1-based, circular navigation).
  index = ((index - 1) % #state.terminals) + 1
  state.current = index

  local term = selected()

  -- Show the selected terminal buffer in the panel's terminal window.
  if valid_win(state.term_win) and valid_buf(term.buf) then
    api.nvim_win_set_buf(state.term_win, term.buf)
  end

  -- Refresh sidebar marker/cursor after selection changes.
  refresh()

  -- Allow callers (e.g. sidebar actions) to update selection without stealing focus.
  if opts.focus == false then
    return
  end

  -- Focus the terminal pane and enter insert mode by default.
  focus_terminal(opts.insert ~= false)
end

-- Switch to the next terminal in the list (only when panel is open).
function M.next()
  if state.open then
    M.select(state.current + 1)
  end
end

-- Switch to the previous terminal in the list (only when panel is open).
function M.previous()
  if state.open then
    M.select(state.current - 1)
  end
end

-- Remove a terminal entry by index without closing the whole panel.
-- Handles job stopping (optional), buffer deletion, selection adjustment, and focus behavior.
local function remove_terminal_at(index, opts)
  opts = opts or {}
  local term = state.terminals[index]
  if not term then
    return
  end

  local was_current = index == state.current
  local removing_buf = term.buf

  -- Stop the job if requested and it is still running.
  if opts.stop_job ~= false then
    local status = vim.fn.jobwait({ term.job }, 0)[1]
    if status == -1 then
      pcall(vim.fn.jobstop, term.job)
    end
  end

  -- Remove the terminal entry from state first.
  table.remove(state.terminals, index)

  -- If no terminals remain, optionally create a fresh one (but not during Neovim exit).
  if #state.terminals == 0 then
    state.current = 1
    if valid_buf(removing_buf) then
      pcall(api.nvim_buf_delete, removing_buf, { force = true })
    end
    -- Keep panel usable with a fresh terminal, but not while Neovim is exiting.
    if not vim.v.exiting or vim.v.exiting == vim.NIL then
      M.new_terminal()
    end
    return
  end

  -- Adjust current selection index after removal.
  if state.current > index then
    state.current = state.current - 1
  elseif state.current > #state.terminals then
    state.current = #state.terminals
  end
  state.current = math.max(1, state.current)

  -- If the removed terminal is currently displayed, swap in another buffer first to keep the window/panel alive.
  if state.open and valid_win(state.term_win) and valid_buf(removing_buf) then
    local ok, current_buf = pcall(api.nvim_win_get_buf, state.term_win)
    if ok and current_buf == removing_buf then
      local next_term = selected()
      if next_term and valid_buf(next_term.buf) then
        pcall(api.nvim_win_set_buf, state.term_win, next_term.buf)
      end
    end
  end

  -- Delete the removed terminal buffer.
  if valid_buf(removing_buf) then
    pcall(api.nvim_buf_delete, removing_buf, { force = true })
  end

  -- Refresh UI and restore/focus according to caller intent.
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

-- Close/remove the currently selected terminal (public action used by keymaps).
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

-- Remove a terminal by buffer handle (used when a shell exits naturally via TermClose).
local function remove_terminal_by_buf(buf)
  for i, term in ipairs(state.terminals) do
    if term.buf == buf then
      remove_terminal_at(i, { stop_job = false })
      return
    end
  end
  refresh()
end

-- Sync state if a managed terminal buffer is wiped/deleted externally.
local function remove_terminal_by_buf_if_managed(buf)
  for i, term in ipairs(state.terminals) do
    if term.buf == buf then
      -- Reuse removal logic to keep selection/state consistent.
      remove_terminal_at(i, { stop_job = false })
      return
    end
  end
end

-- -----------------------------------------------------------------------------
-- Panel UI state/open/close/toggle
-- -----------------------------------------------------------------------------

-- Reset internal window/buffer UI references after the panel is closed or becomes invalid.
local function reset_panel_state()
  state.open = false
  state.list_win = nil
  state.term_win = nil
  state.list_buf = nil
  state.origin_win = nil
end

-- Open the terminal panel UI (bottom split with terminal left and list right).
function M.open()
  -- If panel is already valid/open, just re-select/focus the current terminal.
  if state.open and valid_win(state.term_win) and valid_win(state.list_win) then
    M.select(state.current)
    return
  end

  -- If state says open but windows are invalid, reset before reopening.
  if state.open then
    reset_panel_state()
  end

  -- Ensure there is at least one terminal to display.
  if #state.terminals == 0 then
    M.new_terminal()
  end

  -- Remember the currently focused window so we can restore it on close.
  state.origin_win = api.nvim_get_current_win()

  -- Create the bottom panel area for the terminal pane.
  vim.cmd("botright 15split")

  state.term_win = api.nvim_get_current_win()
  vim.wo[state.term_win].winfixheight = true

  -- Use a temporary unlisted scratch buffer until the real terminal buffer is shown.
  -- (bufhidden=wipe prevents leftover hidden scratch buffers.)
  local scratch = api.nvim_create_buf(false, true)
  api.nvim_set_option_value("bufhidden", "wipe", { buf = scratch })
  api.nvim_set_option_value("swapfile", false, { buf = scratch })
  api.nvim_win_set_buf(state.term_win, scratch)

  -- Create the right-side terminal list split inside the bottom panel.
  vim.cmd("rightbelow 26vsplit")

  state.list_win = api.nvim_get_current_win()

  -- Create and attach a scratch buffer for the sidebar list UI.
  state.list_buf = api.nvim_create_buf(false, true)
  api.nvim_win_set_buf(state.list_win, state.list_buf)

  -- Configure sidebar buffer behavior/appearance metadata.
  api.nvim_set_option_value("buftype", "nofile", { buf = state.list_buf })
  api.nvim_set_option_value("bufhidden", "wipe", { buf = state.list_buf })
  api.nvim_set_option_value("swapfile", false, { buf = state.list_buf })
  api.nvim_set_option_value("modifiable", false, { buf = state.list_buf })
  api.nvim_set_option_value("filetype", "terminal-list", { buf = state.list_buf })

  -- Configure sidebar window appearance/layout.
  vim.wo[state.list_win].number = false
  vim.wo[state.list_win].relativenumber = false
  vim.wo[state.list_win].signcolumn = "no"
  vim.wo[state.list_win].winfixwidth = true
  vim.wo[state.list_win].cursorline = true
  api.nvim_win_set_width(state.list_win, 26)

  state.open = true

  -- Buffer-local keymaps for the sidebar list.
  local opts = {
    buffer = state.list_buf,
    silent = true,
    nowait = true,
  }

  -- Select/show the terminal under cursor and move focus to the terminal pane.
  vim.keymap.set("n", "<CR>", function()
    local row = api.nvim_win_get_cursor(0)[1]
    M.select(row)
  end, opts)

  -- Create a new terminal from the sidebar.
  vim.keymap.set("n", "a", M.new_terminal, opts)

  -- Remove only the selected terminal (keep panel open, keep focus in sidebar).
  vim.keymap.set("n", "x", function()
    M.close_terminal({ focus_list = true })
  end, opts)

  -- Hide/close the panel UI without killing running terminal jobs.
  vim.keymap.set("n", "q", M.close, opts)

  -- Navigate terminals while focused in the sidebar.
  vim.keymap.set("n", "<S-j>", M.next, opts)
  vim.keymap.set("n", "<S-k>", M.previous, opts)

  -- Move focus back to the active terminal pane.
  vim.keymap.set("n", "<M-h>", function()
    focus_terminal(false)
  end, opts)

  -- Render list and display/select the current terminal.
  refresh()
  M.select(state.current)
end

-- Hide/close the panel UI without stopping terminal jobs or deleting terminal buffers.
function M.close()
  -- If already closed/invalid, normalize state and exit.
  if not state.open and not valid_win(state.list_win) and not valid_win(state.term_win) then
    reset_panel_state()
    return
  end

  state.open = false

  -- Capture handles before clearing state.
  local origin = state.origin_win
  local list_win = state.list_win
  local term_win = state.term_win

  -- Close panel windows if they still exist.
  if valid_win(list_win) then
    pcall(api.nvim_win_close, list_win, true)
  end

  if valid_win(term_win) then
    pcall(api.nvim_win_close, term_win, true)
  end

  -- Clear UI references (terminal jobs/buffers remain managed in state.terminals).
  state.list_win = nil
  state.term_win = nil
  state.list_buf = nil

  -- Restore focus to the window that was active before opening the panel.
  if valid_win(origin) then
    pcall(api.nvim_set_current_win, origin)
  end

  state.origin_win = nil
end

-- Toggle panel visibility.
function M.toggle()
  if state.open then
    M.close()
  else
    M.open()
  end
end

-- -----------------------------------------------------------------------------
-- Global setup: keymaps and autocmds
-- -----------------------------------------------------------------------------

-- Initialize global keymaps and autocmds for terminal manager behavior.
function M.setup()
  -- Global toggle mapping (Ctrl+/; often sent as <C-_> in terminals).
  vim.keymap.set(
    { "n", "t" },
    "<C-_>",
    M.toggle,
    {
      desc = "Toggle terminal panel",
      silent = true,
    }
  )

  -- Global mapping to create a new terminal (Ctrl+Shift+` in normal/terminal mode).
  -- Note: actual key recognition depends on terminal emulator/key encoding support.
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

  -- Global mapping to close/remove the currently selected terminal.
  vim.keymap.set(
    "n",
    "<leader>tx",
    M.close_terminal,
    {
      desc = "Close selected terminal",
      silent = true,
    }
  )

  -- Autocommand group for terminal-manager events (cleared on re-setup).
  local group = api.nvim_create_augroup("TerminalManager", { clear = true })

  -- When a terminal job exits naturally, remove that terminal from the managed list.
  api.nvim_create_autocmd("TermClose", {
    group = group,
    callback = function(args)
      vim.schedule(function()
        remove_terminal_by_buf(args.buf)
      end)
    end,
  })

  -- If a managed terminal buffer is deleted/wiped externally, sync internal state.
  api.nvim_create_autocmd({ "BufWipeout", "BufDelete" }, {
    group = group,
    callback = function(args)
      vim.schedule(function()
        remove_terminal_by_buf_if_managed(args.buf)
      end)
    end,
  })

  -- If the panel windows are closed manually, close/reset panel state cleanly.
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

  -- On Neovim exit, stop and delete managed terminal jobs/buffers to avoid E948.
  api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      for _, term in ipairs(state.terminals) do
        -- Stop running jobs before exit.
        if term.job then
          local status = vim.fn.jobwait({ term.job }, 0)[1]
          if status == -1 then
            pcall(vim.fn.jobstop, term.job)
          end
        end

        -- Delete managed terminal buffers.
        if valid_buf(term.buf) then
          pcall(api.nvim_buf_delete, term.buf, { force = true })
        end
      end

      -- Reset managed terminal list/state.
      state.terminals = {}
      state.current = 1
    end,
  })
end

-- Export module API.
return M
