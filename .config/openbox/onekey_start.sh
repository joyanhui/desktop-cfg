sh .config/polybar/polybar_run.sh &
/usr/bin/feh --randomize --bg-fill ~/bg/* &

killall plank -9 

plank &


/bin/sh -c 'sleep 1 && pgrep compton || compton'  &


/bin/sh -c 'sleep 1 && pgrep pulseaudio || pulseaudio'  &

/bin/sh -c 'sleep 1 && pgrep fcitx5 || fcitx5'  &





/bin/sh -c 'sleep 1 && pgrep nm-tray || nm-tray'  &

/bin/sh -c 'sleep 1 && pgrep compton || compton'  &

