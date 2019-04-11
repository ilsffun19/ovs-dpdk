#!/bin/sh

echo
echo "Shutdown extraneous services..."
cd /root/ovs-dpdk
./scripts/disable_service.sh > /dev/null
./scripts/stop_services.sh > /dev/null
echo
echo "Done"
echo
echo "Running the configuration scripts for two VMs..."
echo 24 > /sys/devices/system/node/node0/hugepages/hugepages-1048576kB/nr_hugepages
echo 24 > /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages
umount /dev/hugepages
mount -t hugetlbfs nodev /dev/hugepages -o pagesize=1G


#rmmod i40e 
#rmmod ixgbe
rmmod igb_uio > /dev/null
rmmod cuse > /dev/null
rmmod fuse > /dev/null
rmmod openvswitch > /dev/null
rmmod uio > /dev/null
rmmod eventfd_link > /dev/null
rmmod ioeventfd > /dev/null
rm -rf /dev/vhost-net > /dev/null

export DPDK_DIR=/root/ovs-dpdk/dpdk
export DPDK_BUILD=$DPDK_DIR/x86_64-native-linuxapp-gcc
export OVS_DIR=/root/ovs-dpdk/ovs
export DB_SOCK=/usr/local/var/run/openvswitch/db.sock

modprobe uio > /dev/null
insmod $DPDK_BUILD/kmod/igb_uio.ko > /dev/null

# Bind OVS to the second NUMA node. All device IDs are 80 or higher.
python $DPDK_DIR/usertools/dpdk-devbind.py --bind=igb_uio af:00.0
python $DPDK_DIR/usertools/dpdk-devbind.py --bind=igb_uio af:00.1
python $DPDK_DIR/usertools/dpdk-devbind.py --bind=igb_uio b1:00.0
python $DPDK_DIR/usertools/dpdk-devbind.py --bind=igb_uio b1:00.1

# python $DPDK_DIR/usertools/dpdk-devbind.py --status 


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
$OVS_DIR/ovsdb/ovsdb-tool create /usr/local/etc/openvswitch/conf.db $OVS_DIR/vswitchd/vswitch.ovsschema

#start database server
$OVS_DIR/ovsdb/ovsdb-server --remote=punix:$DB_SOCK \
                 --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
                 --pidfile --detach

#initialize OVS database
$OVS_DIR/utilities/ovs-vsctl --no-wait init


#
# This is for a dual-socket, 20-core hyper-threaded system.
# Cores 0-19 are on NUMA node 0; hyperthreads are 40-59
# Cores 20-39 are on NUMA node 1; hyperthreads are 60-79
#
# This is for a dual vRouter configuration (4 ports) 
# Therefore the PMD mask will include 4 cores and their hyperthreads
#
# Core 20 = lcpu mask (0x100000)
# Core 21,22,23,24,61,62.63,64 = pmd mask (0x0x1E000000001E00000)
# Core 25,26,27,28 = VPP-VM1
# Core 29,30,31,32 = VPP-VM2
#


# Configure OVS with the CPU cores and RAM for the FIRST NUMA node
# $OVS_DIR/utilities/ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true \
# 	other_config:dpdk-lcore-mask=0x2 \ 	# This is core 1, the second core in the first NUMA node
# 	other_config:dpdk-socket-mem="2048,0"		# This assigns 2GB of RAM to the first NUMA node, and none to the second
# $OVS_DIR/vswitchd/ovs-vswitchd unix:$DB_SOCK \
# 	--pidfile \
# 	--detach  \
# 	--log-file=/usr/local/var/log/openvswitch/ovs-vswitchd.log
# $OVS_DIR/utilities/ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=3C000000003C #4C8T -- uses CPUs 2,3,4,5,42,43,44,45
# $OVS_DIR/utilities/ovs-vsctl set Open_vSwitch . other_config:max-idle=30000





# Configure OVS with the CPU cores and RAM for the SECOND NUMA node
$OVS_DIR/utilities/ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true 
$OVS_DIR/utilities/ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-lcore-mask=0x200000  	# This is core 21, the first core in the second NUMA node
$OVS_DIR/utilities/ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-socket-mem="0,2048"		# This assigns 2GB of RAM to the second NUMA node, and none to the first
$OVS_DIR/vswitchd/ovs-vswitchd unix:$DB_SOCK \
	--pidfile \
	--detach  \
	--log-file=/usr/local/var/log/openvswitch/ovs-vswitchd.log
$OVS_DIR/utilities/ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=0xCC00000000CC000000   #4C8T -- uses CPUs 26,27,30,31,66,67,70,71
$OVS_DIR/utilities/ovs-vsctl set Open_vSwitch . other_config:max-idle=30000


