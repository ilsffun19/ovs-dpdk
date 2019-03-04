#!/bin/bash

rm screenlog.0
rm /tmp/mpps
/usr/bin/screen -S 2764.102397.shared -p 0 -X log
sleep 5
/usr/bin/screen -S 2764.102397.shared -p 0 -X stuff "stats --port 0 1^M"
sleep 5
/usr/bin/screen -S 2764.102397.shared -p 0 -X log
echo `cat ./screenlog.0 | grep "Rx pps" | colrm 1 60 | colrm 4` > /tmp/tput
chmod 666 /tmp/mpps
cat "/tmp/mpps"

