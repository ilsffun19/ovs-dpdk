export OVS_DIR=/root/ovs-dpdk/ovs

cd $OVS_DIR
./utilities/ovs-ofctl del-flows br0
 
# Add Flow for bi-directional traffic
./utilities/ovs-ofctl add-flow br0 in_port=1,dl_type=0x800,idle_timeout=0,action=output:2
./utilities/ovs-ofctl add-flow br0 in_port=2,dl_type=0x800,idle_timeout=0,action=output:1


./utilities/ovs-ofctl dump-flows br0

 
