#!/bin/bash

funct(){
    input_dir=$1
    output_dir=$2
    local -i cur_depth=$3
    max_depth=$4
    start_dir=$5
    (( cur_depth++ ))
    for file in $input_dir/*; do
        if [ -f "$file" ]; then
            copy $file $output_dir $cur_depth $max_depth $start_dir
        fi
        if [ -d "$file" ]; then
            funct $file $output_dir $cur_depth $max_depth $start_dir
        fi
    done
}

copy(){
    file=$1
    output_dir=$2
    local -i cur_depth=$3
    max_depth=$4
    start_dir=$5

    path="${file#*/}"
    path1=${path#*$start_dir}

    ext="${path##*.}"
    base="${path%.*}"
    count=0
    if [ $ext == $base ]; then
        ext=""
    else
        ext=".$ext"
    fi

    if (( $cur_depth<=$max_depth )); then
        while [ -e "$output_dir/$path1" ]; do
            (( count++ ))
            path1="${base}${count}${ext}"
        done
        
        mkdir -p "$(dirname "$output_dir/$path1")"
        cp "$file" "$output_dir/$path1"
    else
        
        new_path=$path1
        for (( i=0; i<(cur_depth-max_depth); i++ )); do
            new_path="${new_path#*/}"
        done
        ext="${new_path##*.}"
        base="${new_path%.*}"
        while [ -e "$output_dir/$new_path" ]; do
            (( count++ ))
            new_path="${base}${count}${ext}"
        done
        mkdir -p "$(dirname "$output_dir/$new_path")"
        cp $file "$output_dir/$new_path"
    fi

}

input_dir=$1
output_dir=$2
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
done #именованные флаги https://unix.stackexchange.com/questions/129391/passing-named-arguments-to-shell-scripts


funct $input_dir $output_dir 0 $MAX_DEPTH "$(basename $input_dir)/"