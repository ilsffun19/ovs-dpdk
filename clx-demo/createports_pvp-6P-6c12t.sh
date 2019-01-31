cd /root/ovs-dpdk/ovs


#create OVS DPDK Bridge and add the two physical NICs
./utilities/ovs-vsctl add-br br0 -- set bridge br0 datapath_type=netdev
ifconfig br0 0 up
./utilities/ovs-vsctl add-port br0 dpdk0 -- set Interface dpdk0 type=dpdk ofport_request=1 options:dpdk-devargs=0000:86:00.0 other_config:pmd-rxq-affinity="0:26"
sleep 3
./utilities/ovs-vsctl add-port br0 dpdk1 -- set Interface dpdk1 type=dpdk ofport_request=2 options:dpdk-devargs=0000:88:00.0 other_config:pmd-rxq-affinity="0:27"
sleep 3
./utilities/ovs-vsctl add-port br0 dpdk2 -- set Interface dpdk2 type=dpdk ofport_request=3 options:dpdk-devargs=0000:af:00.0 other_config:pmd-rxq-affinity="0:31"
sleep 3
./utilities/ovs-vsctl add-port br0 dpdk3 -- set Interface dpdk3 type=dpdk ofport_request=4 options:dpdk-devargs=0000:b1:00.0 other_config:pmd-rxq-affinity="0:33"
sleep 3
./utilities/ovs-vsctl add-port br0 dpdk4 -- set Interface dpdk4 type=dpdk ofport_request=5 options:dpdk-devargs=0000:d8:00.0 other_config:pmd-rxq-affinity="0:34"
sleep 3
./utilities/ovs-vsctl add-port br0 dpdk5 -- set Interface dpdk5 type=dpdk ofport_request=6 options:dpdk-devargs=0000:da:00.0 other_config:pmd-rxq-affinity="0:35"
sleep 3


./utilities/ovs-vsctl add-port br0 vhost-user0 -- set Interface vhost-user0 type=dpdkvhostuser ofport_request=7 other_config:pmd-rxq-affinity="0:66"
./utilities/ovs-vsctl add-port br0 vhost-user1 -- set Interface vhost-user1 type=dpdkvhostuser ofport_request=8 other_config:pmd-rxq-affinity="0:67"
./utilities/ovs-vsctl add-port br0 vhost-user2 -- set Interface vhost-user2 type=dpdkvhostuser ofport_request=9 other_config:pmd-rxq-affinity="0:71"
./utilities/ovs-vsctl add-port br0 vhost-user3 -- set Interface vhost-user3 type=dpdkvhostuser ofport_request=10 other_config:pmd-rxq-affinity="0:73"
./utilities/ovs-vsctl add-port br0 vhost-user4 -- set Interface vhost-user4 type=dpdkvhostuser ofport_request=11 other_config:pmd-rxq-affinity="0:74"
./utilities/ovs-vsctl add-port br0 vhost-user5 -- set Interface vhost-user5 type=dpdkvhostuser ofport_request=12 other_config:pmd-rxq-affinity="0:75"




./utilities/ovs-vsctl show

