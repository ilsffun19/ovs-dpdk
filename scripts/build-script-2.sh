#!/bin/sh

mkdir /root/ovs-dpdk/vm-images
cd /root/ovs-dpdk/vm-images
echo
echo "Downloading Virtual Router VM image..."
wget https://www.dropbox.com/s/kilwgqg842pnko7/ubuntu-16.04-vpp.img.tgz
echo
echo "Done"
echo
cd /root/ovs-dpdk/source
echo
echo "Downloading source packages..."
wget https://www.dropbox.com/s/rby2eoaj07zoofd/trex-v2.53.tgz
wget https://www.dropbox.com/s/4di68zb133aekfe/openvswitch-2.10.1.tar.gz
wget https://www.dropbox.com/s/1f203kg4ksrsq7w/qemu-2.12.1.tar.xz
wget https://www.dropbox.com/s/fac2plyvwfpuhac/dpdk-17.11.4.tar.xz
echo
echo "Done"
echo


