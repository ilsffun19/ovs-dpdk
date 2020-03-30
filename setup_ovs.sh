mkdir -p /root/ovs-dpdk/
cd /root/ovs-dpdk  
echo "Installing DPDK 19.11..."
wget https://fast.dpdk.org/rel/dpdk-19.11.tar.xz
tar xvf dpdk-19.11.tar.xz
ln -rs -v dpdk-stable-19.11 dpdk
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

