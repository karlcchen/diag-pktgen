#!/usr/bin/python
import os, subprocess
from optparse import OptionParser

def shutdown_running_pktgen():
	pid = os.popen("ps ux | grep pgctrl | awk '{print $1}'").readlines()[0] #call pid
	system_cmd="kill "+str(pid).rstrip()+ " > /dev/null 2>&1"
	os.system(system_cmd)


def main():
	parser = OptionParser()
	parser.add_option("-s", "--start", action="store_const", const=0, dest="op", help="Start pgctrl")
	parser.add_option("-p", "--stop", action="store_const", const=1, dest="op", help="Stop pgctrl")
	(options, args) = parser.parse_args()

#	if len(args) != 1:
#		parser.error("wrong number of arguments")
	if options.op is None:
		print "Null options"
		return None

	if options.op is 0:
		print "Start pgctrl..."
		# Stop any previous running pktgen
		shutdown_running_pktgen();
		proc = subprocess.Popen("echo \"start\" > /proc/net/pktgen/pgctrl &", shell=True)
#		print "pid =%d"  % proc.pid
	else:
		print "Stop pgctrl..."
		shutdown_running_pktgen();

	return None


# --------------- Program Entry Point ---------------

if __name__ == "__main__":
	main()

