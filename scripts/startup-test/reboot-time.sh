#
# reboot-time.sh 
#
# for rebooting system in x seconds, default is 30 seconds
# can be run in background 
#

# this function is called when Ctrl-C is sent
function trap_ctrlc ()
{
    # perform cleanup here
    echo "Ctrl-C caught...performing clean up"

    echo "Doing cleanup"
    # exit shell script with error code 2
    # if omitted, shell script will continue execution
    exit 2
}
# initialise trap to call trap_ctrlc function
# when signal 2 (SIGINT) is received
# trap does not work in /etc/profile, thus dieabled now  
# trap "trap_ctrlc" 2

if [ ! "${1}" = "" ] ; then 
    TEST_TIME=${1}
else
    TEST_TIME=${TEST_TIME_DEFAULT}
fi

if [ ${TEST_TIME} -eq 0 ] ; then 
    printf "\nINFO: ### TEST LOOP: %d =0x%X, test time is ZERO, reboot request skipped! ###\n" ${TEST_LOOP_COUNT} ${TEST_LOOP_COUNT}
else 
    printf "\nINFO: === TEST LOOP: %d =0x%X, %d seconds until system reboot ===\n" ${TEST_LOOP_COUNT} ${TEST_LOOP_COUNT} ${TEST_TIME}
    printf "\n Press \"q\" to ABORT rebooting the system...\n"
    TIME_SEC=0
    REPLY=""
    while [[ ( "${REPLY}" != "q" && ${REPLY} != "Q" ) ]] ;
    do
        sleep 1
        TIME_SEC=$((TIME_SEC+1))
#
# note: read with time out of zero "-t 0", reads nothing
# thus set it to "-t 0.1"
# 
        read -t 0.1 -n 1 REPLY
        echo -n "."
        if [ ${TIME_SEC} -gt ${TEST_TIME} ] ; then
            break
        fi
    done
    if [[ ( "${REPLY}" = "q" || "${REPLY}" = "Q" ) ]] ; then
        printf "\nINFO: ### TEST LOOP: %d =0x%X, reboot aborted!  ###\n" ${TEST_LOOP_COUNT} ${TEST_LOOP_COUNT}
    else
        printf "\nINFO: ### TEST LOOP: %d =0x%X, System will reboot NOW ###\n" ${TEST_LOOP_COUNT} ${TEST_LOOP_COUNT}
        sync; sync
        reboot
    fi
fi 
