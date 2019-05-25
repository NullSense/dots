#!/bin/bash
# source: http://www.stackednotion.com/blog/2019/05/07/automatically-dimming-your-monitor-at-night/

# Sets the brightness to 0 - 100
set () {
	ddccontrol -r 0x10 -w "$1" -f dev:/dev/i2c-6 > /dev/null 2>&1
}

# Returns the brightness 0 - 100
get_brightness () {
	ddccontrol -r 0x10 dev:/dev/i2c-6 2>&1| grep "Control 0x10" | awk -F "/" ' { print $2 } '
    sleep 1
}

case $1 in
	period-changed)
		target=0

		case $3 in
			night)
				target=30
				;;
			transition)
				target=50
				;;
			daytime)
				target=100
				;;
			*)
				(>&2 echo "Unknown target period $3")
				exit 1
				;;
		esac

		current=$(get_brightness)

		case $2 in
			none)
				(>&2 echo "Change from $current to $target")
				set $target
				;;
			*)
				(>&2 echo "Transition from $current to $target")
				while [[ $current -ne $target ]]; do
					if [[ $current -gt $target ]]; then
						((current -= 1))
					else
						((current += 1))
					fi

					set $current
				done
				;;
		esac
		;;
esac
