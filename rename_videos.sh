#!/bin/bash

create_dates_file_in_folder () {
    for file in *
    do
        if [[ "$file" == *.info.json ]]
        then
            cat "$file" | jq '"\(.upload_date) \(.display_id)"' >> dates.txt
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

        find . -type f -name "*${file:10:11}.*" | while read line; do
            if [[ "$line" =~ ^.*S[0-9]+E[0-9]+.*$ ]]
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
        echo "Renaming files"
        rename_files_in_folder
        rm dates.txt
        cd -
    fi
done
