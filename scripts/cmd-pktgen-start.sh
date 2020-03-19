#!/bin/bash
# 
# board diagnostic for tz-270 main script
#

Prog_Basename=`basename "$0"`

export PKTEGN_DIR="/proc/net/pktgen"
export ETH_PKTGEN="${PKTEGN_DIR}/eth0@1"
export PGCTRL_PKTGEN="${PKTEGN_DIR}/pgctrl"

echo "count 0" >${ETH_PKTGEN}
echo "pkt_size 1514" >${ETH_PKTGEN}
echo "start" >${PGCTRL_PKTGEN} & 

/diag/snwl_iftop.py
ret_val=$?

sleep 2 
echo "stop" >${PGCTRL_PKTGEN} & 
exit $ret_val
