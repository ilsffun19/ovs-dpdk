cd /root/ovs-dpdk/qemu-2.12.1/
apt-get install -y  libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev
./configure --target-list=x86_64-softmmu
make -j10

