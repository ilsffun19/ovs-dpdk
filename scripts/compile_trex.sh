cd /root/ovs-dpdk/trex/ko/src
make clean; make
rmmod igb_uio uio
modprobe uio
insmod /root/ovs-dpdk/trex/ko/src/igb_uio.ko
cd /root/ovs-dpdk
