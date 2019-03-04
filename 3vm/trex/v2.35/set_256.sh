#!/bin/bash
screen=3926.trex
/usr/bin/screen -S $screen  -X stuff "stop -port 0 1"
/usr/bin/screen -S $screen -X stuff "start -f /root/barcelona_yamls/vyatta-pvvp-510k-1_256.yaml --force -p 0"
/usr/bin/screen -S $screen  -X stuff "start -f /root/barcelona_yamls/vyatta-pvvp-510k-2_256.yaml --force -p 1"
