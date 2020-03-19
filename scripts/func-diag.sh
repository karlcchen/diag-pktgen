#
# func-diag.sh
#

TZ_170_PRODCODE="20100"
TZ_270_PRODCODE="20500"
# TZ_370_PRODCODE="20500"
# TZ_470_PRODCODE="20500"
# TZ_570_PRODCODE="20500"
# TZ_670_PRODCODE="20500"

TZ_170_PRODCODE_MIN="20000"  
TZ_170_PRODCODE_MAX="20399"
TZ_270_PRODCODE_MIN="20400"  
TZ_270_PRODCODE_MAX="20999"

TZ_370_PRODCODE_MIN="21000"  
TZ_370_PRODCODE_MAX="21399"
TZ_470_PRODCODE_MIN="21400"  
TZ_470_PRODCODE_MAX="21999"

TZ_570_PRODCODE_MIN="22000"  
TZ_570_PRODCODE_MAX="22399"
TZ_670_PRODCODE_MIN="22400"  
TZ_670_PRODCODE_MAX="22999"

function Prodcode_2_Sys_Type() {
    if [ "$1" = "" ] ; then 
	echo -e "error"
    else 
        board_prodcode="$1"
        if   [[ ${board_prodcode} -ge ${TZ_170_PRODCODE_MIN} && ${board_prodcode} -le ${TZ_170_PRODCODE_MAX} ]] ; then 
	    echo -e "tz170"
        elif [[ ${board_prodcode} -ge ${TZ_270_PRODCODE_MIN} && ${board_prodcode} -le ${TZ_270_PRODCODE_MAX} ]] ; then
	    echo -e "tz270"
        elif [[ ${board_prodcode} -ge ${TZ_370_PRODCODE_MIN} && ${board_prodcode} -le ${TZ_370_PRODCODE_MAX} ]] ; then 
	    echo -e "tz370"
        elif [[ ${board_prodcode} -ge ${TZ_470_PRODCODE_MIN} && ${board_prodcode} -le ${TZ_470_PRODCODE_MAX} ]] ; then 
	    echo -e "tz370"
        elif [[ ${board_prodcode} -ge ${TZ_570_PRODCODE_MIN} && ${board_prodcode} -le ${TZ_570_PRODCODE_MAX} ]] ; then 
	    echo -e "tz370"
        elif [[ ${board_prodcode} -ge ${TZ_670_PRODCODE_MIN} && ${board_prodcode} -le ${TZ_670_PRODCODE_MAX} ]] ; then 
	    echo -e "tz370"
        else
	    echo -e "error"
	fi
    fi
}

function Diag_Dump_Env_Vars() {
    echo -e "DIAG_SYS_TYPE=${DIAG_SYS_TYPE}"
    echo -e "DIAG_SYS_TYPE_EXTRA=${DIAG_SYS_TYPE_EXTRA}"
    echo -e "DIAG_SYS_REV=${DIAG_SYS_REV}"
    echo -e "DIAG_ROOT_PATH=${DIAG_ROOT_PATH}"
    echo -e "DIAG_LOG_PATH=${DIAG_LOG_PATH}"
    echo -e "DIAG_LOG_FILE=${DIAG_LOG_FILE}"
    echo -e "DIAG_VERBOSE=${DIAG_VERBOSE}"
}
