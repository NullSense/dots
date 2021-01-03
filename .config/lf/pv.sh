#!/bin/sh

case "$1" in
    *.tgz|*.tar.gz) tar tzf "$1";;
    *.tar.bz2|*.tbz2) tar tjf "$1";;
    *.tar.txz|*.txz) xz --list "$1";;
    *.tar) tar tf "$1";;
    *.zip|*.jar|*.war|*.ear|*.oxt) unzip -l "$1";;
    *.rar) unrar l "$1";;
    *.7z) 7z l "$1";;
    *.[1-8]) man "$1" | col -b ;;
    *.flac|*.mp3|*.mkv|*.m4v|*.jpg|*.png|*.gif|*.jpeg) viu "$1";;
    *.pdf) pdftotext "$1" -;;
    *.torrent) transmission-show "$1";;
    *.iso) iso-info --no-header -l "$1";;
    *.o) nm "$1" | less ;;
    *) bat --paging=never -n --color always "$1" || cat "$1";;
esac
