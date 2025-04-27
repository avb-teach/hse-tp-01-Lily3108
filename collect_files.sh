#!/bin/bash

input_dir=$1
output_dir=$2


stack=("$input_dir")

while [ ${#stack[@]} -gt 0 ]; do
    current_dir=${stack[-1]}
    unset 'stack[${#stack[@]}-1]'
    
    for file in "$current_dir"/*; do
        if [ -f "$file" ]; then

            name="$(basename "$file")"
            ext="${name##*.}"
            base="${name%.*}"
            
            if [ "$ext" == "$base" ]; then
                ext=""
            else
                ext=".$ext"
            fi
            

            for output_file in "$output_dir"/*; do
                output_name="$(basename "$output_file")"
                if [ "$name" == "$output_name" ]; then
                    mv -- "$output_file" "$output_dir/${base}1$ext"
                fi
            done
            

            ma=0
            for output_file in "$output_dir"/*; do
                b=${output_file##*/}
                num=${b#"$base"}
                num=${num%"$ext"}
                if [[ $num =~ ^[0-9]+$ ]]; then
                    if (( num > ma )); then
                        ma=$num
                    fi
                fi
            done
            

            if (( ma == 0 )); then
                cp "$file" "$output_dir/${base}$ext"
            else
                (( ma++ ))
                cp "$file" "$output_dir/${base}$ma$ext"
            fi

            
        elif [ -d "$file" ]; then
            stack+=("$file")
        fi
    done
done
