#!/usr/bin/python
#

from __future__ import print_function
import os
import sys, getopt
import re
import struct
import multiprocessing

DRV_FILE = "/sys/devices/system/cpu/cpu0/cpufreq/scaling_driver"
BASE_FILE = "/sys/devices/system/cpu/cpu%d/cpufreq/base_frequency"
CPU_MAX_FILE = "/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq"
CPU_MIN_FILE = "/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq"
MAX_FILE = "/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq"
MIN_FILE = "/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq"

driver = ""
cpucount=0


pbf_cores_16 = [ 
	0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,0,
	0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,0,
	0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,0,
	0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,0
]
pbf_cores_20 = [ 
	0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,
	0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,
	0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,
	0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0
]
pbf_cores_24 = [ 
	0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,1,0,1,0,
	0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,1,0,1,0,
	0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,1,0,1,0,
	0,0,1,0,1,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,1,0,1,0
]


# Read a 64-byte value from an MSR through the sysfs interface.
# Returns an 8-byte binary packed string.
def rdmsr(core, msr):
	msr_filename = "/dev/cpu/" + str(core) + "/msr"
	msr_file = os.open(msr_filename, os.O_RDONLY)
	os.lseek(msr_file, msr, os.SEEK_SET)
	regstr = os.read(msr_file, 8)
	return regstr

# Writes a 64-byte value to an MSR through the sysfs interface.
# Expects an 8-byte binary packed string in regstr.
def wrmsr(core, msr, regstr):
        msr_filename = "/dev/cpu/" + str(core) + "/msr"
        msr_file = os.open(msr_filename, os.O_WRONLY)
        os.lseek(msr_file, msr, os.SEEK_SET)
        os.write(msr_file, regstr)

# Set the HWP_REQUEST MSR
def set_hwp_request(core, minimum, maximum, desired, epp):
        regstr = struct.pack('BBBBBBBB', minimum, maximum, desired, epp,0,0,0,0)
        wrmsr(core, 0x774, regstr)


# Read the HWP_REQUEST MSR
def get_hwp_request(core):
        # rdmsr returns 8 bytes of packed binary data
        regstr = rdmsr(core,0x774)
        # Unpack the 8 bytes into array of unsigned chars
        bytes = struct.unpack('BBBBBBBB', regstr)
        minimum = bytes[0]
        maximum = bytes[1]
        desired = bytes[2]
        epp = bytes[3]
        return ( minimum, maximum, desired, epp )


# Read the HWP_ENABLED MSR
def get_hwp_enabled():
        # rdmsr returns 8 bytes of packed binary data
        regstr = rdmsr(0,0x770)
        # Unpack the 8 bytes into array of unsigned chars
        bytes = struct.unpack('BBBBBBBB', regstr)
	enabled = bytes[0]
        return enabled


# Read the TURBO_MODE_ENABLED from package
def get_turbo_disabled():
        # rdmsr returns 8 bytes of packed binary data
        regstr = rdmsr(0,0x1A0)
        # Unpack the 8 bytes into array of unsigned chars
        bytes = struct.unpack('BBBBBBBB', regstr)
	disabled = bytes[4] & 0x40;
        return disabled


# Read the HWP_CAPABILITIES MSR
def get_hwp_capabilities(core):
        # rdmsr returns 8 bytes of packed binary data
        regstr = rdmsr(core,0x771)
        # Unpack the 8 bytes into array of unsigned chars
        bytes = struct.unpack('BBBBBBBB', regstr)
	highest = bytes[0]
        guaranteed = bytes[1]
	lowest = bytes[2]
        return ( highest, guaranteed, lowest )


# Get the CPU base frequencey from the PLATFORM_INFO MSR
def get_cpu_base_frequency():
	regstr = rdmsr(0,0xCE) # MSR_PLATFORM_INFO
	# Unpack the 8 bytes into array of unsigned chars
	bytes = struct.unpack('BBBBBBBB', regstr)
	# Byte 1 contains the max non-turbo frequecy
	P1 = bytes[1]*100
	return P1


def check_driver():
	global driver
	global freq_P1

	try:
		drvFile = open(DRV_FILE,'r')
	except:
		print()
		print("ERROR: No pstate driver file found.")
		print("       Are P-States enabled in the system BIOS?")
		print()
		return 0

	driver = drvFile.readline().strip("\n")
	drvFile.close()
	# TODO does the driver name make any difference?
	if driver == "acpi-cpufreq":
		return 1
	elif driver == "intel_pstate":
		return 1
	else:
		return 1


def set_max_cpu_freq(maxfreq, core):
	maxName = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/scaling_max_freq"
	print("Writing " + str(maxfreq) + " to " + maxName)
	maxFile = open(maxName,'w')
	maxFile.write(str(maxfreq))
	maxFile.close()


