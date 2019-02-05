OVS_DIR=/root/ovs-dpdk/ovs

#$OVS_DIR/utilities/ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=fc  #6cores
$OVS_DIR/utilities/ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=3C000000003C #4C8T
#$OVS_DIR/utilities/ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=FC00000000FC  #6C12T cores


$OVS_DIR/utilities/ovs-vsctl set Open_vSwitch . other_config:max-idle=30000

