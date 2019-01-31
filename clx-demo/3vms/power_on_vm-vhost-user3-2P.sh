#!/bin/sh

vm=/root/vm-images/ubuntu-16.04-vpp3.img
vm_name=VPP-VM3
vnc=3
echo "ssh 2025"
echo "vnc $vnc"
if [ ! -f $vm ];
then
    echo "VM $vm not found!"
else
    echo "VM $vm started! VNC: $vnc, ssh port: 25"
    taskset -c 36-39  /root/ovs-dpdk/qemu-2.12.1/x86_64-softmmu/qemu-system-x86_64 -m 8G -smp 4,cores=4,threads=1,sockets=1 -cpu host -drive format=raw,file=$vm  -boot c -enable-kvm -name $vm_name \
-object memory-backend-file,id=mem,size=8G,mem-path=/dev/hugepages,share=on -numa node,memdev=mem -mem-prealloc \
-netdev user,id=nttsip,hostfwd=tcp::2025-:22 \
-device e1000,netdev=nttsip \
-chardev socket,id=char5,path=/usr/local/var/run/openvswitch/vhost-user4 \
-netdev type=vhost-user,id=net5,chardev=char5,vhostforce -device virtio-net-pci,netdev=net5,mac=00:05:00:00:00:05,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char6,path=/usr/local/var/run/openvswitch/vhost-user5 \
-netdev type=vhost-user,id=net6,chardev=char6,vhostforce -device virtio-net-pci,netdev=net6,mac=00:06:00:00:00:06,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-vnc :$vnc &
fi
