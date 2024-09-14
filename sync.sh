#!/bin/bash

function sync_dir() {
    local src="$1"
    local target="$2"
    
    if [[ -d "$src" ]] && [[ -d "$target" ]]; then
        for file in "$src"/*; do
            name=$(basename "$file")
            if [[ -d "$file" ]]; then
                if [[ ! -d "$target"/"$name" ]]; then
                    mkdir "$target"/"$name"
                fi
                sync_dir "$file" "$target"/"$name"
            elif [[ -f "$file" ]] && [[ ! -f "$target"/"$name" ]]; then
                cp "$file" "$target"
            fi
        done
        for file in "$target"/*; do
            name=$(basename "$file")
            if [[ -d "$file" ]]; then
                if [[ ! -d "$src"/"$name" ]]; then
                    rm -r "$file"
                fi
            elif [[ -f "$file" ]] && [[ ! -f "$src"/"$name" ]]; then
                rm "$file"
            fi
        done
    fi
}

sync_dir "$1" "$2"
