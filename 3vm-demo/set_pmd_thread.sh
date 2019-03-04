OVS_DIR=/root/ovs-dpdk/ovs

#OVS_DIR/utilities/ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=8B81  #6C6T
#$OVS_DIR/utilities/ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=3C000000003C #4C8T
#$OVS_DIR/utilities/ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=8B810000008B81 #6C12T cores

$OVS_DIR/utilities/ovs-vsctl set Open_vSwitch . other_config:pmd-cpu-mask=E8C0000000E8C000000 #6C12T cores



$OVS_DIR/utilities/ovs-vsctl set Open_vSwitch . other_config:max-idle=30000

