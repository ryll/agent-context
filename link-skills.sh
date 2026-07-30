#!/usr/bin/env bash

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_dir="$script_dir/.agents/skills"

home_dir=${HOME:?HOME is not set}
target_dirs=(
    "$home_dir/.codex/skills"
    "$home_dir/.gemini/config/skills"
    "$home_dir/.claude/skills"
)

for target_dir in "${target_dirs[@]}"; do
    mkdir -p -- "$target_dir"

    for skill_dir in "$source_dir"/*; do
        [ -d "$skill_dir" ] || continue

        skill_name=${skill_dir##*/}
        link_path="$target_dir/$skill_name"

        if [ -e "$link_path" ] || [ -L "$link_path" ]; then
            printf 'Skipping existing entry: %s\n' "$link_path"
            continue
        fi

        ln -s -- "$skill_dir" "$link_path"
        printf 'Linked %s -> %s\n' "$link_path" "$skill_dir"
    done
done
