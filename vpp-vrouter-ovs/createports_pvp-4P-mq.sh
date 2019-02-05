cd /root/ovs-dpdk/ovs


#create OVS DPDK Bridge and add the two physical NICs
./utilities/ovs-vsctl add-br br0 -- set bridge br0 datapath_type=netdev
ifconfig br0 0 up
./utilities/ovs-vsctl add-port br0 dpdk0 -- set Interface dpdk0 type=dpdk options:dpdk-devargs=0000:18:00.0 options:n_rxq=2 other_config:pmd-rxq-affinity="0:2,1:6"
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk1 -- set Interface dpdk1 type=dpdk options:dpdk-devargs=0000:18:00.1 options:n_rxq=2 other_config:pmd-rxq-affinity="0:3,1:7"
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk2 -- set Interface dpdk2 type=dpdk options:dpdk-devargs=0000:18:00.2 options:n_rxq=2 other_config:pmd-rxq-affinity="0:4,1:6"
sleep 8
./utilities/ovs-vsctl add-port br0 dpdk3 -- set Interface dpdk3 type=dpdk options:dpdk-devargs=0000:18:00.3 options:n_rxq=2 other_config:pmd-rxq-affinity="0:5,1:7"
sleep 8



./utilities/ovs-vsctl add-port br0 vhost-user0 -- set Interface vhost-user0 type=dpdkvhostuser options:n_rxq=2 other_config:pmd-rxq-affinity="0:42,1:46"
./utilities/ovs-vsctl add-port br0 vhost-user1 -- set Interface vhost-user1 type=dpdkvhostuser options:n_rxq=2 other_config:pmd-rxq-affinity="0:43,1:47"
./utilities/ovs-vsctl add-port br0 vhost-user2 -- set Interface vhost-user2 type=dpdkvhostuser options:n_rxq=2 other_config:pmd-rxq-affinity="0:44,1:46"
./utilities/ovs-vsctl add-port br0 vhost-user3 -- set Interface vhost-user3 type=dpdkvhostuser options:n_rxq=2 other_config:pmd-rxq-affinity="0:45,1:47"




./utilities/ovs-vsctl show

