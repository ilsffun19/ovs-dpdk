#!/bin/bash
screen=3926.trex
/usr/bin/screen -S $screen  -X stuff "portattr -p 0 1 --prom on --mult on"
