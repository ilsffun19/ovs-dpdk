cd /root/ovs-dpdk/qemu/
apt-get install -y  libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev
./configure --target-list=x86_64-softmmu
make -j10

