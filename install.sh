#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
source_root=$repo_root/home

link_tree() {
	local source=$1
	local target=$2

	if [[ -L $target ]]; then
		if [[ $(readlink -f -- "$target") == $(readlink -f -- "$source") ]]; then
			return
		fi
		printf 'Refusing to replace existing symlink: %s\n' "$target" >&2
		return 1
	fi

	if [[ -d $source ]]; then
		if [[ -e $target ]]; then
			if [[ ! -d $target ]]; then
				printf 'Refusing to replace existing file: %s\n' "$target" >&2
				return 1
			fi

			local child
			while IFS= read -r -d '' child; do
				link_tree "$child" "$target/${child##*/}"
			done < <(find "$source" -mindepth 1 -maxdepth 1 -print0)
		else
			mkdir -p -- "$(dirname -- "$target")"
			ln -s -- "$source" "$target"
		fi
	else
		if [[ -e $target ]]; then
			printf 'Refusing to replace existing file: %s\n' "$target" >&2
			return 1
		fi
		mkdir -p -- "$(dirname -- "$target")"
		ln -s -- "$source" "$target"
	fi
}

while IFS= read -r -d '' entry; do
	link_tree "$entry" "$HOME/${entry##*/}"
done < <(find "$source_root" -mindepth 1 -maxdepth 1 ! -name .gitkeep -print0)
