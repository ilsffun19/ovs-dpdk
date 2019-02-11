import os
from trex_stl_lib.api import *

# PCAP profile
class STLPcap(object):

    def __init__ (self, pcap_file):
        self.pcap_file = pcap_file

    def create_vm (self, ip_src_range, ip_dst_range):
        if not ip_src_range and not ip_dst_range:
            return None

        vm = STLVM()

        if ip_src_range:
            vm.var(name="src", min_value = ip_src_range['start'], max_value = ip_src_range['end'], size = 4, op = "inc")
            vm.write(fv_name="src",pkt_offset= "IP.src")
            
        if ip_dst_range:
            vm.var(name="dst", min_value = ip_dst_range['start'], max_value = ip_dst_range['end'], size = 4, op = "inc")
            vm.write(fv_name="dst",pkt_offset = 30)

        vm.fix_chksum()
        

        return vm


    def get_streams (self,
                     direction = 0,
                     ipg_usec = 10.0,
                     loop_count = 5,
                     ip_src_range = None,
                     ip_dst_range = {'start' : '16.0.0.1', 'end': '16.0.0.254'},
                     **kwargs):

        vm = self.create_vm(ip_src_range, ip_dst_range)

        profile = STLProfile.load_pcap(self.pcap_file,
                                       ipg_usec = ipg_usec,
                                       loop_count = loop_count,
                                       vm = vm)

        return profile.get_streams()



# dynamic load - used for trex console or simulator
def register():
    # get file relative to profile dir
    return STLPcap(os.path.join(os.path.dirname(__file__), 'sample.pcap'))