def set_min_cpu_freq(minfreq, core):
	minName = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/scaling_min_freq"
	print("Writing " + str(minfreq) + " to " + minName)
	minFile = open(minName,'w')
	minFile.write(str(minfreq))
	minFile.close()


def getcpucount():
	cpus = os.listdir("/sys/devices/system/cpu")
	regex = re.compile(r'cpu[0-9]')
	cpus = list(filter(regex.search, cpus))
	cpucount = len(cpus)
	return cpucount


def enable_pbf(mode):
	global cpucount

	print("CPU Count = " + str(cpucount))

	P1 = get_cpu_base_frequency()

	for core in range(0,cpucount):
		max_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/cpuinfo_max_freq"
		maxFile = open(max_file,'r')
		max = int(maxFile.readline().strip("\n"))
		maxFile.close()
		max_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/scaling_max_freq"
		maxFile = open(max_file,'w')
		maxFile.write(str(max))
		maxFile.close()
		( highest, guaranteed, lowest ) = get_hwp_capabilities(core)
		base = 0
		try:
			base_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/base_frequency"
			baseFile = open(base_file,'r')
			base = int(baseFile.readline().strip("\n"))/1000
			baseFile.close()
		except:
			print("WARNING: base_frequency sysfs entry not found, using default values")
			( minimum, maximum, desired, epp ) = get_hwp_request(core)
			if minimum > 0:
				# Available via 0x774 msr min.
				base = minimum * 100
			else:
				base = 2100

		if mode == 2:
			if cpucount == 16 or cpucount == 32 or cpucount == 64:
				if pbf_cores_16[core] == 1:
					base = 2700
				else:
					base = 2100
			if cpucount == 20 or cpucount == 40 or cpucount == 80:
				if pbf_cores_20[core] == 1:
					base = 2700
				else:
					base = 2100
			if cpucount == 24 or cpucount == 48 or cpucount == 96:
				if pbf_cores_24[core] == 1:
					base = 2800
				else:
					base = 2100

		if mode == 0:
			print("Core " + str(core) + ": P1 " + str(P1) + " : min/max " + str(base))
			min_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/scaling_min_freq"
			minFile = open(min_file,'w')
			minFile.write(str(base*1000))
			minFile.close()
			max_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/scaling_max_freq"
			maxFile = open(max_file,'w')
			maxFile.write(str(base*1000))
			maxFile.close()
		if mode == 1 and base > P1:
			print("Core " + str(core) + ": P1 " + str(P1) + " : min/max " + str(base))
			min_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/scaling_min_freq"
			minFile = open(min_file,'w')
			minFile.write(str(base*1000))
			minFile.close()


def reverse_pbf():
	global cpucount

	print("CPU Count = " + str(cpucount))

	P1 = get_cpu_base_frequency()

	for core in range(0,cpucount):
		max_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/cpuinfo_max_freq"
		maxFile = open(max_file,'r')
		max = int(maxFile.readline().strip("\n"))
		maxFile.close()
		max_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/scaling_max_freq"
		maxFile = open(max_file,'w')
		maxFile.write(str(max))
		maxFile.close()

		min_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/cpuinfo_min_freq"
		minFile = open(min_file,'r')
		min = int(minFile.readline().strip("\n"))
		minFile.close()
		min_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/scaling_min_freq"
		minFile = open(min_file,'w')
		minFile.write(str(min))
		minFile.close()
		print("Core " + str(core) + ": base " + str(P1) + " : min " + str(min/1000) + " : max " + str(max/1000))

def reverse_pbf_to_P1():
	global cpucount

	print("CPU Count = " + str(cpucount))

	P1 = get_cpu_base_frequency()

	for core in range(0,cpucount):
		max_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/cpuinfo_max_freq"
		maxFile = open(max_file,'r')
		max = int(maxFile.readline().strip("\n"))
		maxFile.close()
		max_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/scaling_max_freq"
		maxFile = open(max_file,'w')
		maxFile.write(str(max))
		maxFile.close()

		min_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/cpuinfo_min_freq"
		minFile = open(min_file,'r')
		min = int(minFile.readline().strip("\n"))
		minFile.close()
		min_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/scaling_min_freq"
		minFile = open(min_file,'w')
		minFile.write(str(min))
		minFile.close()

		max_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/scaling_max_freq"
		maxFile = open(max_file,'w')
		maxFile.write(str(P1*1000))
		maxFile.close()
		print("Core " + str(core) + ": base " + str(P1) + " : min " + str(min/1000) + " : max " + str(P1))

