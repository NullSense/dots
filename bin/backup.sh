#!/usr/bin/env bash

date=$(date +%y-%m-%d/%H:%M:%S)

# FULL
#echo -e "----------------------------------------------------------------------------------------------------"
#echo -e "================1st Backup================="
#echo -e "=================250 SSD==================="
#echo -e "Backup TO: /dev/sdc1"
#echo -e "==========================================="
#echo -e "===Backup started at '$date'==="
#echo -e "==========================================="

#echo -e "==========================================="
#echo -e "=========Starting music file backup========"
#echo -e "==========================================="
# Backup music to 250GB SSD
#rsync -aHx --stats --numeric-ids --exclude="lost+found" --exclude='*.mkv' --exclude='*.rar' --exclude='*.nfo' --exclude='*.idx' "/home/ongo/Music/" "/mnt/Music_bak/Music/"

echo -e "----------------------------------------------------------------------------------------------------"
echo -e "================2nd Backup================="
echo -e "=================1TB HDD==================="
echo -e "Backup TO: /dev/sda1 UUID="ECCCAC3CCCABFEC8""
echo -e "==========================================="
echo -e "===Backup started at '$date'==="
echo -e "==========================================="

echo -e "==========================================="
echo -e "=========Starting music file backup========"
echo -e "==========================================="
# Backup music to 1TB HDD
rsync -aHx --stats --numeric-ids --exclude="lost+found" --exclude='*.mkv' --exclude='*.rar' --exclude='*.nfo' --exclude='*.idx' "/home/ongo/Music/" "/mnt/Backup_Home_Music/Music/"

echo -e "==========================================="
echo -e "========Starting torrent file backup======="
echo -e "==========================================="
# Backup torrent files to 1TB HDD
rsync -aHx --stats --numeric-ids --exclude="lost+found" --exclude='*.mkv' --exclude='*.rar' --exclude='*.nfo' --exclude='*.idx' "/home/ongo/Downloads/torrent files/" "/mnt/Backup_Home_Music/Downloads/torrent files"

echo -e "==========================================="
echo -e "=======Starting home directory backup======"
echo -e "==========================================="
# Backup home to 1TB HDD
rsync -aHx --stats --delete --numeric-ids --exclude="Videos" --exclude=".cache" --exclude="Music" --exclude="Downloads" --exclude="lost+found" "/home/ongo/" "/mnt/Backup_Home_Music/home/"




date=$(date +%y-%m-%d/%H:%M:%S)

echo -e "================3rd Backup================="
echo -e "=================3TB HDD==================="
echo -e "==========================================="
echo -e "===Backup started at '$date'==="
echo -e "==========================================="
echo -e "Backup TO: /dev/sdd2: UUID="fbfa2822-db95-4199-a844-d7ad77159700""


echo -e "==========================================="
echo -e "=========Starting music file backup========"
echo -e "==========================================="
# Backup music to 3TB HDD
rsync -aHx --stats --numeric-ids --exclude="lost+found" --exclude='*.mkv' --exclude='*.rar' --exclude='*.nfo' --exclude='*.idx' "/home/ongo/Music/" "/mnt/3TB_Backup/Music/"

echo -e "==========================================="
echo -e "========Starting torrent file backup======="
echo -e "==========================================="
# Backup torrent files to 3TB HDD
rsync -aHx --stats --numeric-ids --exclude="lost+found" --exclude='*.mkv' --exclude='*.rar' --exclude='*.nfo' --exclude='*.idx' "/home/ongo/Downloads/torrent files/" "/mnt/3TB_Backup/torrent files"
