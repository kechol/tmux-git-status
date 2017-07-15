#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

main() {
	if in_git_repo; then
		echo '@P'
	else
		echo '!P'
	fi
}
main
