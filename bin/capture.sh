#!/bin/bash

title="capture"
icon="clipboard"

# Defaults
mode="screenshot"
hide_cursor="Yes"
service="pbpst"

while getopts ":lm:cs:" opt; do
    case $opt in
        l)
            # Alternative behaviour
            local=true
            ;;
        m)
            mode="$OPTARG"
            ;;
        c)
            hide_cursor="No"
            ;;
        s)
            service="$OPTARG"
            ;;
        * )
            exit
            ;;
    esac
done

# Helper functions
upload() {
    case "$service" in
        "pbpst" )
            pbpst -Sf "$file" -x 1d
            ;;
        * )
            exit
            ;;
    esac
}

notify() {
    dunstify -r 2500 -i "$icon" "$title" "$body"
}

cleanup() {
    if [ "$local" != true ]; then
        rm -rf "$file"
    fi
}
trap cleanup EXIT

error() {
    icon="error"
    notify
    cleanup
}

dunstify -r 2500 "$title" "$(printf "Select window or area to capture.\nPress RIGHT-CLICK to cancel.")"

case "$mode" in
    "screenshot" )
	file=$(mktemp /tmp/screenshot-XXXXXXXXXX.png)
	if [ -z "$hide_cursor" ]; then
	    hide_cursor="$(printf "Yes\nNo" | rofi -dmenu -lines 2 -p "Hide cursor?")"
	    case $? in
		1)
		    body="Error: rofi"
		    error
		    exit 1
		    ;;
		0)
		    ;;
	    esac
	fi
	if [ "$hide_cursor" = "Yes" ]; then
	    hide_cursor_arg="-u"
	fi
	maim -s $hide_cursor_arg -b 5 "$file"
	# escrotum -s $file
	case $? in
	    1 )
		icon="error-blue"
		body="Cancelled"
		notify
		exit 0
		;;
	    0 )
		;;
	esac

	if [[ -f $file ]]; then
	    rofi_exit=$(echo -e "Yes\nNo\nCancel" | rofi -dmenu -p "Do you need to obscure anything?")
	    case $rofi_exit in
		"Yes" )
		    mtpaint "$file"
		    gimp_exit=$?
		    if [[ $gimp_exit -ne 0 ]]; then
                echo "Error: gimp"
                exit $gimp_exit
		    fi
		    ;;
		"No" )
		    ;;
		"Cancel" )
		    icon="error"
		    body="Cancelled"
		    notify
		    exit 0
		    ;;
		* )
		    body="Error: rofi"
		    error
		    exit 1
		    ;;
	    esac
	    if [ "$local" = true ]; then
            echo "$file" | xclip -selection clipboard -t image/png -i "$file";
                        dunstify -r 2500 -i "$icon"		\
                 "$title"			\
                 "$(printf "Screenshot successfully stored locally.\nPATH: %s" "$file")"
	    else
            output=$(upload)
            url=$(echo "${output##*$'\n'}")
            echo "$url" | xclip -sel c;
            dunstify -r 2500 -i "$icon"		\
                 "$title"			\
                 "$(printf "Screenshot successfully uploaded.\nURL: %s" "$url")"
	    fi
	fi
	;;

    "video" )
	trap -- '' SIGINT SIGTERM

	if [ "$local" = true ]; then
	    file="$(recap rec)"
	    echo "$file" | xclip -sel c;
		dunstify -r 2500 -i "$icon"		\
			 "$title"			\
			 "$(printf "Video successfully stored locally.\nPATH: %s" "$file")"
	else
	    file="$(recap rec)"
	    echo "Ended"
	    output=$(upload)
	    url="$(echo "${output##*$'\n'}")"
	    echo "$url" | xclip -sel c;
		dunstify -r 2500 -i "$icon"		\
			 "$title"			\
			 "$(printf "Video successfully uploaded.\nURL: %s" "$url")"
	fi
	;;
esac
