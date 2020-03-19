#!/bin/bash
# 
# board diagnostic main script
#

Prog_Basename=`basename "$0"`

MRV_CFG_PATH="${DIAG_ROOT_PATH}/cfg-switch"

#
#
#
function Usage() {
    echo
    echo -e "Description: SonicWall Board Diagnostic" 
    exit 1
}

function Diag_Test_Switch() {
    ret_val=0
    cfg_file="${MRV_CFG_PATH}/${DIAG_SYS_TYPE}.mrv"
    if   [[ "${DIAG_SYS_TYPE}" = "tz170" ]] ; then 
	${DIAG_ROOT_PATH}/diag-switch.py ${cfg_file} ${DIAG_VERBOSE}
	ret_val=$?
    elif [[ "${DIAG_SYS_TYPE}" = "tz270" ]] ; then 
	${DIAG_ROOT_PATH}/diag-switch-tz270.py ${cfg_file} $DIAG_{VERBOSE} 
	ret_val=$?
    elif [[ "${DIAG_SYS_TYPE}" = "tz370" ]] ; then 
	${DIAG_ROOT_PATH}/diag-switch.py ${cfg_file} ${DIAG_VERBOSE} 
	ret_val=$?
    elif [[ "${DIAG_SYS_TYPE}" = "tz470" ]] ; then 
	${DIAG_ROOT_PATH}/diag-switch.py ${cfg_file} ${DIAG_VERBOSE} 
	ret_val=$?
    elif [[ "${DIAG_SYS_TYPE}" = "tz570" ]] ; then 
	${DIAG_ROOT_PATH}/diag-switch.py ${cfg_file} ${DIAG_VERBOSE} 
	ret_val=$?
    elif [[ "${DIAG_SYS_TYPE}" = "tz670" ]] ; then 
	${DIAG_ROOT_PATH}/diag-switch.py ${cfg_file} ${DIAG_VERBOSE} 
	ret_val=$?
    else
	echo -e "\n ERROR: unknown board prodcode: $board_prodcode\n"
        ret_val=1 
    fi
    return $ret_val
}

Diag_Test_Switch
ret_val=$?
if [ $ret_val -ne 0 ] ; then 
    echo -e "ERROR ${Prog_Basename}: Main_Diag() failed with ret_val: $ret_val\n"
fi 
exit $ret_val

