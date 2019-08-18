#!/bin/bash

create_dates_file_in_folder () {
    for file in *
    do
        if [[ "$file" == *.info.json ]]
        then
            upload_date=$(jq '.upload_date' "$file")
            echo "$upload_date $file" >> dates.txt
        fi
    done
}

rename_files_in_folder () {
    year_index=0
    previous_video_year=99
    episode_index=1
    while read file; do
        if [ $previous_video_year != ${file:1:4} ]
        then
            ((year_index++))
            episode_index=1
        fi

        json_filename=${file:11}
        filename_without_ext=${json_filename%.info.json}
        find . -type f -name "*$filename_without_ext.*" -print0 | while read -d $'\0' line; do
            if [[ "$line" =~ ^.*S[0-9]{2}E[0-9]{3}\ -\ .*$ ]]
            then
                mv "$line" "$(printf 'S%02dE%03d - %s\n' $year_index $episode_index "${line:12}")" 2>/dev/null
            else
                mv "$line" "$(printf 'S%02dE%03d - %s\n' $year_index $episode_index "${line:2}")"
            fi
        done
        previous_video_year=${file:1:4}
        ((episode_index++))
    done <dates.txt
}

shopt -s globstar

for dir in ./**/
do
    if find "$dir"/* -maxdepth 0 -type f -name '*.info.json' | read
    then
        echo "Going in $dir"
        cd "$dir"
        echo "Extracting dates from JSON..."
        create_dates_file_in_folder
        sort -o dates.txt dates.txt
        echo "Renaming files..."
        rename_files_in_folder
        echo "Done."
        rm dates.txt
        cd - > /dev/null
        echo ""
    fi
done
