#!/bin/sh

user=xxxxxx
pwd=xxxxxx

INTERVAL=5
PREFIX=$INTERVAL-sec-status
RUNFILE=/root/running
# mysql -u$user -p$pwd -e 'show global variables' >> mysql-variables

while test -e $RUNFILE; do
    echo "nihao"	
    file=$(date +%F_%I)
    sleep=$(date +%s.%N | awk "{print $INTERVAL -(\$1 % $INTERVAL)}")
    sleep $sleep
    ts="$(date +"TS %s.%n %F %T")"
    loadavg="$(uptime)"
    echo "%ts $loadavg" >> $PREFIX-${file}-status
    mysql -u$user -p$pwd -e 'show global status' >> $PREFIX-${file}-status &
    echo "%ts $loadavg" >> $PREFIX-${file}-innodbstatus
    mysql -u$user -p$pwd -e 'show engine innodb status\G' >> $PREFIX-${file}-innodbstatus &
    echo "%ts $loadavg" >> $PREFIX-${file}-processlist
    mysql -u$user -p$pwd -e 'show full processlist\G' >> $PREFIX-${file}-processlist &
    echo $ts
done
echo Exiting because $RUNFILE does not exit.

