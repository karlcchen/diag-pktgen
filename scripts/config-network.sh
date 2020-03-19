#!/bin/bash
#

NET_IF="eth0"
ETH0_IP="192.168.168.168"
ETH0_MTU="9000"

if [ ! "$1" = "" ] ; then
    ETH0_IP="$1"
fi 
if [ ! "$2" = "" ] ; then
    ETH0_MTU="$2"
fi 

ifconfig ${NET_IF} down
ifconfig ${NET_IF} ${ETH0_IP}
ip link set ${NET_IF} mtu ${ETH0_MTU}
ifconfig ${NET_IF} up
echo "  Create eth0.1 eth0.4 i/f for getting receiving statistic"

ip link add link ${NET_IF} name ${NET_IF}.4 type vlan id 4 > /dev/null 2>&1
ifconfig ${NET_IF}.4 192.168.4.1
ip link set dev ${NET_IF}.4 up

ip link add link ${NET_IF} name ${NET_IF}.1 type vlan id 1 > /dev/null 2>&1
ifconfig ${NET_IF}.1 192.168.1.1
ip link set dev ${NET_IF}.1 up
echo " Configure ${NET_IF} for testing done:"
 
ifconfig
