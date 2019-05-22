For the first time to run OVS-DPDK, please go to Step 1 and Step 2:

1) Download/Clone the git ovs-dpdk folder to /root
2) Run setup_ovs.sh to install DPDK, OVS and QEMU KVM
3) Edit you GRUB boot command parameter to include 1G hugepages, core
isolation and other kernel tuning. Then update the GRUB bootloader and reboot
the system.

default_hugepagesz=1G hugepagesz=1G hugepages=32 isolcpus=1-128 rcu_nocbs=1-128 intel_pstate=disable nmi_watchdog=0 audit=0 nosoftlockup processor.max_cstate=1 intel_idle.max_cstate=1 hpet=disable mce=off tsc=reliable numa_balancing=disable

If you have installed OVS-DPDK, go to Step 3 onwards:

3) Run lspci |grep Ethernet to check the PCI ID devices which you want to bind
to OVS-DPDK 
4) Go to ovs-script folder. Edit start-ovs-dpdk.sh file to include the Ethernet PCI ID devices you want
to bind to OVS-DPDK. In the same file, check where is your PCI devices located
(either in socket 0 or socket 1), and then edit the core assignment of the
ovs-vswitchd. By default, it has been set to core 1 (in socket 0). Save the
file.
Save the start-ovs-dpdk.sh file and then run start-ovs-dpdk.sh to start OVS-DPDK.



To run Phy-VM-Phy (PVP):

5) In ovs-script folder, run createports_pvp-2p.sh to configure 2 dpdk
physical ports with 2 vhost-user interfaces.
6) To check the OVS PMD core assignment, run check_pmd_cores.sh
7) To change the OVS PMD core assignment for the dpdk and vhost-user
interfaces, run set_rxq.sh
8)On the host, run addroutes_pvp-2p.sh to setup the flow 
9) Download the VM image at: https://drive.google.com/file/d/1zoyF7KD594fr-1SBdDMgxR9P1fKJ23NJ/view?usp=sharing
Create vm-images folder in ovs-dpdk. Pls download the ubuntu-16.04-testpmd.img file to ovs-dpdk/vm-images folder.
10) Edit the power_on_vm-vhost-user1-2p.sh to make sure all the info is correct.
11) Run power_on_vm-vhost-user1-2p.sh to power on the VM
12) Run vncviewer <host address>:1 to access to the VM
13) Once VM is booted, you would be able to remote access to the VM from the
host via ssh -l root localhost -p 2024
14) Credential of the VM is: root/passme123
15) Run run_testpmd.sh in the VM to start testpmd
16) Once testpmd is running, type:
set fwd mac
start

17) Generate traffic from the traffic generator


To run Phy-VM-VM-Phy (PVVP):

5) In ovs-script, run createports_pvvp-2p.sh to create 2 dpdk and 4 vhost-user
interfaces
6) To check the OVS PMD core assignment, run check_pmd_cores.sh
7) To change the OVS PMD core assignment for the dpdk and vhost-user
interfaces, run set_rxq.sh $interface_name $core_id
8)On the host, run addroutes_pvvp-2p.sh to setup the flow
9) Download the VM image at: https://drive.google.com/file/d/1zoyF7KD594fr-1SBdDMgxR9P1fKJ23NJ/view?usp=sharing
Create vm-images folder in ovs-dpdk. Pls download the ubuntu-16.04-testpmd.img file to ovs-dpdk/vm-images folder. Duplicate another ubuntu-16.04-testpmd.img file and rename to ubuntu-16.04-testpmd2.img.
10) Edit the power_on_vm-vhost-user1-2p.sh to make sure all the info is correct.
11) Run power_on_vm-vhost-user1-2p.sh to power on the VM1 and power_on_vm-vhost-user2-2p.sh to power on VM2.
12) Run vncviewer <host address>:1 and vncviewer <host address>:2 to access to VM1 and VM2
13) Once both VMs are booted, you would be able to remote the access to the VMs from the host via:
ssh -l root localhost -p 2024
ssh -l root localhost -p 2025
14) Credential of the VMs are: root/passme123
15) Run run_testpmd.sh in the VM to start DPDK testpmd
16) Once testpmd is running, type:
set fwd mac
start

17) Generate traffic from the traffic generator


