#This file is used to create ports to the ovs bridge 
cd /root/ovs-dpdk/ovs



#Edit the PCI ID NIC ports which you want to add to the OVS bridge.
#Create OVS DPDK Bridge and add the two physical NICs
./utilities/ovs-vsctl add-br br0 -- set bridge br0 datapath_type=netdev
ifconfig br0 0 up
./utilities/ovs-vsctl add-port br0 dpdk0 -- set Interface dpdk0 type=dpdk options:dpdk-devargs=0000:d8:00.0 ofport_request=1 
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk1 -- set Interface dpdk1 type=dpdk options:dpdk-devargs=0000:da:00.0 ofport_request=2
sleep 8

#Create vhost-user interfaces 
./utilities/ovs-vsctl add-port br0 vhost-user0 -- set Interface vhost-user0 type=dpdkvhostuser ofport_request=3
./utilities/ovs-vsctl add-port br0 vhost-user1 -- set Interface vhost-user1 type=dpdkvhostuser ofport_request=4


./utilities/ovs-vsctl show

