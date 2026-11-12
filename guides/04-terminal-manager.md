# Custom Terminal Manager (VS Code-like panel)

**Intro:** A custom terminal workflow (not toggleterm's native UI) with the **active terminal on the left** and a **terminal list on the right**. Supports multiple terminals.

## Keymaps
### Global
- `<C-/>`, `<C-_>`, or `<leader>tt` — toggle terminal panel (normal/terminal where mapped)
- `<C-S-\`>` (Ctrl+Shift+\`) — create a new terminal (works in normal and terminal mode)
- `<leader>tx` — close/remove the selected terminal

### Inside the terminal list sidebar
- `<CR>` — select/show that terminal in the left pane and move focus to it (enters terminal insert mode)
- `a` — create new terminal
- `x` — remove **only that terminal** from the list (closes that buffer/job), keeps the panel open
- `q` — hide panel (terminals keep running)
- `<S-j>` — next terminal
- `<S-k>` — previous terminal
- `<M-h>` (Alt+h) — move focus back to the active terminal pane

### Inside a managed terminal buffer
- `<S-j>` — next terminal
- `<S-k>` — previous terminal
- `<M-l>` (Alt+l) — move focus to the terminal list sidebar
- `<Esc><Esc>` — exit terminal mode to normal mode (global terminal mapping)

## Notes
- Typing `exit` (or otherwise ending the shell) removes that terminal from the list automatically.
- `x` / `<leader>tx` removes only the selected terminal entry (not the whole panel). If it was the last one, a fresh terminal is created so the panel stays usable.
- Hiding the panel (`q` or toggle) does not kill running terminal jobs.
- If you manually close panel windows, the manager tries to clean up its state on next actions.
- Config: `lua/config/terminal-manager.lua`, loaded via `lua/plugins/toggle-term.lua`.
