#!/bin/bash

funct(){
    input_dir=$1
    output_dir=$2
    for file in $input_dir/*; do
        if [ -f "$file" ]; then
            copy $file $output_dir
        fi
        if [ -d "$file" ]; then
            funct $file $output_dir
        fi
    done
}

copy(){
    file=$1
    output_dir=$2
    name="$(basename "$file")"
    ext="${name##*.}"
    base="${name%.*}"
    count=0
    if [ $ext == $base ]; then
        ext=""
    else
        ext=".$ext"
    fi
    while [ -e "$output_dir/$name" ]; do
        (( count++ ))
        name="${base}${count}${ext}"
    done
    cp "$file" "$output_dir/$name"
}

input_dir=$1
output_dir=$2



funct $input_dir $output_dir