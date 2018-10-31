cd /root/ovs-dpdk/dpdk
make install T=x86_64-native-linuxapp-gcc DESTDIR=install
sleep 2
cd x86_64-native-linuxapp-gcc 
EXTRA_CFLAGS="-Ofast" make -j3

