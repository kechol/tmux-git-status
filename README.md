# Tmux git status

[tmux-git-status](https://github.com/kechol/tmux-git-status) is a tmux plugin that enables displaying git status on your tmux status line.

![tmux_git_status](https://github.com/kechol/tmux-git-status/raw/master/screenshots/tmux_git_status.png)


## Installation

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

```tmux
set -g @plugin 'kechol/tmux-git-status'
```


### Manual Installation

Clone the repo anywhere you want:

```console
$ git clone https://github.com/kechol/tmux-git-status ~/.tmux-git-status
```

Add this line to the bottom of `.tmux.conf`:

```tmux
run-shell ~/.tmux-git-status/git_status.tmux
```

Reload TMUX environment:

```console
# type this in terminal
$ tmux source-file ~/.tmux.conf
```


## Usage

### Basic Usage

Add `#{git_branch}`, `#{git_upstream}` or `#{git_status}` format string to your existing `status-right` tmux
option.

Here's the example in `.tmux.conf`:

```tmux
set -g status-interval 1
set -g status-right-length 100
set -g status-right "#{git_branch} #{git_upstream} #{git_status} | %a %h-%d %H:%M"
```

Please set `status-interval` short to keep update the git info. Also, you may need to set `status-right-length` long enough.

### Configuration

There are some options to custom looks as you like.

```tmux
set -g @git_status_branch_format '#[fg=red]' # default: '#[fg=white]'
set -g @git_status_upstream_format '#[fg=red]' # default: '#[fg=yellow]'
set -g @git_status_dirty_status_format '#[fg=red]' # default: '#[fg=yellow]'
set -g @git_status_default_status_format '#[fg=black]' # default: '#[fg=white]'
set -g @git_status_status_delimiter '|' # default: ':'
set -g @git_status_ahead_symbol '↑' # default: '+'
set -g @git_status_behind_symbol '↓' # default: '-'
```


## Credits

Take inspiration from:

- [sorin-ionescu/prezto git-info module](https://github.com/sorin-ionescu/prezto)
- [aurelien-rainone/tmux-gitbar](https://github.com/aurelien-rainone/tmux-gitbar)
- [powerline/powerline](https://github.com/powerline/powerline)
- [tmux-plugins/tmux-online-status](https://github.com/tmux-plugins/tmux-online-status)

Other credits:
- [tmux/tmux](https://github.com/tmux/tmux)
- [tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)

## License

[MIT](LICENSE.md)
