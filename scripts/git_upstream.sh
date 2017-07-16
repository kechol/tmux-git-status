#!/usr/bin/env bash
set -e

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

git_status_upstream_format_default="#[fg=yellow]"
git_status_upstream_format=""

git_status_ahead_count=0
git_status_behind_count=0

git_status_ahead_symbol=""
git_status_behind_symbol=""
git_status_ahead_symbol_default="+"
git_status_behind_symbol_default="-"

get_upstream_count() {
	cd $(tmux display -p -F "#{pane_current_path}")
	local upstream="$(git rev-list --count --left-right HEAD...@{upstream} 2> /dev/null)"
	if [ -n "$upstream" ]; then
		local upstream_count=($upstream)
		git_status_ahead_count=${upstream_count[0]}
		git_status_behind_count=${upstream_count[1]}
	fi
}

get_upstream_format() {
	git_status_upstream_format=$(get_tmux_option "@git_status_upstream_format" "$git_status_upstream_format_default")
	git_status_ahead_symbol=$(get_tmux_option "@git_status_ahead_symbol" "$git_status_ahead_symbol_default")
	git_status_behind_symbol=$(get_tmux_option "@git_status_behind_symbol" "$git_status_behind_symbol_default")
}

main() {
	get_upstream_count
	get_upstream_format
	if in_git_repo; then
		if [ $git_status_ahead_count -ne 0 ] || [ $git_status_behind_count -ne 0 ]; then
echo \
"${git_status_upstream_format}"\
"${git_status_ahead_symbol}"\
"${git_status_ahead_count}"\
"${git_status_behind_symbol}"\
"${git_status_behind_count}"\
"#[default]"
		fi
	fi
}
main
