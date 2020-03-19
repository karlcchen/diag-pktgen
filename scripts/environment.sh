#!/bin/sh

# Platforms with SM and FW partitionz on block
# device like MMC and such
export FLASH_SM_DEVICE=/dev/mmcblk0
export FLASH_FW_DEVICE=/dev/mmcblk0
export FLASH_SM_PART_SIZE=256M

# Platform-independent definitions
export FLASH_FW_PART="$FLASH_FW_DEVICE"p2
export FLASH_FW_PART_NAME=fw
export FLASH_FW_MNT_DIR=/mnt/fw
export FLASH_SM_PART="$FLASH_SM_DEVICE"p1
export FLASH_SM_PART_NAME=sm
export FLASH_SM_MNT_DIR=/mnt/sm

# Network params
#export X0_VLAN=2
#export X0_PARENT_IF=eth0
#export X0_IF=$X0_PARENT_IF.0
export X0_IF=eth0

if [ -f /sys/kernel/snwl/sysinfo/lanip ]; then
    export X0_IP=`cat /sys/kernel/snwl/sysinfo/lanip`
else
    export X0_IP="192.168.168.168"
fi
if [ -f /sys/kernel/snwl/sysinfo/lansubnet ]; then
    export X0_MASK=`cat /sys/kernel/snwl/sysinfo/lansubnet`
else
    export X0_MASK="255.255.255.0"
fi

function is_sm_blockdev() {
    boardname=$( cat /sys/kernel/snwl/boardinfo/boardname )

    case "${boardname}" in
        "ESPRESSOBIN")
            retval=1
            ;;
        "LOMA_PRIETA")
            retval=1
            ;;
        "PALOMAR_MOUNTAIN")
            retval=1
            ;;
        *)
            retval=0
            ;;
    esac

    return $retval
}

function is_fw_blockdev() {
    boardname=$( cat /sys/kernel/snwl/boardinfo/boardname )

    case "${boardname}" in
        "ESPRESSOBIN")
            retval=1
            ;;
        "LOMA_PRIETA")
            retval=1
            ;;
        "PALOMAR_MOUNTAIN")
            retval=1
            ;;
        *)
            retval=0
            ;;
    esac

    return $retval
}
