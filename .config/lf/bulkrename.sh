#!/bin/bash

# create tmp file
rename_file="$(mktemp)"
marked_files=()
# Write to tmp file and put the names in marked_files array
for i in $@ ; do 
    marked_files+=("$i")
    n=$(basename -- "$i")
    printf "$n\n" >> "$rename_file" ;
done 
#printf '%s\n' "${marked_files[@]##*/}" > "$rename_file"
"${EDITOR:-vi}" "$rename_file"

# Read the renamed files to an array.
IFS=$'\n' read -d "" -ra changed_files < "$rename_file"

# If deleted a line, stop...
((${#marked_files[@]} != ${#changed_files[@]})) && {
    rm "$rename_file"
    exit 1
}

printf '%s\n%s\n' \
    "# This file will be executed when the editor is closed." \
    "# Clear the file to abort." > "$rename_file"

renamed=0
# Construct the rename commands.
for ((i=0;i<${#marked_files[@]};i++)); {
    [[ ${marked_files[i]} != "${PWD}/${changed_files[i]}" ]] && {
        printf 'mv -i -- %q %q\n' \
            "${marked_files[i]}" "${PWD}/${changed_files[i]}"
        renamed=1
    }
} >> "$rename_file"

# Let the user double-check the commands and execute them.
((renamed == 1)) && {
    "${EDITOR:-vi}" "$rename_file"

    source "$rename_file"
    rm "$rename_file"
}
