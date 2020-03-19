#!/bin/bash
#
# net-init-tz170.sh
#
HOST_IF="eth0"
NETWROK_BASE="192.168"

HOST_IP="${NETWORK_BASE}.1.168"
VLAN_IP1="${NETWORK_BASE}.4.1"
VLAN_IP2"${NETWORK_BASE}.1.1"

MTU_SIZE=9000

ifconfig ${HOST_IF} down 
ifconfig ${HOST_IF} ${HOST_IP} netmask 255.255.255.0 
ip link set ${HOST_IF} mtu ${MTU_SIZE}

ifconfig ${HOST_IF} up

# Create ${HOST_IF}.1 ${HOST_IF}.4 i/f for getting receiving statistic
ip link add link ${HOST_IF} name ${HOST_IF}.4 type vlan id 4 > /dev/null 2>&1
ifconfig ${HOST_IF}.4 ${VLAN_IP1}
ip link set dev ${HOST_IF}.4 up

ip link add link ${HOST_IF} name ${HOST_IF}.1 type vlan id 1 > /dev/null 2>&1
ifconfig ${HOST_IF}.1 ${VLAN_IP2} 
ip link set dev ${HOST_IF}.1 up

ps > x
cat x | grep "snwl-umsd-cli"
if [ $? -ne 0 ] ; then 
    echo -e "Starting snwl-umsd-cli\n" 
    snwl-umsd-cli & 
    sleep 1 
fi
