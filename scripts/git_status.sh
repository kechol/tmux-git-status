#!/usr/bin/env bash
set -e

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

git_status_status_format=""
git_status_default_status_format_default="#[fg=white]"
git_status_dirty_status_format_default="#[fg=yellow]"
git_status_status_delimiter=""
git_status_status_delimiter_default=":"

git_status_modified_count=0
git_status_added_count=0
git_status_deleted_count=0
git_status_renamed_count=0
git_status_copied_count=0
git_status_unmerged_count=0
git_status_untracked_count=0
git_status_dirty_count=0
git_status_modified_symbol=""
git_status_added_symbol=""
git_status_deleted_symbol=""
git_status_renamed_symbol=""
git_status_copied_symbol=""
git_status_unmerged_symbol=""
git_status_untracked_symbol=""
git_status_clean_symbol=""
git_status_dirty_symbol=""

get_status_count() {
	cd $(tmux display -p -F "#{pane_current_path}")
	local git_status=$(git status --porcelain --ignore-submodules 2> /dev/null)
	while IFS='' read line; do
		status=${line:0:2}
		if [[ "$status" =~ \?\? ]]; then
			((git_status_untracked_count++))
		fi
		if [[ "$status" =~ ?U|U?|AA|DD ]]; then
			((git_status_unmerged_count++))
		fi
		if [[ "$status" =~ C[\ MTD] ]]; then
			((git_status_copied_count++))
		fi
		if [[ "$status" =~ R[\ MTD] ]]; then
			((git_status_renamed_count++))
		fi
		if [[ "$status" =~ A[\ MTD] ]]; then
			((git_status_added_count++))
		fi
		if [[ "$status" =~ (M|T)[\ MTD]|[\ MTARC](M|T) ]]; then
			((git_status_modified_count++))
		fi
		if [[ "$status" =~ D[\ MT]|[\ MTARC]D ]]; then
			((git_status_deleted_count++))
		fi
		((git_status_dirty_count++))
	done <<< "$git_status"
}

get_status_format() {
	git_status_status_delimiter=$(get_tmux_option "@git_status_status_delimiter" "$git_status_status_delimiter_default")
	if [ $git_status_dirty_count -ne 0 ]; then
		git_status_status_format=$(get_tmux_option "@git_status_dirty_status_format" "$git_status_dirty_status_format_default")
	else
		git_status_status_format=$(get_tmux_option "@git_status_default_status_format" "$git_status_default_status_format_default")
	fi
}

get_status_symbol() {
	git_status_modified_symbol="M"
	git_status_added_symbol="A"
	git_status_deleted_symbol="D"
	git_status_renamed_symbol="R"
	git_status_copied_symbol="C"
	git_status_unmerged_symbol="U"
	git_status_untracked_symbol="?"
	git_status_clean_symbol="*"
	git_status_dirty_symbol="*"
}

main() {
	get_status_count
	get_status_symbol
	get_status_format
	if in_git_repo; then
		local out="${git_status_status_format}"
		if [ $git_status_dirty_count -ne 0 ]; then
			out="${out}${git_status_dirty_symbol}"
			if [ $git_status_modified_count -ne 0 ]; then
				out="${out}${git_status_status_delimiter}${git_status_modified_symbol}${git_status_modified_count}"
			fi
			if [ $git_status_added_count -ne 0 ]; then
				out="${out}${git_status_status_delimiter}${git_status_added_symbol}${git_status_added_count}"
			fi
			if [ $git_status_deleted_count -ne 0 ]; then
				out="${out}${git_status_status_delimiter}${git_status_deleted_symbol}${git_status_deleted_count}"
			fi
			if [ $git_status_renamed_count -ne 0 ]; then
				out="${out}${git_status_status_delimiter}${git_status_renamed_symbol}${git_status_renamed_count}"
			fi
			if [ $git_status_copied_count -ne 0 ]; then
				out="${out}${git_status_status_delimiter}${git_status_copied_symbol}${git_status_copied_count}"
			fi
			if [ $git_status_unmerged_count -ne 0 ]; then
				out="${out}${git_status_status_delimiter}${git_status_unmerged_symbol}${git_status_unmerged_count}"
			fi
			if [ $git_status_untracked_count -ne 0 ]; then
				out="${out}${git_status_status_delimiter}${git_status_untracked_symbol}${git_status_untracked_count}"
			fi
		else
			out="${out}${git_status_clean_symbol}"
		fi
		echo "${out}#[default]"
	fi
}
main
