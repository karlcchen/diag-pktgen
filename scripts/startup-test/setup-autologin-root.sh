#!/bin/bash
#
# setup-autologin-root
# 
cd '/etc/systemd/system/getty.target.wants'
if [ $? -ne 0 ] ; then 
    echo -e "ERROR: 'cd /lib/systemd/system/getty.target.wants' failed!\n"
    exit 1
fi 
if [ -f 'serial-getty@ttyS0.service' ] ; then 
    echo -e "INFO: unlink old 'serial-getty@ttyS0.service'\n"  
    unlink 'serial-getty@ttyS0.service'
    if [ $? -ne 0 ] ; then 
        echo -e "ERROR: rm -f 'serial-getty@ttyS0.service' failed!\n"
        exit 2
    fi
fi 
ln -s '/diag/startup-test/serial-getty@.service' 'serial-getty@ttyS0.service'
if [ $? -ne 0 ] ; then 
    echo -e "ERROR: ln -s '/diag/startup-test/serial-getty@.service' 'serial-getty@ttyS0.service' failed!\n"
    exit 3
fi 
sync
ls -l
