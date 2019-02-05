cd /root/ovs-dpdk/ovs


#create OVS DPDK Bridge and add the two physical NICs
./utilities/ovs-vsctl add-br br0 -- set bridge br0 datapath_type=netdev
ifconfig br0 0 up
./utilities/ovs-vsctl add-port br0 dpdk0 -- set Interface dpdk0 type=dpdk options:dpdk-devargs=0000:18:00.0 other_config:pmd-rxq-affinity="0:2"
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk1 -- set Interface dpdk1 type=dpdk options:dpdk-devargs=0000:18:00.1 other_config:pmd-rxq-affinity="0:3"
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk2 -- set Interface dpdk2 type=dpdk options:dpdk-devargs=0000:18:00.2 other_config:pmd-rxq-affinity="0:4"
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk3 -- set Interface dpdk3 type=dpdk options:dpdk-devargs=0000:18:00.3 other_config:pmd-rxq-affinity="0:5"
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk4 -- set Interface dpdk4 type=dpdk options:dpdk-devargs=0000:5e:00.0 other_config:pmd-rxq-affinity="0:6"
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk5 -- set Interface dpdk5 type=dpdk options:dpdk-devargs=0000:5e:00.1 other_config:pmd-rxq-affinity="0:7"
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk6 -- set Interface dpdk6 type=dpdk options:dpdk-devargs=0000:5e:00.2 other_config:pmd-rxq-affinity="0:42"
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk7 -- set Interface dpdk7 type=dpdk options:dpdk-devargs=0000:5e:00.3 other_config:pmd-rxq-affinity="0:43"
sleep 8



./utilities/ovs-vsctl add-port br0 vhost-user0 -- set Interface vhost-user0 type=dpdkvhostuser other_config:pmd-rxq-affinity="0:42"
./utilities/ovs-vsctl add-port br0 vhost-user1 -- set Interface vhost-user1 type=dpdkvhostuser other_config:pmd-rxq-affinity="0:43"
./utilities/ovs-vsctl add-port br0 vhost-user2 -- set Interface vhost-user2 type=dpdkvhostuser other_config:pmd-rxq-affinity="0:44"
./utilities/ovs-vsctl add-port br0 vhost-user3 -- set Interface vhost-user3 type=dpdkvhostuser other_config:pmd-rxq-affinity="0:45"
./utilities/ovs-vsctl add-port br0 vhost-user4 -- set Interface vhost-user4 type=dpdkvhostuser other_config:pmd-rxq-affinity="0:46"
./utilities/ovs-vsctl add-port br0 vhost-user5 -- set Interface vhost-user5 type=dpdkvhostuser other_config:pmd-rxq-affinity="0:47"
./utilities/ovs-vsctl add-port br0 vhost-user6 -- set Interface vhost-user6 type=dpdkvhostuser other_config:pmd-rxq-affinity="0:2"
./utilities/ovs-vsctl add-port br0 vhost-user7 -- set Interface vhost-user7 type=dpdkvhostuser other_config:pmd-rxq-affinity="0:3"




./utilities/ovs-vsctl show

