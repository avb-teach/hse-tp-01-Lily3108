#!/bin/bash

funct() {
    local input_dir="$1"
    local output_dir="$2"
    local -i cur_depth="$3"
    local max_depth="$4"
    (( cur_depth++ ))
    
    for file in "$input_dir"/*; do
        if [ -f "$file" ]; then
            copy "$file" "$output_dir" "$cur_depth" "$max_depth"
        fi
        if [ -d "$file" ]; then
            funct "$file" "$output_dir" "$cur_depth" "$max_depth"
        fi
    done
}

copy() {
    local file="$1"
    local output_dir="$2"
    local -i cur_depth="$3"
    local max_depth="$4"
    
    local rel_path="${file#$input_dir/}"
    local path="$rel_path"
    
    local ext="${path##*.}"
    local base="${path%.*}"
    local count=0
    
    if [ "$ext" == "$base" ]; then
        ext=""
    else
        ext=".$ext"
    fi

    if (( cur_depth <= max_depth )); then
        while [ -e "$output_dir/$path" ]; do
            (( count++ ))
            path="${base}${count}${ext}"
        done
        
        mkdir -p "$(dirname "$output_dir/$path")"
        cp "$file" "$output_dir/$path"
    else
        IFS='/' read -ra parts <<< "$rel_path"
        local new_path=$(IFS='/' ; echo "${parts[*]:max_depth}")
        
        while [ -e "$output_dir/$new_path" ]; do
            (( count++ ))
            new_path="${new_path%.*}${count}.${new_path##*.}"
        done
        
        cp "$file" "$output_dir/$new_path"
    fi
}

input_dir="$1"
output_dir="$2"
shift 2
MAX_DEPTH=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --max_depth)
      if [[ -n "$2" && "$2" != --* ]]; then
        MAX_DEPTH="$2"
        shift 2
      fi
      ;;
    *)
      break;;
  esac
done

funct "$input_dir" "$output_dir" 0 "$MAX_DEPTH"
