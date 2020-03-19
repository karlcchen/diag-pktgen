#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# Simple example:
#  * pktgen sending with single thread and single interface
#  * flow variation via random UDP source port
#
basedir=`dirname $0`
source ${basedir}/functions.sh
root_check_run_with_sudo "$@"

# Parameter parsing via include
# - go look in parameters.sh to see which setting are avail
# - required param is the interface "-i" stored in $DEV
source ${basedir}/parameters.sh
if [ $? -ne 0 ] ; then 
    echo "ERROR: source ${basedir}/parameters.sh failed!" 
    exit 1
fi 
#
# Set some default params, if they didn't get set
if [ -z "$DEST_IP" ]; then
    [ -z "$IP6" ] && DEST_IP="198.18.0.42" || DEST_IP="FD00::1"
fi
[ -z "$CLONE_SKB" ] && CLONE_SKB="0"
# Example enforce param "-m" for dst_mac
[ -z "$DST_MAC" ] && usage && err 2 "Must specify -m dst_mac"
[ -z "$COUNT" ]   && COUNT="100000" # Zero means indefinitely

# Base Config
DELAY="0"        # Zero means max speed

# Flow variation random source port between min and max
UDP_MIN=9
UDP_MAX=109

# General cleanup everything since last run
# (especially important if other threads were configured by other scripts)
pg_ctrl "reset"

if [ -z "$VLAN_ID" ]; then
    err 2 "Please specify vlan id"
fi
DEVNAME=$DEV@$VLAN_ID

# Add remove all other devices and add_device $DEV to thread 0
thread=0
pg_thread $thread "rem_device_all"
pg_thread $thread "add_device" $DEVNAME

# How many packets to send (zero means indefinitely)
pg_set $DEVNAME "count $COUNT"

# Reduce alloc cost by sending same SKB many times
# - this obviously affects the randomness within the packet
pg_set $DEVNAME "clone_skb $CLONE_SKB"

# Set packet size
pg_set $DEVNAME "pkt_size $PKT_SIZE"

# Delay between packets (zero means max speed)
pg_set $DEVNAME "delay $DELAY"

# Flag example disabling timestamping
pg_set $DEVNAME "flag NO_TIMESTAMP"

# Destination
pg_set $DEVNAME "dst_mac $DST_MAC"
pg_set $DEVNAME "dst$IP6 $DEST_IP"

# Setup random UDP port src range
pg_set $DEVNAME "flag UDPSRC_RND"
pg_set $DEVNAME "udp_src_min $UDP_MIN"
pg_set $DEVNAME "udp_src_max $UDP_MAX"

# Set Vlan ID
pg_set $DEVNAME "vlan_id $VLAN_ID"

# start_run
echo "Running... ctrl^C to stop" >&2
pg_ctrl "start"
echo "Done" >&2

# Print results
echo "Result device: $DEV"
cat /proc/net/pktgen/$DEVNAME