def query_pbf():
	global cpucount

	print("CPU Count = " + str(cpucount))

	P1 = get_cpu_base_frequency()
	print("Base = " + str(P1))
	P1hi = 0

	for core in range(0,cpucount):
		base = 0
		base_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/base_frequency"
		try:
			baseFile = open(base_file,'r')
			base = int(baseFile.readline().strip("\n"))/1000
			baseFile.close()
		except:
			( minimum, maximum, desired, epp ) = get_hwp_request(core)
			if minimum > 0:
				base = minimum * 100
		( highest, guaranteed, lowest ) = get_hwp_capabilities(core)
		max_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/scaling_max_freq"
		maxFile = open(max_file,'r')
		max = int(maxFile.readline().strip("\n"))
		maxFile.close()
		min_file = "/sys/devices/system/cpu/cpu" + str(core) + "/cpufreq/scaling_min_freq"
		minFile = open(min_file,'r')
		min = int(minFile.readline().strip("\n"))
		minFile.close()
		print("Core " + str(core).rjust(3) + ": base_frequency " + str(base).rjust(4) + " : min " + str(min/1000).rjust(4) + " : max " + str(max/1000).rjust(4))
		if base > P1:
		 	P1hi = P1hi + 1

	print("We have " + str(P1hi) + " high priority cores according to sysfs base_frequency.")


def range_expand(s):
    r = []
    for i in s.split(','):
        if '-' not in i:
            r.append(int(i))
        else:
            l,h = map(int, i.split('-'))
            r+= range(l,h+1)
    return r

def print_banner():
	print("----------------------------------------------------------")
	print("PBF SETUP SCRIPT (FOR INTERNAL USE ONLY) v1.1b")
	print("Please report script bugs/requests to david.hunt@intel.com")
	print("----------------------------------------------------------")

def show_help():
	print("")
	print_banner()
	print("")
	print(scriptname + ' <option>')
	print("")
	print('   <no params>   use interactive menu')
	print("   -s            Setup PBF Frequencies (set min on P1 High cores)")
	print("   -m            Setup PBF Frequencies (set min/max on all cores)")
	print("   -e            Emulate PBF Frequency configuration")
	print("   -r            Undo PBF, set max to all-core Turbo")
	print("   -t            Undo PBF, set max to P1")
	print("   -i            PBF info")
	print("   -h            Help")
	print()


def do_menu():
	print("")
	print_banner()
	print("")
	print("[s] Setup PBF Frequencies (set min on P1 High cores)")
	print("[m] Setup PBF Frequencies (set min/max on all cores)")
	print("[e] Emulate PBF Frequency configuration")
	print("[r] Undo PBF, set max to all-core Turbo")
	print("[t] Undo PBF, set max to P1")
	print("[i] PBF info")
	print("[h] Help")
	print("")
	print("[q] Exit Script")
	print("----------------------------------------------------------")
	text = raw_input("Option: ")

	#("[1] Display Available Settings")
	if (text == "s"):
		enable_pbf(0)
	elif (text == "m"):
		enable_pbf(1)
	elif (text == "e"):
		enable_pbf(2)
	elif (text == "r"):
		reverse_pbf()
	elif (text == "t"):
		reverse_pbf_to_P1()
	elif (text == "h"):
		show_help()
	elif (text == "i"):
		query_pbf()
	elif (text == "q"):
		sys.exit(0)
	else:
		print("")
		print("Unknown Option")

#
# Do some prerequesite checks.
#
ret = os.system("lsmod | grep msr >/dev/null")
if (ret != 0):
	print("ERROR: Need the 'msr' kernel module when " +
		"using the '" + driver + "' driver")
	print("Please run 'modprobe msr'")
	sys.exit(1)

if (get_turbo_disabled() > 0 ):
	print("ERROR: Turbo Boost not enabled in BIOS. Exiting.")
	sys.exit(1)

if (get_hwp_enabled() == 0):
	print("ERROR: HWP not enabled in BIOS. Exiting.")
	sys.exit(1)

if (check_driver() == 0):
	print("Invalid Driver : [" + driver + "]")
	sys.exit(1)

scriptname = sys.argv[0]

try:
	opts, args = getopt.getopt(sys.argv[1:],"smerthi")
except getopt.GetoptError:
	print('"' + scriptname + ' -h" for help')
	sys.exit(-1)

cpucount = getcpucount()
cpurange = range_expand('0-' + str(cpucount-1))


for opt, arg in opts:
        if opt in ("-s"):
		enable_pbf(0)
		sys.exit(0)
        if opt in ("-m"):
		enable_pbf(1)
		sys.exit(0)
        if opt in ("-e"):
		enable_pbf(2)
		sys.exit(0)
        if opt in ("-r"):
		reverse_pbf()
		sys.exit(0)
        if opt in ("-t"):
		reverse_pbf_to_P1()
		sys.exit(0)
        if opt in ("-h"):
		show_help()
		sys.exit(0)
        if opt in ("-i"):
		query_pbf()
		sys.exit(0)

if (len(opts)==0):
	while(1):
		do_menu()
		print("")
		raw_input("Press enter to continue ... ")
		print("")

