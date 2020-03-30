mkdir -p /root/ovs-dpdk/
cd /root/ovs-dpdk  
echo "Installing DPDK 18.11.6 ..."
wget https://fast.dpdk.org/rel/dpdk-18.11.6.tar.xz
tar xvf dpdk-18.11.6.tar.xz
ln -rs -v dpdk-stable-18.11.6 dpdk
./compile_dpdk.sh 
echo "Done"
echo "Installing OVS-2.12.0..."
wget https://www.openvswitch.org/releases/openvswitch-2.12.0.tar.gz
tar xvf openvswitch-2.12.0.tar.gz
ln -rs -v openvswitch-2.12.0 ovs
./compile_ovs.sh 
echo "Done"
echo " Installing qemu-4.2.0..."
wget https://download.qemu.org/qemu-4.2.0.tar.xz
tar xvf qemu-4.2.0.tar.xz
./compile_qemu.sh
echo "Done"
echo "Please run start-ovs-dpdk.sh in ovs-script to start OVS-DPDK"

