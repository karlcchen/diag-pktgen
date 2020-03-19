#!/usr/bin/python
import os, sys, telnetlib, re, time
import subprocess

TELNET_SERVER_IP="127.0.0.1"
HOST_IP = "192.168.1.168"
HOST_IF = "eth0"
MCLI_TIMEOUT = 10
STABLE_WAIT_TIME = 3

def find_running_process(name):
	output = subprocess.check_output("ps", shell=True)
	if output.find(name) == -1:
		return 0
	else:
		return 1

def pick_selected_mib_cnt(line, InMibCnts, OutMibCnts):
	if re.match('InUnicasts', line):
		InMibCnts.insert(0, int(line.split()[1]))
		return 1
	if re.match('InMulticasts', line):
		InMibCnts.insert(1, int(line.split()[1]))
		return 1
	if re.match('InBroadcasts', line):
		InMibCnts.insert(2, int(line.split()[1]))
		return 1
	if re.match('OutUnicasts', line):
		OutMibCnts.insert(0, int(line.split()[1]))
		return 1
	if re.match('OutMulticasts', line):
		OutMibCnts.insert(1, int(line.split()[1]))
		return 1
	if re.match('OutBroadcasts', line):
		OutMibCnts.insert(2, int(line.split()[1]))
		return 1
	return 0

class SwitchManager():
	def __init__(self):
		self.tn_ip = TELNET_SERVER_IP

	def mcli_connect(self):
		self.tn_conn = telnetlib.Telnet(self.tn_ip, 8888)
		try:
			self.tn_conn.read_until("MCLI>", MCLI_TIMEOUT)
		except EOFError:
			print "Can't connect MCLI via telent!"

	def mcli_close(self):
		self.tn_conn.close()

	def mcli_command(self, cmd, dump=0):
		tn = self.tn_conn
		tn.write(cmd + "\r\n")
		# to see whether dump the command output
		if dump == 1:
			# not to print MCLI prompt
			print tn.read_until("MCLI>", MCLI_TIMEOUT)[:-5]
		else:
			tn.read_until("MCLI>", MCLI_TIMEOUT)

	def mcli_dump_cnt(self, port, InMibCnts, OutMibCnts):
		tn = self.tn_conn
		tn.write("mib dump " + str(port) + "\r\n")
		for line in tn.read_until("MCLI>").splitlines():
			pick_selected_mib_cnt(line, InMibCnts, OutMibCnts)
		print "Summary: port-%d" % port
		print "InUnicast     = %08d" % InMibCnts[0]
		print "InMulticast   = %08d" % InMibCnts[1]
		print "InBroadcast   = %08d" % InMibCnts[2]
		print "InTotal       = %d" % (InMibCnts[0] + InMibCnts[1] + InMibCnts[2])
		print "OutUnicast    = %08d" % OutMibCnts[0]
		print "OutMulticast  = %08d" % OutMibCnts[1]
		print "OutBroadcast  = %08d" % OutMibCnts[2]
		print "OutTotal      = %d" % (OutMibCnts[0] + OutMibCnts[1] + OutMibCnts[2])

	def standalone_conf(self):
		# Port 1~4: X0 X1 X2 X3
		# Port 5: Uplink port
		# Using two network cables, one connected between port 1 and port 2. Another between 3 and 4.
		# <packet flow>
		# CPU(vlan 1) <-> port 5 <-> port 4 <-> port3 <-> port 2 <-> port 1 <-> port 5 <-> CPU(vlan 4)

		# Turn off port based map ?
		# Configure 802.1q mode
		self.mcli_command("port setQMode 1 2")
		self.mcli_command("port setQMode 2 2")
		self.mcli_command("port setQMode 3 2")
		self.mcli_command("port setQMode 4 2")
		self.mcli_command("port setQMode 5 2")
		# Enable ports(2~4). In the beginning, port 1 and 5 are enabled by default
		self.mcli_command("phy powerDown 2 disable")
		self.mcli_command("phy powerDown 3 disable")
		self.mcli_command("phy powerDown 4 disable")
		self.mcli_command("port setPortState 2 3")
		self.mcli_command("port setPortState 3 3")
		self.mcli_command("port setPortState 4 3")
		# Configure PVID
		self.mcli_command("port setDefVid  1 1")
		self.mcli_command("port setDefVid  2 2")
		self.mcli_command("port setDefVid  3 3")
		self.mcli_command("port setDefVid  4 4")
		# uplink port discard untagged pkt (Some influence from kernel network software)
		self.mcli_command("port setDiscardUTagged 5 1")
		# Create 4 vlan groups(1~4)
		#     vlan 1:  members are port 1 and 5
		#     vlan 2:  members are port 2 and 3
		#     vlan 3:  members are port 2 and 3
		#     vlan 4:  members are port 4 and 5
		self.mcli_command("vlan addEntry -fid 1 -vid 1 -TagP {3 1 3 3 3 2 3}")
		self.mcli_command("vlan addEntry -fid 1 -vid 2 -TagP {3 3 1 1 3 3 3}")
		self.mcli_command("vlan addEntry -fid 1 -vid 3 -TagP {3 3 1 1 3 3 3}")
		self.mcli_command("vlan addEntry -fid 1 -vid 4 -TagP {3 3 3 3 1 2 3}")

	def switch_config(self, conf_name):
		with open(conf_name, 'r') as conf_file:
			for line in conf_file:
				line = line.split('#', 1)[0]
				if not re.match(r'^\s*$', line):
					self.mcli_command(line)

