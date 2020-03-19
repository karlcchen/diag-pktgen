#!/bin/sh

. /diag/environment.sh

# Call sm app, which will decide if entering SM is needed
# in which case it will call sm-enter.sh
#
# If sm app handles everything it will return 0, otherwise
# enter safemode explicitly from here...
/sm/safemode
if [ $? -ne 0 ]; then
# Safemode app could not handle
    echo "SM APP error: entering safemode..."
    /sm/sm-enter.sh
    echo "Temporary method to launch cgi_queue processor..."
    /sm/safemode cgi &
fi

echo "Launch lighttpd web server..."
/sbin/lighttpd -f /etc/lighttpd.conf

exit 0
