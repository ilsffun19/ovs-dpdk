apt-get install python-six autoconf automake
cd /root/ovs-dpdk/ovs
./boot.sh
./configure --with-dpdk=/root/ovs-dpdk/dpdk/x86_64-native-linuxapp-gcc CFLAGS="-Ofast" --disable-ssl
make CFLAGS="-Ofast -march=native" -j3

