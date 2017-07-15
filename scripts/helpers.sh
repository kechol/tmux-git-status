is_osx() {
	[ $(uname) == "Darwin" ]
}

is_cygwin() {
	[[ $(uname) =~ CYGWIN ]]
}

in_git_repo() {
	cd $(tmux display -p -F "#{pane_current_path}")
	local is_inside_work_tree=$(git rev-parse --is-inside-work-tree 2> /dev/null)
	[ "$is_inside_work_tree" == true ]
}

get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

set_tmux_option() {
	local option="$1"
	local value="$2"
	tmux set-option -gq "$option" "$value"
}
