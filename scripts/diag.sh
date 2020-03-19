#!/bin/bash
#
# diag.sh 
#

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

ROOT_PATH_DIAG="/diag"

SRC_SH_FILE="${ROOT_PATH_DIAG}/func-diag.sh"
if [ -f ${SRC_SH_FILE} ] ; then 
    source ${SRC_SH_FILE}
else
    echo -e "ERROR: ${Prog_Basename} cannot find shell source file: ${SRC_SH_FILE}\n"  
    exit 1 
fi 

SRC_SH_FILE="${ROOT_PATH_DIAG}/setupenv-diag.sh"
if [ -f ${SRC_SH_FILE} ] ; then 
    source ${SRC_SH_FILE}
else
    echo -e "ERROR: ${Prog_Basename} cannot find shell source file: ${SRC_SH_FILE}\n"  
    exit 2 
fi 

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

while true; 
do
	exec 3>&1
    selection=$(dialog \
      --backtitle "System Information" \
      --title "Menu" \
      --clear \
      --cancel-label "Exit" \
      --menu "Please select:" $HEIGHT $WIDTH 4 \
      "1" "Marvell Switch Test" \
      "2" "Memory Stress Test" \
      "3" "USB Storage Test" \
      2>&1 1>&3)
    exit_status=$?
    exec 3>&-
    case $exit_status in
      $DIALOG_CANCEL)
        clear
        echo "DIAG terminated."
        exit
        ;;
      $DIALOG_ESC)
        clear
        echo "DIAG aborted." >&2
        exit 1
        ;;
    esac
    case $selection in
      0 )
        clear
        echo "Program terminated."
        ;;
      1 )
        result=$(${DIAG_ROOT_PATH}/diag-switch.sh)
        display_result "Switch Test Result:"
        ;;
      2 )
        result=$(${DIAG_ROOT_PATH}/diag-memory.sh)
        display_result "Memory Test Result:"
        ;;
      3 )
        result=$(${DIAG_ROOT_PATH}/diag-usb-storage.sh)
        display_result "USB Test Result:"
        ;;
    esac
done
