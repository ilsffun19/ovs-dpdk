export OVS_DIR=/root/ovs-dpdk/ovs

cd $OVS_DIR
#./utilities/ovs-ofctl del-flows br0
 
# Add Flow for port 0 to port 1 and port 1 to port 0 
./utilities/ovs-ofctl add-flow br0 in_port=1,dl_type=0x800,idle_timeout=0,action=output:7
./utilities/ovs-ofctl add-flow br0 in_port=2,dl_type=0x800,idle_timeout=0,action=output:8
./utilities/ovs-ofctl add-flow br0 in_port=3,dl_type=0x800,idle_timeout=0,action=output:9
./utilities/ovs-ofctl add-flow br0 in_port=4,dl_type=0x800,idle_timeout=0,action=output:10
./utilities/ovs-ofctl add-flow br0 in_port=5,dl_type=0x800,idle_timeout=0,action=output:11
./utilities/ovs-ofctl add-flow br0 in_port=6,dl_type=0x800,idle_timeout=0,action=output:12

./utilities/ovs-ofctl add-flow br0 in_port=7,dl_type=0x800,idle_timeout=0,action=output:1
./utilities/ovs-ofctl add-flow br0 in_port=8,dl_type=0x800,idle_timeout=0,action=output:2
./utilities/ovs-ofctl add-flow br0 in_port=9,dl_type=0x800,idle_timeout=0,action=output:3
./utilities/ovs-ofctl add-flow br0 in_port=10,dl_type=0x800,idle_timeout=0,action=output:4
./utilities/ovs-ofctl add-flow br0 in_port=11,dl_type=0x800,idle_timeout=0,action=output:5
./utilities/ovs-ofctl add-flow br0 in_port=12,dl_type=0x800,idle_timeout=0,action=output:6

./utilities/ovs-ofctl dump-flows br0

 
