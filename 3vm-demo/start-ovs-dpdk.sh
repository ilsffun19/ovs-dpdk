echo 28 > /sys/devices/system/node/node0/hugepages/hugepages-1048576kB/nr_hugepages
echo 28 > /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages
umount /dev/hugepages
#umount nodev /mnt/huge_2mb
mount -t hugetlbfs nodev /dev/hugepages
#mount -t hugetlbfs nodev /mnt/huge_2mb -o pagesize=2MB
mount

cat /proc/meminfo
#sleep 5
#rmmod i40e
#rmmod ixgbe
rmmod igb_uio
rmmod cuse
rmmod fuse
rmmod openvswitch
rmmod uio
rmmod eventfd_link
rmmod ioeventfd
rm -rf /dev/vhost-net

export DPDK_DIR=/root/ovs-dpdk/dpdk
export DPDK_BUILD=$DPDK_DIR/x86_64-native-linuxapp-gcc
export OVS_DIR=/root/ovs-dpdk/ovs

modprobe uio
insmod $DPDK_BUILD/kmod/igb_uio.ko

#Edit the PCI ID devices you would be using for OVS-DPDK


python $DPDK_DIR/usertools/dpdk-devbind.py --bind=igb_uio 86:00.0
python $DPDK_DIR/usertools/dpdk-devbind.py --bind=igb_uio 88:00.0
python $DPDK_DIR/usertools/dpdk-devbind.py --bind=igb_uio af:00.0
python $DPDK_DIR/usertools/dpdk-devbind.py --bind=igb_uio b1:00.0
python $DPDK_DIR/usertools/dpdk-devbind.py --bind=igb_uio d8:00.0
python $DPDK_DIR/usertools/dpdk-devbind.py --bind=igb_uio da:00.0

python $DPDK_DIR/usertools/dpdk-devbind.py --status 


# terminate OVS

pkill -9 ovs
rm -rf /usr/local/var/run/openvswitch
rm -rf /usr/local/etc/openvswitch/
rm -rf /usr/local/var/log/openvswitch
rm -f /tmp/conf.db

mkdir -p /usr/local/etc/openvswitch
mkdir -p /usr/local/var/run/openvswitch
mkdir -p  /usr/local/var/log/openvswitch

# initialize new OVS database

cd $OVS_DIR
#modprobe fuse
#modprobe cuse
./ovsdb/ovsdb-tool create /usr/local/etc/openvswitch/conf.db ./vswitchd/vswitch.ovsschema

#start database server
./ovsdb/ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \
                 --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
                 --pidfile --detach

#initialize OVS database
./utilities/ovs-vsctl --no-wait init


#start OVS with DPDK portion using 1GB

export DB_SOCK=/usr/local/var/run/openvswitch/db.sock
 
./utilities/ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true other_config:dpdk-lcore-mask=0x200000 other_config:dpdk-socket-mem="2048,2048"

./vswitchd/ovs-vswitchd unix:$DB_SOCK --pidfile --detach  --log-file=/usr/local/var/log/openvswitch/ovs-vswitchd.log

