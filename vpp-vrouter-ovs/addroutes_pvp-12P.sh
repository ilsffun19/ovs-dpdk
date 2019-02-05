export OVS_DIR=/root/ovs

cd $OVS_DIR
#./utilities/ovs-ofctl del-flows br0
 
# Add Flow for port 0 to port 1 and port 1 to port 0 
./utilities/ovs-ofctl add-flow br0 in_port=1,dl_type=0x800,idle_timeout=0,action=output:13
./utilities/ovs-ofctl add-flow br0 in_port=2,dl_type=0x800,idle_timeout=0,action=output:14
./utilities/ovs-ofctl add-flow br0 in_port=3,dl_type=0x800,idle_timeout=0,action=output:15 
./utilities/ovs-ofctl add-flow br0 in_port=4,dl_type=0x800,idle_timeout=0,action=output:16 
./utilities/ovs-ofctl add-flow br0 in_port=5,dl_type=0x800,idle_timeout=0,action=output:17
./utilities/ovs-ofctl add-flow br0 in_port=6,dl_type=0x800,idle_timeout=0,action=output:18
./utilities/ovs-ofctl add-flow br0 in_port=7,dl_type=0x800,idle_timeout=0,action=output:19
./utilities/ovs-ofctl add-flow br0 in_port=8,dl_type=0x800,idle_timeout=0,action=output:20 
./utilities/ovs-ofctl add-flow br0 in_port=9,dl_type=0x800,idle_timeout=0,action=output:21
./utilities/ovs-ofctl add-flow br0 in_port=10,dl_type=0x800,idle_timeout=0,action=output:22
./utilities/ovs-ofctl add-flow br0 in_port=11,dl_type=0x800,idle_timeout=0,action=output:23
./utilities/ovs-ofctl add-flow br0 in_port=12,dl_type=0x800,idle_timeout=0,action=output:24

./utilities/ovs-ofctl add-flow br0 in_port=13,dl_type=0x800,idle_timeout=0,action=output:1
./utilities/ovs-ofctl add-flow br0 in_port=14,dl_type=0x800,idle_timeout=0,action=output:2
./utilities/ovs-ofctl add-flow br0 in_port=15,dl_type=0x800,idle_timeout=0,action=output:3
./utilities/ovs-ofctl add-flow br0 in_port=16,dl_type=0x800,idle_timeout=0,action=output:4
./utilities/ovs-ofctl add-flow br0 in_port=17,dl_type=0x800,idle_timeout=0,action=output:5
./utilities/ovs-ofctl add-flow br0 in_port=18,dl_type=0x800,idle_timeout=0,action=output:6
./utilities/ovs-ofctl add-flow br0 in_port=19,dl_type=0x800,idle_timeout=0,action=output:7
./utilities/ovs-ofctl add-flow br0 in_port=20,dl_type=0x800,idle_timeout=0,action=output:8 
./utilities/ovs-ofctl add-flow br0 in_port=21,dl_type=0x800,idle_timeout=0,action=output:9
./utilities/ovs-ofctl add-flow br0 in_port=22,dl_type=0x800,idle_timeout=0,action=output:10
./utilities/ovs-ofctl add-flow br0 in_port=23,dl_type=0x800,idle_timeout=0,action=output:11
./utilities/ovs-ofctl add-flow br0 in_port=24,dl_type=0x800,idle_timeout=0,action=output:12


./utilities/ovs-ofctl dump-flows br0

 
