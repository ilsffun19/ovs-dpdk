#Usage:dump-ports.sh <bridge ID>
watch -n1 /root/ovs-dpdk/ovs/utilities/ovs-ofctl dump-ports $1
