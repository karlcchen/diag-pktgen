#
# this file is to be sourced for setuping up test environment
# setup-test-env.sh 
#

export TEST_STARTUP_DIR="/diag/startup-test"
export TEST_AUTOEXEC_FILE="/etc/profile"

# the test loop counter always exist in home directory of the (root) user
export TEST_LOOP_COUNT_FILE=".test-loop-count"
export TEST_TIME_DEFAULT=30
export TEST_LOOP_COUNT=0
