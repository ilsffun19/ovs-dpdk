cd /root/ovs


#create OVS DPDK Bridge and add the two physical NICs
./utilities/ovs-vsctl add-br br0 -- set bridge br0 datapath_type=netdev
ifconfig br0 0 up
./utilities/ovs-vsctl add-port br0 dpdk0 -- set Interface dpdk0 type=dpdk options:dpdk-devargs=0000:af:00.0 
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk1 -- set Interface dpdk1 type=dpdk options:dpdk-devargs=0000:af:00.1 
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk2 -- set Interface dpdk2 type=dpdk options:dpdk-devargs=0000:af:00.2 
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk3 -- set Interface dpdk3 type=dpdk options:dpdk-devargs=0000:af:00.3 
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk4 -- set Interface dpdk4 type=dpdk options:dpdk-devargs=0000:d8:00.0 
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk5 -- set Interface dpdk5 type=dpdk options:dpdk-devargs=0000:d8:00.1 
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk6 -- set Interface dpdk6 type=dpdk options:dpdk-devargs=0000:d8:00.2 
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk7 -- set Interface dpdk7 type=dpdk options:dpdk-devargs=0000:d8:00.3 
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk8 -- set Interface dpdk8 type=dpdk options:dpdk-devargs=0000:da:00.0 
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk9 -- set Interface dpdk9 type=dpdk options:dpdk-devargs=0000:da:00.1 
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk10 -- set Interface dpdk10 type=dpdk options:dpdk-devargs=0000:da:00.2 
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk11 -- set Interface dpdk11 type=dpdk options:dpdk-devargs=0000:da:00.3 
sleep 8



./utilities/ovs-vsctl add-port br0 vhost-user0 -- set Interface vhost-user0 type=dpdkvhostuser
./utilities/ovs-vsctl add-port br0 vhost-user1 -- set Interface vhost-user1 type=dpdkvhostuser
./utilities/ovs-vsctl add-port br0 vhost-user2 -- set Interface vhost-user2 type=dpdkvhostuser
./utilities/ovs-vsctl add-port br0 vhost-user3 -- set Interface vhost-user3 type=dpdkvhostuser
./utilities/ovs-vsctl add-port br0 vhost-user4 -- set Interface vhost-user4 type=dpdkvhostuser
./utilities/ovs-vsctl add-port br0 vhost-user5 -- set Interface vhost-user5 type=dpdkvhostuser
./utilities/ovs-vsctl add-port br0 vhost-user6 -- set Interface vhost-user6 type=dpdkvhostuser
./utilities/ovs-vsctl add-port br0 vhost-user7 -- set Interface vhost-user7 type=dpdkvhostuser
./utilities/ovs-vsctl add-port br0 vhost-user8 -- set Interface vhost-user8 type=dpdkvhostuser
./utilities/ovs-vsctl add-port br0 vhost-user9 -- set Interface vhost-user9 type=dpdkvhostuser
./utilities/ovs-vsctl add-port br0 vhost-user10 -- set Interface vhost-user10 type=dpdkvhostuser
./utilities/ovs-vsctl add-port br0 vhost-user11 -- set Interface vhost-user11 type=dpdkvhostuser




./utilities/ovs-vsctl show

