#!/usr/bin/env bash
set -e

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/scripts/helpers.sh"

git_status_interpolations=(
	"\#{git_branch}"
	"\#{git_status}"
	"\#{git_upstream}"
)

git_status_commands=(
	"#($CURRENT_DIR/scripts/git_branch.sh)"
	"#($CURRENT_DIR/scripts/git_status.sh)"
	"#($CURRENT_DIR/scripts/git_upstream.sh)"
)

do_interpolation() {
	local all_interpolated="$1"
	for ((i=0; i<${#git_status_commands[@]}; i++)); do
		all_interpolated=${all_interpolated/${git_status_interpolations[$i]}/${git_status_commands[$i]}}
	done
	echo "$all_interpolated"
}

update_tmux_option() {
	local option="$1"
	local option_value="$(get_tmux_option "$option")"
	local new_option_value="$(do_interpolation "$option_value")"
	set_tmux_option "$option" "$new_option_value"
}

main() {
	update_tmux_option "status-right"
	update_tmux_option "status-left"
}
main
