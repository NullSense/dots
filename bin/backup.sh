#!/usr/bin/env bash

date=$(date +%y-%m-%d/%H:%M:%S)

echo -e "==========================================="
echo -e "===Backup started at '$date'==="
echo -e "==========================================="

echo -e "==========================================="
echo -e "=========Starting music file backup========"
echo -e "==========================================="
# Backup music to HDD
rsync -aHx --stats --numeric-ids --exclude="lost+found" --exclude='*.mkv' --exclude='*.rar' --exclude='*.nfo' --exclude='*.idx' ~/Music/ /mnt/windows/Music/

echo -e "==========================================="
echo -e "========Starting torrent file backup======="
echo -e "==========================================="
# Backup torrent files to HDD
rsync -aHx --stats --numeric-ids --exclude="lost+found" --exclude='*.mkv' --exclude='*.rar' --exclude='*.nfo' --exclude='*.idx' "/home/ongo/Downloads/torrent files/" "/mnt/windows/Downloads/torrent files"

echo -e "==========================================="
echo -e "=======Starting home directory backup======"
echo -e "==========================================="
rsync -aHx --stats --delete --numeric-ids --exclude="Videos" --exclude="Music" --exclude="Downloads" --exclude="lost+found" "/home/ongo/" "/mnt/windows/home_backup"
