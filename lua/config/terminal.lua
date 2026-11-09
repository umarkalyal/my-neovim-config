local terminal = { buf = nil, win = nil }

local function toggle()
  if terminal.win and vim.api.nvim_win_is_valid(terminal.win) then
    vim.api.nvim_win_hide(terminal.win)
    terminal.win = nil
    return
  end

  vim.cmd("botright 12split")
  terminal.win = vim.api.nvim_get_current_win()
  if terminal.buf and vim.api.nvim_buf_is_valid(terminal.buf) then
    vim.api.nvim_win_set_buf(terminal.win, terminal.buf)
  else
    vim.cmd("terminal")
    terminal.buf = vim.api.nvim_get_current_buf()
    vim.bo[terminal.buf].buflisted = false
  end
  vim.cmd("startinsert")
end

return toggle