#create OVS DPDK Bridge and add the four physical NICs
$OVS_DIR/utilities/ovs-vsctl add-br br0 -- set bridge br0 datapath_type=netdev
ifconfig br0 0 up
$OVS_DIR/utilities/ovs-vsctl add-port br0 dpdk0 -- set Interface dpdk0 type=dpdk options:dpdk-devargs=0000:af:00.0 other_config:pmd-rxq-affinity="0:26"
#sleep 8
$OVS_DIR/utilities/ovs-vsctl add-port br0 dpdk1 -- set Interface dpdk1 type=dpdk options:dpdk-devargs=0000:af:00.1 other_config:pmd-rxq-affinity="0:27"
#sleep 8
$OVS_DIR/utilities/ovs-vsctl add-port br0 dpdk2 -- set Interface dpdk2 type=dpdk options:dpdk-devargs=0000:b1:00.0 other_config:pmd-rxq-affinity="0:30"
#sleep 8
$OVS_DIR/utilities/ovs-vsctl add-port br0 dpdk3 -- set Interface dpdk3 type=dpdk options:dpdk-devargs=0000:b1:00.1 other_config:pmd-rxq-affinity="0:31"
#sleep 8

$OVS_DIR/utilities/ovs-vsctl add-port br0 vhost-user0 -- set Interface vhost-user0 type=dpdkvhostuser other_config:pmd-rxq-affinity="0:66"
$OVS_DIR/utilities/ovs-vsctl add-port br0 vhost-user1 -- set Interface vhost-user1 type=dpdkvhostuser other_config:pmd-rxq-affinity="0:67"
$OVS_DIR/utilities/ovs-vsctl add-port br0 vhost-user2 -- set Interface vhost-user2 type=dpdkvhostuser other_config:pmd-rxq-affinity="0:70"
$OVS_DIR/utilities/ovs-vsctl add-port br0 vhost-user3 -- set Interface vhost-user3 type=dpdkvhostuser other_config:pmd-rxq-affinity="0:71"

$OVS_DIR/utilities/ovs-vsctl show
$OVS_DIR/utilities/ovs-appctl dpif-netdev/pmd-rxq-show
#$OVS_DIR/utilities/ovs-ofctl del-flows br0

# $OVS_DIR/utilities/ovs-ofctl add-flow br0 in_port=1,dl_type=0x800,idle_timeout=0,action=output:5
# $OVS_DIR/utilities/ovs-ofctl add-flow br0 in_port=2,dl_type=0x800,idle_timeout=0,action=output:6
# $OVS_DIR/utilities/ovs-ofctl add-flow br0 in_port=3,dl_type=0x800,idle_timeout=0,action=output:7
# $OVS_DIR/utilities/ovs-ofctl add-flow br0 in_port=4,dl_type=0x800,idle_timeout=0,action=output:8
# 
# $OVS_DIR/utilities/ovs-ofctl add-flow br0 in_port=5,dl_type=0x800,idle_timeout=0,action=output:1
# $OVS_DIR/utilities/ovs-ofctl add-flow br0 in_port=6,dl_type=0x800,idle_timeout=0,action=output:2
# $OVS_DIR/utilities/ovs-ofctl add-flow br0 in_port=7,dl_type=0x800,idle_timeout=0,action=output:3
# $OVS_DIR/utilities/ovs-ofctl add-flow br0 in_port=8,dl_type=0x800,idle_timeout=0,action=output:4

$OVS_DIR/utilities/ovs-ofctl add-flow br0 in_port=1,dl_type=0x800,nw_dst=16.0.0.0/8,idle_timeout=0,action=output:5
$OVS_DIR/utilities/ovs-ofctl add-flow br0 in_port=2,dl_type=0x800,nw_dst=24.0.0.0/8,idle_timeout=0,action=output:6
$OVS_DIR/utilities/ovs-ofctl add-flow br0 in_port=3,dl_type=0x800,nw_dst=32.0.0.0/8,idle_timeout=0,action=output:7
$OVS_DIR/utilities/ovs-ofctl add-flow br0 in_port=4,dl_type=0x800,nw_dst=48.0.0.0/8,idle_timeout=0,action=output:8

$OVS_DIR/utilities/ovs-ofctl add-flow br0 in_port=5,dl_type=0x800,nw_dst=24.0.0.0/8,idle_timeout=0,action=output:1
$OVS_DIR/utilities/ovs-ofctl add-flow br0 in_port=6,dl_type=0x800,nw_dst=16.0.0.0/8,idle_timeout=0,action=output:2
$OVS_DIR/utilities/ovs-ofctl add-flow br0 in_port=7,dl_type=0x800,nw_dst=48.0.0.0/8,idle_timeout=0,action=output:3
$OVS_DIR/utilities/ovs-ofctl add-flow br0 in_port=8,dl_type=0x800,nw_dst=32.0.0.0/8,idle_timeout=0,action=output:4

$OVS_DIR/utilities/ovs-ofctl dump-flows br0
 


echo
echo "Done"
echo
