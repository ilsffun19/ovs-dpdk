OVS_DIR=/root/ovs-dpdk/ovs
echo "Set OVS PMD affinity cores (in hex): "

$OVS_DIR/utilities/ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=$1


$OVS_DIR/utilities/ovs-vsctl set Open_vSwitch . other_config:max-idle=30000
echo "OVS PMD cores configured: "$1

