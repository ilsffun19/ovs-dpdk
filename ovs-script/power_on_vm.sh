#!/bin/sh

vm=/mnt/nvme/ovs-dpdk/vm-images/ubuntu-16.04-testpmd.img  
vm_name=UbuntuVM-1
vnc=21

if [ ! -f $vm ];
then
    echo "VM $vm not found!"
else
    echo "VM $vm started! VNC: $vnc, ssh port: 2034"
    taskset -c 8-10 /root/ovs-dpdk/qemu-2.12.1/x86_64-softmmu/qemu-system-x86_64 -m 4G -smp 3,cores=3,threads=1,sockets=1 -cpu host -drive format=raw,file=$vm  -boot c -enable-kvm -name $vm_name \
-object memory-backend-file,id=mem,size=4G,mem-path=/dev/hugepages,share=on -numa node,memdev=mem -mem-prealloc \
-netdev user,id=nttsip,hostfwd=tcp::2034-:22 \
-device e1000,netdev=nttsip \
-vnc :$vnc &
fi
