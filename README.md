# dot_files: a personal terminal workbench

This is not a turnkey dotfiles distribution. It records one developer's working system: Bash entry points, Vim workflows, and small command-line tools that reduce the cost of recurring development, operations, and data tasks. Copy patterns selectively; several paths and aliases intentionally reflect the author's WSL machine and daily projects.

Korean version: [README_kor.md](README_kor.md)

## Productivity model

The system keeps recurring work close to the terminal: enable a tool's configuration only when that command exists, preserve solved transformations as scripts, and keep editor, script, input, and output in one loop. `awk`, `jq`, and `curl` are the core trio: line/table text, structured JSON, and HTTP input. The premise is that recurring file and stdout shapes are often stable, so a minimal transformation for that shape is more useful than a generic platform.

| Source | Intended location | Purpose |
| --- | --- | --- |
| [`dot_config/bash`](https://github.com/widehyo1/dot_files/tree/main/dot_config/bash) | `~/.config/bash` | layered Bash configuration |
| [`dot_cli/bin`](https://github.com/widehyo1/dot_files/tree/main/dot_cli/bin) | `~/.cli/bin` | personal commands to expose on `PATH` |
| [`dot_cli/awk`](https://github.com/widehyo1/dot_files/tree/main/dot_cli/awk) | `~/.cli/awk` | text/CSV/log transformations |
| [`dot_cli/jq`](https://github.com/widehyo1/dot_files/tree/main/dot_cli/jq) | `~/.cli/jq` | JSON/OpenAPI/HAR transformations |
| [`dot_cli/curl`](https://github.com/widehyo1/dot_files/tree/main/dot_cli/curl) | `~/.cli/curl` | HTTP request configurations |
| [`dot_vim`](https://github.com/widehyo1/dot_files/tree/main/dot_vim) | `~/.vim` | Vim-native UI and workflow |

The install scripts currently deploy Vim, Bash, and `dot_cli`, not every file in this repository. Inspect [`install.sh`](https://github.com/widehyo1/dot_files/blob/main/install.sh) and [`install_with_stow.sh`](https://github.com/widehyo1/dot_files/blob/main/install_with_stow.sh) before use.

## Vim as a working interface

### Built-in popup UX

Vim 8.1 popup windows implement buffer menus, file/content search, command output, jumplist, and changelist views without needing a separate plugin for each UI. A custom filter preserves Vim navigation: `j`/`k`, `gg`/`G`, page movement, yank, Enter, and `q`.

- [`popup.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/utils/popup.vim), [`popup_filter.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/utils/popup_filter.vim)
- [`buffer.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/utils/buffer.vim), [`custom/keymaps.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/custom/keymaps.vim#L1-L46)

This is not a claim that the entire configuration is plugin-free; it describes these particular UI workflows.

### Script + input + result loop

The practical unit is: **edit a transformation script → edit representative input → run it → insert or copy the result → refine**. Mappings open and run `~/script.awk` with `~/temp.txt`, and `~/script.jq` with `~/temp.json`; curl uses a request configuration and body in the same style.

- [`keymaps.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/keymaps.vim#L66-L108)
- [`jq.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/cli/jq.vim), [`curl.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/cli/curl.vim)

The convention matters more than a fixed tool list. Add gnuplot, SQL, Python, or another utility when it fits your own workflow.

### Vim–terminal PWD bridge

The shell reports its directory on prompt changes. Vim records the terminal directory; terminal-buffer `<leader>cd` applies it to Vim, while one terminal-open mode sends Vim's current directory to the shell. This reduces context loss when moving between a buffer and the embedded terminal.

- [Bash signal emitter](https://github.com/widehyo1/dot_files/blob/main/dot_config/bash/cli/vimrc)
- [Vim terminal implementation](https://github.com/widehyo1/dot_files/blob/main/dot_vim/utils/terminal.vim) and [terminal mappings](https://github.com/widehyo1/dot_files/blob/main/dot_vim/autocmd/terminal.vim)
- Detailed protocol and `:help` references: [Vim–terminal PWD bridge](docs/vim-terminal-pwd.md)

In normal buffers, `<leader>cd` moves to the current file directory and `<leader>up` to its parent: [`keymaps.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/keymaps.vim#L110-L114). `<Space><Space><Space>` cycles terminal-open strategies; `<C-d>` opens a terminal, reuses the only terminal, or shows a popup selector when several terminal buffers exist. Inside a terminal buffer it returns to the previous buffer. Markdown `<Space>p` wraps pasted text in a fenced code block: [`custom/keymaps.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/custom/keymaps.vim#L20-L33), [`terminal.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/utils/terminal.vim#L68-L114), [`markdown.vim`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/ftplugin/markdown.vim#L23-L32).

## Bash and Unix composition

[`commonrc`](https://github.com/widehyo1/dot_files/blob/main/dot_config/bash/commonrc) separates common settings, private/custom overrides, tool-specific rc files, and machine-specific shortcuts. `source_if_cmd()` requires both the command and its rc file, preserving a usable vanilla shell when optional tools are absent.

`GITDIR`, `PLAYDIR`, and `TODAY` centralize workspace locations; `cd*` aliases minimize travel to frequently used projects: [`gitenv`](https://github.com/widehyo1/dot_files/blob/main/dot_config/bash/cli/gitenv), [`gitrc`](https://github.com/widehyo1/dot_files/blob/main/dot_config/bash/cli/gitrc), [`wsl11rc`](https://github.com/widehyo1/dot_files/blob/main/dot_config/bash/machine/wsl11rc). Put reusable personal workflows in `~/.cli/bin` and ensure that directory is on `PATH`.

## Specialization over generic dotfiles

This repository chooses explicit paths, daily notes, WSL locations, local project aliases, and small Unix-tool compositions over portable defaults and broad frameworks. That lowers friction in its author's real workspace, but absolute paths, local databases, external commands, and a personal Python environment mean it must not be installed blindly.

The transferable ideas are conditional loading, a personal command surface, small tools for stable input/output shapes, and treating editor, shell, and terminal state as one workflow. Keep genuinely personal conventions isolated in machine/custom layers so others can replace them.
