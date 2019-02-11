#!/bin/bash
screen=6560.trex
#/usr/bin/screen -S $screen -p 1 -X stuff "stop -p 0 1"
/usr/bin/screen -S $screen  -X stuff "stop -p 0 1^M"
