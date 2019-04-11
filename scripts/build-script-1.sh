#!/bin/sh

echo
echo "Downloading and upgrading the kernel to 4.20"
cd /tmp/
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.20/linux-headers-4.20.0-042000_4.20.0-042000.201812232030_all.deb
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.20/linux-headers-4.20.0-042000-generic_4.20.0-042000.201812232030_amd64.deb
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.20/linux-image-unsigned-4.20.0-042000-generic_4.20.0-042000.201812232030_amd64.deb
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.20/linux-modules-4.20.0-042000-generic_4.20.0-042000.201812232030_amd64.deb
sudo dpkg -i *.deb
echo
echo "Done"
echo
echo "Disabling Surprise Upgrades (messes with TREX)"
apt-get remove unattended-upgrades
echo
echo "Done"
echo
echo
echo "Downloading additional software packages"
apt-get install -y curl
apt-get install -y tmux
echo
echo "Done"
echo
echo "Setting up the GRUB boot loader"
cd
cp -f /root/ovs-dpdk/source/grub /etc/default/grub
update-grub
echo
echo "Done"
echo
echo
echo "You must reboot to complete the changes."
echo "===> Type 'init 6' and press ENTER."
echo
