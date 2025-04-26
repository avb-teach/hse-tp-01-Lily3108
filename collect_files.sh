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
    flag=0
    ext="${name##*.}"
    base="${name%.*}"
    if [ ext == base ]; then
        ext=""
    fi
    for output_file in $output_dir/*; do
        output_name="$(basename "$output_file")"
        if [ "$name" == "$output_name" ]; then
            mv -- "$output_file" "$output_dir/${base}1.$ext"
        fi
    done
    ma=0
    for output_file in $output_dir/*; do
        b=${output_file##*/}
        num=${b#"$base"}
        num=${num%".$ext"}
        if [[ $num =~ ^[0-9]+$ ]]; then
            if (( num>ma )); then
                ma=$num
            fi
        fi
    done
    if (( ma == 0 )); then
        cp $file "$output_dir/${base}.$ext"
    else
        (( ma++ ))
        cp $file "$output_dir/${base}$ma.$ext"
    fi
}

input_dir=$1
output_dir=$2



funct $input_dir $output_dir


