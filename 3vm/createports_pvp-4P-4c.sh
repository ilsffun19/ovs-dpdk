cd /root/ovs-dpdk/ovs


#create OVS DPDK Bridge and add the two physical NICs
./utilities/ovs-vsctl add-br br0 -- set bridge br0 datapath_type=netdev
ifconfig br0 0 up
./utilities/ovs-vsctl add-port br0 dpdk0 -- set Interface dpdk0 type=dpdk ofport_request=1 options:dpdk-devargs=0000:18:00.0 other_config:pmd-rxq-affinity="0:2"
sleep 3
./utilities/ovs-vsctl add-port br0 dpdk1 -- set Interface dpdk1 type=dpdk ofport_request=2 options:dpdk-devargs=0000:18:00.1 other_config:pmd-rxq-affinity="0:3"
sleep 3
./utilities/ovs-vsctl add-port br0 dpdk2 -- set Interface dpdk2 type=dpdk ofport_request=3 options:dpdk-devargs=0000:18:00.2 other_config:pmd-rxq-affinity="0:4"
sleep 3
./utilities/ovs-vsctl add-port br0 dpdk3 -- set Interface dpdk3 type=dpdk ofport_request=4 options:dpdk-devargs=0000:18:00.3 other_config:pmd-rxq-affinity="0:5"
sleep 3



./utilities/ovs-vsctl add-port br0 vhost-user0 -- set Interface vhost-user0 type=dpdkvhostuser ofport_request=5 other_config:pmd-rxq-affinity="0:42"
./utilities/ovs-vsctl add-port br0 vhost-user1 -- set Interface vhost-user1 type=dpdkvhostuser ofport_request=6 other_config:pmd-rxq-affinity="0:43"
./utilities/ovs-vsctl add-port br0 vhost-user2 -- set Interface vhost-user2 type=dpdkvhostuser ofport_request=7 other_config:pmd-rxq-affinity="0:44"
./utilities/ovs-vsctl add-port br0 vhost-user3 -- set Interface vhost-user3 type=dpdkvhostuser ofport_request=8 other_config:pmd-rxq-affinity="0:45"




./utilities/ovs-vsctl show

