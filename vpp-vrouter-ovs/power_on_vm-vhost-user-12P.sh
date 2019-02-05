#!/bin/sh

vm=/root/vm-images/vyatta-1801-ovs-vm.qcow2
vm_name=Vyatta-VM1
vnc=1
echo "ssh 2023"
echo "vnc $vnc"
if [ ! -f $vm ];
then
    echo "VM $vm not found!"
else
    echo "VM $vm started! VNC: $vnc, ssh port: 23"
    numactl -C 42-54 -m 1 /root/qemu-2.12.0/x86_64-softmmu/qemu-system-x86_64 -m 16G -smp 13,cores=13,threads=1,sockets=1 -cpu host -drive format=qcow2,file=$vm  -boot c -enable-kvm -name $vm_name \
-object memory-backend-file,id=mem,size=16G,mem-path=/dev/hugepages,share=on -numa node,memdev=mem -mem-prealloc \
-netdev user,id=nttsip,hostfwd=tcp::2023-:22 \
-device e1000,netdev=nttsip \
-chardev socket,id=char1,path=/usr/local/var/run/openvswitch/vhost-user0 \
-netdev type=vhost-user,id=net1,chardev=char1,vhostforce -device virtio-net-pci,netdev=net1,mac=00:01:00:00:00:01,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char2,path=/usr/local/var/run/openvswitch/vhost-user1 \
-netdev type=vhost-user,id=net2,chardev=char2,vhostforce -device virtio-net-pci,netdev=net2,mac=00:02:00:00:00:02,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char3,path=/usr/local/var/run/openvswitch/vhost-user2 \
-netdev type=vhost-user,id=net3,chardev=char3,vhostforce -device virtio-net-pci,netdev=net3,mac=00:03:00:00:00:03,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char4,path=/usr/local/var/run/openvswitch/vhost-user3 \
-netdev type=vhost-user,id=net4,chardev=char4,vhostforce -device virtio-net-pci,netdev=net4,mac=00:04:00:00:00:04,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char5,path=/usr/local/var/run/openvswitch/vhost-user4 \
-netdev type=vhost-user,id=net5,chardev=char5,vhostforce -device virtio-net-pci,netdev=net5,mac=00:05:00:00:00:05,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char6,path=/usr/local/var/run/openvswitch/vhost-user5 \
-netdev type=vhost-user,id=net6,chardev=char6,vhostforce -device virtio-net-pci,netdev=net6,mac=00:06:00:00:00:06,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char7,path=/usr/local/var/run/openvswitch/vhost-user6 \
-netdev type=vhost-user,id=net7,chardev=char7,vhostforce -device virtio-net-pci,netdev=net7,mac=00:07:00:00:00:07,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char8,path=/usr/local/var/run/openvswitch/vhost-user7 \
-netdev type=vhost-user,id=net8,chardev=char8,vhostforce -device virtio-net-pci,netdev=net8,mac=00:08:00:00:00:08,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char9,path=/usr/local/var/run/openvswitch/vhost-user8 \
-netdev type=vhost-user,id=net9,chardev=char9,vhostforce -device virtio-net-pci,netdev=net9,mac=00:09:00:00:00:09,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char10,path=/usr/local/var/run/openvswitch/vhost-user9 \
-netdev type=vhost-user,id=net10,chardev=char10,vhostforce -device virtio-net-pci,netdev=net10,mac=00:10:00:00:00:10,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char11,path=/usr/local/var/run/openvswitch/vhost-user10 \
-netdev type=vhost-user,id=net11,chardev=char11,vhostforce -device virtio-net-pci,netdev=net11,mac=00:11:00:00:00:11,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-chardev socket,id=char12,path=/usr/local/var/run/openvswitch/vhost-user11 \
-netdev type=vhost-user,id=net12,chardev=char12,vhostforce -device virtio-net-pci,netdev=net12,mac=00:12:00:00:00:12,csum=off,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,mrg_rxbuf=off \
-vnc :$vnc &
fi
