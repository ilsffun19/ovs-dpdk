#!/bin/sh

vm=/root/ovs-dpdk/vm-images/ubuntu-16.04-testpmd1.img  
vm_name=UbuntuVM-1
vnc=1

if [ ! -f $vm ];
then
    echo "VM $vm not found!"
else
    echo "VM $vm started! VNC: $vnc, ssh port: 2024"
    taskset -c 8-10 /root/ovs-dpdk/qemu-2.12.1/x86_64-softmmu/qemu-system-x86_64 -m 4G -smp 3,cores=3,threads=1,sockets=1 -cpu host -hda $vm  -boot c -enable-kvm -name $vm_name \
-object memory-backend-file,id=mem,size=4G,mem-path=/dev/hugepages,share=on -numa node,memdev=mem -mem-prealloc \
-netdev user,id=nttsip,hostfwd=tcp::2024-:22 \
-device e1000,netdev=nttsip \
-chardev socket,id=char1,path=/usr/local/var/run/openvswitch/vhost-user0 \
-netdev type=vhost-user,id=net1,chardev=char1,vhostforce -device virtio-net-pci,netdev=net1,mac=00:01:00:00:00:01,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char2,path=/usr/local/var/run/openvswitch/vhost-user1 \
-netdev type=vhost-user,id=net2,chardev=char2,vhostforce -device virtio-net-pci,netdev=net2,mac=00:02:00:00:00:02,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-vnc :$vnc &
fi
