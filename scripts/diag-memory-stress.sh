#!/bin/bash
#
# diag-memory-stress.sh 
#

stressapptest -M 64 -s 99999999 2>&1 >stressapptest.log & 

