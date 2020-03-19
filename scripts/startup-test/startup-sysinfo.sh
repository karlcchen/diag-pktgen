# usually to be 'sourced' by /etc/profile
#
# startup-sysinfo.sh
#
cd 
CUR_PID="$$"
HOME_STR=`pwd`
DATE_STR="`date +'%d/%m/%Y%t%H:%M:%S   %Z %z'`"
HWCLOCK_STR="`hwclock --show`"
# increment test loop count
if [ -f ${TEST_LOOP_COUNT_FILE} ] ; then 
    TEST_LOOP_COUNT=`cat ${TEST_LOOP_COUNT_FILE}`
else 
    TEST_LOOP_COUNT=0
fi
TEST_LOOP_COUNT=$((TEST_LOOP_COUNT+1))
echo -n "${TEST_LOOP_COUNT}" >${TEST_LOOP_COUNT_FILE}
#
# make sure change in file is sync back to storage media
#
sync; sync

printf "\n=== TEST LOOP: %s ===\n" ${TEST_LOOP_COUNT}
printf "PID=%s\n" "${CUR_PID}"
printf "HOME: %s\n" ${HOME_STR}
printf "system date: %s\n" "${DATE_STR}"
printf "hwclock: %s\n" "${HWCLOCK_STR}"
printf "\n=== sysinfo ===\n"
sysinfo 
printf "\n=== boardinfo ===\n"
boardinfo
printf "\n=== snwlinfo ===\n"
snwlinfo
