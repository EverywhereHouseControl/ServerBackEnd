#!/bin/bash
### BEGIN INIT INFO
# Provides:          TriviSeriesProd
# Required-Start:    $syslog
# Required-Stop:     $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Push Notifications Production active
# Description:
#
### END INIT INFO

case "$1" in
start)
echo "Starting service... "
cd /var/www/
/usr/bin/php5 /home/pi/push.php &
;;
stop)
echo "Stopping service"
kill -0 $PID 2> /dev/null
;;
*)
echo "Usage: /etc/init.d/triviprod.sh {start|stop}"
exit 1
;;
esac

exit 0
