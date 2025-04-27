#!/bin/bash

funct(){
    input_dir=$1
    output_dir=$2
    current_depth=$3
    max_depth=$4
    (( $current_depth++ ))
    for file in $input_dir/*; do
        if [ -f "$file" ]; then
            if (( $current_depth >= $max_depth )); then
                copy $file $output_dir
            fi
        fi
        if [ -d "$file" ]; then
            funct $file $output_dir $current_depth $max_depth
            if (( $current_depth >= $max_depth )); then
                funct $file $output_dir 1 $max_depth
            else
                funct $file $output_dir $current_depth $max_depth
            fi
        fi
    done
}

copy(){
    file=$1
    output_dir=$2
    name="$(basename "$file")"
    flag=0
    ext="${name##*.}"
    base="${name%.*}"
    if [ $ext == $base ]; then
        ext=""
    else
        ext=".$ext"
    fi
    for output_file in $output_dir/*; do
        output_name="$(basename "$output_file")"
        if [ "$name" == "$output_name" ]; then
            mv -- "$output_file" "$output_dir/${base}1$ext"
        fi
    done
    ma=0
    for output_file in $output_dir/*; do
        b=${output_file##*/}
        num=${b#"$base"}
        num=${num%"$ext"}
        if [[ $num =~ ^[0-9]+$ ]]; then
            if (( num>ma )); then
                ma=$num
            fi
        fi
    done
    if (( ma == 0 )); then
        cp $file "$output_dir/${base}$ext"
    else
        (( ma++ ))
        cp $file "$output_dir/${base}$ma$ext"
    fi
}

input_dir=$1
input_dir="${input_dir#/}"
output_dir=$2
output_dir="${output_dir#/}"


funct $input_dir $output_dir 1 1


