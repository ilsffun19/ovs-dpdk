#set core assignment for ports in OVS-DPDK
/root/ovs-dpdk/ovs/utilities/ovs-vsctl set Interface "$1" other_config:pmd-rxq-affinity="$2:$3"
