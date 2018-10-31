#Usage: dump-flows.sh <bridge ID>
watch -n1 /root/ovs-dpdk/ovs/utilities/ovs-ofctl dump-flows $1
