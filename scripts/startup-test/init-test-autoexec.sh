#!/bin/bash
#
# add-autoexec.sh
#
#
echo -e "\nINFO: 
Description of operations: 
 - add test commands to file ${AUTOEXEC_FILE}, for perform test at system startup 
 - change user login prompt to 'automatic login' to 'root' user
 - this will take effect at next system re-start
\n"

TEST_SRC_DIR="/diag/startup-test"
cd ${TEST_SRC_DIR}
if [ $? -ne 0 ] ; then 
    echo -e "\nERROR: 'cd ${TEST_SRC_DIR}' failed!\n" 
    exit 1
fi 

source ${TEST_SRC_DIR}/setup-env-autoexec.sh 
if [ $? -ne 0 ] ; then 
    echo -e "\nERROR: 'source ${TEST_STARTUP_DIR}/setup-env-autoexec.sh' failed!\n" 
    exit 2
fi 

# Note: ${TEST_STARTUP_DIR} defined in "setup-env-autoexec.sh" from last command 
${TEST_STARTUP_DIR}/setup-autologin-root.sh
if [ $? -ne 0 ] ; then 
    echo -e "\nERROR: run '${TEST_STARTUP_DIR}/setup-autologin-root.sh' failed!\n" 
    exit 3
fi 
#
if [ ! -f ${TEST_AUTOEXEC_FILE} ] ; then 
    echo -e "\nERROR: cannnot find startup file: ${TEST_AUTOEXEC_FILE}"
    exit 4
fi 

# set reboot time parameter
if [ ! "${1}" = "" ] ; then 
    MY_TEST_TIME="${1}"
else
    MY_TEST_TIME="${TEST_TIME_DEFAULT}"
fi 

cat ${TEST_AUTOEXEC_FILE} | grep "startup-sysinfo.sh"
if [ $? -ne 0 ] ; then 
    echo -e "\nINFO: bakcup original ${TEST_AUTOEXEC_FILE}, append new scripts..."
    cp ${TEST_AUTOEXEC_FILE} ${TEST_AUTOEXEC_FILE}.bak
    echo -e "\n
# === addition Begin by add-autoexec.sh === 
source ${TEST_STARTUP_DIR}/setup-env-autoexec.sh
source ${TEST_STARTUP_DIR}/startup-sysinfo.sh
source ${TEST_STARTUP_DIR}/startup-stress-test.sh
source ${TEST_STARTUP_DIR}/reboot-time.sh ${MY_TEST_TIME}
# === addition End by add-autoexec.sh === 
\n" >> ${TEST_AUTOEXEC_FILE}
    echo -e "\n=== autoexec test scripts added to ${TEST_AUTOEXEC_FILE} ===\n"
else
    echo -e "\nERROR: test already exist in ${TEST_AUTOEXEC_FILE}, operation aborted!\n"
    exit 5
fi
