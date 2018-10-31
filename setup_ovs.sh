
cd /root/ovs-dpdk  
echo "Installing DPDK 17.11.4..."
tar xvf dpdk-17.11.4.tar.xz
ln -rs -v dpdk-stable-17.11.4 dpdk
./compile_dpdk.sh 
echo "Done"
echo "Installing OVS-2.10.1..."
tar xvf openvswitch-2.10.1.tar.gz
ln -rs -v openvswitch-2.10.1 ovs
./compile_ovs.sh 
echo "Done"
echo " Installing qemu-2.12.1..."
tar xvf qemu-2.12.1.tar.xz
./compile_qemu.sh
echo "Done"
echo "Please run start-ovs-dpdk.sh in ovs-script to start OVS-DPDK"

