#!/bin/bash
### BEGIN INIT INFO
# Provides:		TriviSeriesProd
# Required-Start:	$syslog
# Required-Stop:	$syslog
# Default-Start:	2 3 4 5
# Deafult-Stop:		0 1 6
# Short-Description:	Push Notifications Prod active
# Description:
#
### END INIT INFO

case "$1" in
	start)
		echo "Starting service ..."
		cd /home/kinki/Archer/TSPushServerProd/push/
		/usr/bin/php5 /home/kinki/Archer/TSPushServerProd/push/push.php production &
	;;
	stop)
		echo "Stopping service ..."
		kill -0 $PID 2> /dev/null
	;;
	*)
	echo "Usage: /etc/init.d/trivid.sh {start|stop)"
	exit 1
	;;
	esac

exit 0
