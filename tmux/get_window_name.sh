#!/usr/bin/env bash

#Usage: ./get_window_name.sh <directory> <mode> 
#mode: 'name' (window name), 'git' (right bar)
DIR="$1"
MODE="$2"
CMD="$3"

cd "$DIR" 2>/dev/null || exit

get_base_name() {
	REPO_NAME=$(cd "$1" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null)
	if [ -n "$REPO_NAME" ]; then
		basename "$REPO_NAME"
	else
		[ "$1" == "$HOME" ] && echo "home" || basename "$1"
	fi
}

if [ "$MODE" == "name" ]; then
	#try git repo first
	NAME=$(get_base_name "$DIR")
	
	case "$CMD" in
		nvim|vim)
			echo "$NAME ($CMD)"
			;;
		zsh|bash|sh)
			echo "$NAME"
			;;
		*)
			echo "$NAME ($CMD)"
			;;
	esac

elif [ "$MODE" == "git" ]; then
	BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
	if [ -n "$BRANCH" ]; then
		STATUS=$(git status --porcelain 2>/dev/null)
		if [ -n "$STATUS" ]; then
			printf "  %s  " "$BRANCH"
		else
			printf "  %s " "$BRANCH"
		fi
	fi
fi
