#!/bin/bash

date=$(date +%d-%m-%y/%H:%M:%S)

echo -e "Backup started at \e[1;38;5;208m'$date'\e[0m"

# Backup music to HDD
rsync -aHx --stats --numeric-ids --exclude="lost+found" --exclude='*.mkv' --exclude='*.rar' --exclude='*.nfo' --exclude='*.idx' ~/Music/ /mnt/windows/Music/
