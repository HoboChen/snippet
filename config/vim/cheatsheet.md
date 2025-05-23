# Vim Jump & Git Cheatsheet   (assumes `let mapleader=","`)

| Goal | Keys | Command / Mapping | Comes from |
|------|------|------------------|------------|
| **FILES & BUFFERS** ||||
| Fuzzy‑find file in repo | ,f | `:Files` | fzf.vim |
| Fuzzy‑find open buffer | ,b | `:Buffers` | fzf.vim |
| Live grep (ripgrep needed) | ,g | `:Rg` | fzf.vim |
| Auto‑cd to repo root on open |  | (runs silently) | vim‑rooter |
| **CODE NAVIGATION** ||||
| Go to *definition* | gd | built‑in mapping → `CocAction('jumpDefinition')` | coc.nvim |
| Go to *declaration* | gD | same, declaration | coc.nvim |
| List *references* | gr | `:CocReferences` | coc.nvim |
| Return from jump | <C‑o> | built‑in | – |
| **GIT WORK** ||||
| Git status window | ,gs | `:Gstatus` | fugitive |
| Stage / unstage in status | - | `-` (diff‑style) | fugitive |
| Commit | ,gc | `:Gcommit` | fugitive |
| Blame current file | ,gb | `:Gblame` (opens split) | fugitive |
| Diff vs HEAD (3‑way) | ,gd | `:Gdiffsplit` | fugitive |
| **GIT CHANGES IN BUFFER** ||||
| Next / previous hunk | ]c  /  [c | jump to change | gitgutter |
| Stage hunk | ,hs | `:GitGutterStageHunk` | gitgutter |
| Undo staged hunk | ,hu | `:GitGutterUndoHunk` | gitgutter |
| Preview hunk inline | ,hp | `:GitGutterPreviewHunk` | gitgutter |
| **MICRO‑MOVEMENT (optional)** ||||
| Two‑char sneak forward | s{c}{c} | example: `sab` | vim‑sneak |
| Hop to word | ,w | `:HopWord` | hop.nvim |

> Tip: keep this file in `~/.vim/cheatsheets/jump.md` and open it with `:tabedit %` whenever you forget a key.
