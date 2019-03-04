#!/bin/bash

screen=3926.trex
rm screenlog.0
rm /tmp/tput
rm /tmp/mpps
/usr/bin/screen -S $screen -p 0 -X log
sleep 5
/usr/bin/screen -S $screen -p 0 -X stuff "stats --port 0 1^M"
sleep 5
/usr/bin/screen -S $screen -p 0 -X log
echo `cat screenlog.0 | grep "Rx bps" |  gawk  -F: 'BEGIN {FS="|"} { print $4 }' | gawk -F: 'BEGIN {FS=" "} { printf "%.0f\n", $1 }'` > /tmp/tput
echo `cat screenlog.0 | grep "Rx pps" |  gawk  -F: 'BEGIN {FS="|"} { print $4 }' | gawk -F: 'BEGIN {FS=" "} { printf "%.0f\n", $1 }'` > /tmp/mpps
chmod 666 /tmp/mpps
chmod 666 /tmp/tput
cat "/tmp/mpps"
cat "/tmp/tput"

