-- Legacy/simple terminal toggle implementation (single terminal buffer/window).
-- NOTE: Main terminal keymaps now use the custom terminal manager (`terminal-manager.lua`).

-- Stores the single terminal buffer and window handles for this simple toggle.
local terminal = { buf = nil, win = nil }

-- Toggle a basic bottom terminal split.
local function toggle()
  -- If the terminal window is already open, hide it and keep the buffer/job alive.
  if terminal.win and vim.api.nvim_win_is_valid(terminal.win) then
    vim.api.nvim_win_hide(terminal.win)
    terminal.win = nil
    return
  end

  -- Open a bottom split for the terminal.
  vim.cmd("botright 12split")
  terminal.win = vim.api.nvim_get_current_win()

  -- Reuse the existing terminal buffer if it is still valid; otherwise create a new one.
  if terminal.buf and vim.api.nvim_buf_is_valid(terminal.buf) then
    vim.api.nvim_win_set_buf(terminal.win, terminal.buf)
  else
    vim.cmd("terminal")
    terminal.buf = vim.api.nvim_get_current_buf()
    -- Hide terminal buffer from bufferline/listings.
    vim.bo[terminal.buf].buflisted = false
  end

  -- Enter terminal insert mode for immediate typing.
  vim.cmd("startinsert")
end

-- Return the toggle function (module can be required and called directly).
return toggle
