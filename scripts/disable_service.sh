#!/bin/bash

#echo never  > /sys/kernel/mm/transparent_hugepages/enabled
echo "#Disable Address Space Layout Randomization (ASLR)" > /etc/sysctl.d/aslr.conf
echo "kernel.randomize_va_space=0" >> /etc/sysctl.d/aslr.conf
echo "# Enable IPv4 Forwarding" > /etc/sysctl.d/ip_forward.conf
echo "net.ipv4.ip_forward=0" >> /etc/sysctl.d/ip_forward.conf

echo 0 > /proc/sys/kernel/nmi_watchdog
#net.ipv6.conf.all.disable_ipv6 = 1
#net.ipv6.conf.default.disable_ipv6 = 1
#net.ipv6.conf.lo.disable_ipv6 = 1
systemctl restart systemd-sysctl.service
#systemctl stop irqbalance.service
systemctl disable irqbalance.service
systemctl stop firewalld
cat /proc/sys/kernel/randomize_va_space
service iptables stop
cat /proc/sys/net/ipv4/ip_forward
ufw disable
#pkill -9 abrtd
pkill -9 crond
pkill -9 atd
#pkill -9 uml_switch
pkill -9 cron
#pkill -9 charger_manager
#pkill -9 ipv6_addrconf
#pkill -9 acpi_thermal_pm
#pkill -9 lxcfs
#pkill -9 accounts-daemon

echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag
sysctl -w vm.swappiness=0
sysctl -w vm.zone_reclaim_mode=0
service irqbalance stop
