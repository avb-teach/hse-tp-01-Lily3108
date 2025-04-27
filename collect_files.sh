#!/bin/bash

input_dir=$1
output_dir=$2

# Имитация функции funct с помощью стека
stack=("$input_dir")

while [ ${#stack[@]} -gt 0 ]; do
    current_dir=${stack[-1]}
    unset 'stack[${#stack[@]}-1]'
    
    for file in "$current_dir"/*; do
        if [ -f "$file" ]; then
            # Начало замены функции copy
            name="$(basename "$file")"
            ext="${name##*.}"
            base="${name%.*}"
            
            if [ "$ext" == "$base" ]; then
                ext=""
            else
                ext=".$ext"
            fi
            
            # Проверка на существование файлов с таким же именем
            for output_file in "$output_dir"/*; do
                output_name="$(basename "$output_file")"
                if [ "$name" == "$output_name" ]; then
                    mv -- "$output_file" "$output_dir/${base}1$ext"
                fi
            done
            
            # Поиск максимального номера
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
            
            # Копирование файла с новым именем
            if (( ma == 0 )); then
                cp "$file" "$output_dir/${base}$ext"
            else
                (( ma++ ))
                cp "$file" "$output_dir/${base}$ma$ext"
            fi
            # Конец замены функции copy
            
        elif [ -d "$file" ]; then
            stack+=("$file")
        fi
    done
done