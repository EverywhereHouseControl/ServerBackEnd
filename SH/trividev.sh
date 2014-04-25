#!/bin/bash
### BEGIN INIT INFO
# Provides:          TriviSeriesDev
# Required-Start:    $syslog
# Required-Stop:     $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Push Notifications active
# Description:
#
### END INIT INFO

case "$1" in
start)
echo "Starting service... "
cd /home/kinki/Archer/TSPushServer/push/
/usr/bin/php5 /home/kinki/Archer/TSPushServer/push/push.php development &
;;
stop)
echo "Stopping service"
kill -0 $PID 2> /dev/null
;;
*)
echo "Usage: /etc/init.d/trividev.sh {start|stop}"
exit 1
;;
esac

exit 0
