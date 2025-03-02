#!/bin/bash

# script to run the automatic server again in case of crash
echo "Starting the program"

cd /home/sv
mkdir -p logs

MYSQL_USER=
MYSQL_PASS=
MYSQL_DATABASE=

date=`date "+%d-%m-%y-%H-%M-%S"`
#necessary configurations for Anti-rollback
ulimit -c unlimited
set -o pipefail

while true        
do
     #the antirollback_config file must be in the tfs folder
    gdb --batch -return-child-result --command=antirollback_config --args ./tfs 2>&1 | awk '{ print strftime("%F %T - "), $0; fflush(); }' | tee "logs/$(date +"%F %H-%M-%S.log")"
	mysqldump -u $MYSQL_USER -p$MYSQL_PASS $MYSQL_DATABASE > backups/$(date '+%Y-%m-%d_%H-%M').sql
	
    if [ $? -eq 0 ]; then
        echo "Exit code 0, waiting 3 minutes..."
        sleep 5    #1 minuto
    else
        echo "Crash !! Restarting the server in 5 seconds (The log file is saved in the logs folder)"
        echo "If you want to shut down the server, press CTRL + C ..."
        sleep 5
    fi
done;