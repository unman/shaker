#!/bin/sh
DATE=`date -Isec`
cp /var/log/snort/snort.alert.fast /var/log/snort/snort.alert.fast_$DATE
echo "Snort starting" > /var/log/snort/snort.alert.fast 
tail -f "/var/log/snort/snort.alert.fast" | xargs -d '\n' -L1 notify-send -u critical -t 1000 --
