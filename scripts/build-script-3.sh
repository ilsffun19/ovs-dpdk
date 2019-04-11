#!/bin/sh

cd /root/ovs-dpdk/source
echo
echo "Installing DPDK 17.11.4..."
tar xvf dpdk-17.11.4.tar.xz
ln -rs -v dpdk-stable-17.11.4 /root/ovs-dpdk/dpdk
/root/ovs-dpdk/scripts/compile_dpdk.sh 
echo
echo "Done"
echo
echo "Installing OVS-2.10.1..."
tar xvf openvswitch-2.10.1.tar.gz
ln -rs -v openvswitch-2.10.1 /root/ovs-dpdk/ovs
/root/ovs-dpdk/scripts/compile_ovs.sh 
echo
echo "Done"
echo
echo " Installing qemu-2.12.1..."
tar xvf qemu-2.12.1.tar.xz
ln -rs -v qemu-2.12.1 /root/ovs-dpdk/qemu
/root/ovs-dpdk/scripts/compile_qemu.sh
echo
echo "Done"
echo
echo " Installing TREX-2.53..."
tar xvf trex-v2.53.tgz trex-v2.53
mv trex-v2.53 /opt
ln -rs -v /opt/trex-v2.53 /root/ovs-dpdk/trex
echo
echo "Done"
echo


