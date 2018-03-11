#!/bin/bash
ps -ef |grep NodeRewardsServant|grep -v grep >/dev/null 2>&1
FLAG=$?

if [ $FLAG == 1 ]
then
    cd /opt/nem/servant
    /usr/bin/nohup /bin/bash startservant.sh >/dev/null 2>&1 &
fi