def system_init():
	# Some initializations should be moved to kernel booting procedure.
	# Anyhow put here temporarily to make test smoothly.
	os.system("ifconfig %s down" % (HOST_IF))
	os.system("ifconfig %s %s" % (HOST_IF, HOST_IP) )
	os.system("ip link set %s mtu 9000" % (HOST_IF))
	os.system("ifconfig %s up" % (HOST_IF))
	print "  Create %s.1 %s.4 i/f for getting receiving statistic" % (HOST_IF, HOST_IF)
	os.system("ip link add link %s name %s.4 type vlan id 4 > /dev/null 2>&1; ifconfig %s.4 192.168.4.1; ip link set dev %s.4 up" % (HOST_IF, HOST_IF, HOST_IF, HOST_IF) )
	os.system("ip link add link %s name %s.1 type vlan id 1 > /dev/null 2>&1; ifconfig %s.1 192.168.1.1; ip link set dev %s.1 up" % (HOST_IF, HOST_IF, HOST_IF, HOST_IF) )
	if find_running_process("snwl-umsd-cli") is not 1:
		print "  Launch snwl-umsd-cli"
		os.system("snwl-umsd-cli &")
		time.sleep(STABLE_WAIT_TIME)

def switch_setup(sw_mgr, conf_filename ):
	sw_mgr.mcli_connect()
#    sw_mgr.standalone_conf();
	print( "INFO: switch setup, config filename %s" % conf_filename )
	if os.path.exists(conf_filename) and os.path.getsize(conf_filename) > 0:
		sw_mgr.switch_config( conf_filename );
	else:
		print( "filename not found %s" % conf_filename )
	sw_mgr.mcli_command("vlan dump", 1)
	sw_mgr.mcli_command("mib flush")

def traffic_generate():
	os.system("/diag/pktgen/one_flow.sh -i %s -m FF:FF:FF:FF:FF:FF -d 192.168.168.200 -q 1 -s 4096" % (HOST_IF) )

def main( conf_filename ):
	ret_val = 0 
	print "System Initialization..."
	system_init()

	print "Switch Setup..."
	sw_mgr = SwitchManager()
	switch_setup(sw_mgr, conf_filename )

	print "Strating traffic generating..."
	time.sleep(STABLE_WAIT_TIME)
	traffic_generate()

	print "Test Done..."

	InMibCnts = []
	OutMibCnts = []
	inTotral = 0
	outTotal = 0
	startInTotalCnts = 0 
	startOutTotalCnts = 0 
	loop = 1
	while loop <= 8:
		sw_mgr.mcli_dump_cnt( loop, InMibCnts, OutMibCnts)
		inTotal  = InMibCnts[0] + InMibCnts[1] + InMibCnts[2]
		outTotal = OutMibCnts[0] + OutMibCnts[1] + OutMibCnts[2]
		print ( "loop= %d, inTotal=%d, outTotal=%d\n" % (loop, inTotal, outTotal) )
		if loop == 1:
			startInTotalCnts = inTotal 
			startOutTotalCnts = outTotal
		else:
			if (loop %2 ) == 0:
				if outTotal != startInTotalCnts:
					print ( "ERROR: inTotal_begin:%d, outTotal_end:%d" % (startInTotalCnts, outTotal) )
					ret_val = ret_val + 1
			else:
				if outTotal != startOutTotalCnts:
					print ( "ERROR: outTotal_begin:%d, outTotal_end:%d" % (startOutTotalCnts, outTotal) )
					ret_val = ret_val + 1
		loop = loop + 1
	if ( (startInTotalCnts + startOutTotalCnts) != outTotal ):
		print ( "ERROR: inTotal_begin:%d, outTotal_end:%d" % ((startInTotalCnts+startOutTotalCnts), outTotal) )
		ret_val = 100
	sw_mgr.mcli_close()
	return ret_val
if __name__ == '__main__':
	sys.exit( main(sys.argv[1]) )
