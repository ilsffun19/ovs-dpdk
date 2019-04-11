#!/bin/sh
#cd /root/ovs-dpdk
#cp ./configs/trex_cfg-2ports.yaml /etc
echo 8192 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
umount /mnt/huge
mount -t hugetlbfs nodev /mnt/huge -o pagesize=2M
cat /proc/meminfo
mount
echo "Starting Trex server"
cd /root/ovs-dpdk/trex/
./t-rex-64 -i  --cfg /etc/trex_cfg-2ports.yaml
