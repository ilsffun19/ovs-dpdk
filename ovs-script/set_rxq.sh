#set core assignment for ports in OVS bridge
#$1 = interface name e.g. dpdk0, vhost-user0
#$2 = core ID to affinitize the port to e.g. core 2
/root/ovs-dpdk/ovs/utilities/ovs-vsctl set Interface "$1" other_config:pmd-rxq-affinity="0:$2"
