#!/bin/bash
# NEM Infrastructure monitor and auto restore database from NEM network
# Author: Kevin Zhan
NIS_BASE_URL="http://127.0.0.1:7890"
NODE_INFO_CODE=$(curl -s $NIS_BASE_URL/status|grep -Po '(?<=code":)[0-9]+')
if [ ! "$NODE_INFO_CODE" ]; then
    ## restartNis ##
    echo "`date` NIS dead...."
    killall -u nem
        FLAG=$?
        if [ $FLAG == 0 ]; then
            echo "`date` restarting nis......."
su - nem <<EOF
sh /usr/nemscript/nis-autorun.sh
EOF
        fi
   exit 0
else
  if [[ $NODE_INFO_CODE -eq 8 ]]; then
    echo "`date` database is loading......"
  else
    CURRENT_HEIGHT=$(curl -s $NIS_BASE_URL/chain/height|grep -Po '(?<=height":)[0-9]+')
    MAX_CHAIN_HEIGHT=$(curl -m 30 -s $NIS_BASE_URL/node/active-peers/max-chain-height|grep -Po '(?<=height":)[0-9]+')
    if [ ! "$MAX_CHAIN_HEIGHT" ]; then
        ## restartNis ##
        echo "`date` No neighbor response or NIS error..."
        killall -u nem
            FLAG=$?
            if [ $FLAG == 0 ]; then
                 echo "`date` restarting nis......."
su - nem <<EOF
sh /usr/nemscript/nis-autorun.sh
EOF
            fi
    exit 0
    fi
    DELTA_CHAIN_HEIGHT=`expr $MAX_CHAIN_HEIGHT - $CURRENT_HEIGHT`
    echo "`date` delta_chain_height:$DELTA_CHAIN_HEIGHT"
    if [[ $DELTA_CHAIN_HEIGHT -gt 10 ]]; then
        NODE_INFO_CODE=$(curl -s $NIS_BASE_URL/status|grep -Po '(?<=code":)[0-9]+')
        CURRENT_TIME=$(curl -s $NIS_BASE_URL/node/extended-info|grep -Po '(?<=currentTime":)[0-9]+')
        START_TIME=$(curl -s $NIS_BASE_URL/node/extended-info|grep -Po '(?<=startTime":)[0-9]+')
        TIME_DELTA=`expr $CURRENT_TIME - $START_TIME`
        echo "`date` node_info_code:$NODE_INFO_CODE"
        echo "`date` time_delta:$TIME_DELTA"
          if [[ $TIME_DELTA -gt 14400 ]]; then
                  killall -u nem
		          cd /tmp
                  DB_FILE_NAME=$(curl -s https://bob.nem.ninja/|grep .db|grep -Po 'nis5_mainnet.(h2-)[0-9]+k.db.zip'|sort|tail -n1)
				  echo "`date` Downloading DB from Worldwide...."
                  wget https://bob.nem.ninja/$DB_FILE_NAME -qO db.zip
                  echo "`date` removing old database"
                  rm -rf /home/nem/nem/nis/data/*
                  echo "`date` unziping new database"
                  unzip -qo db.zip -d /home/nem/nem/nis/data/
                  chown -R nem:nem /home/nem/nem/nis/data
                  rm -rf db.zip
                  echo "`date` restarting nis......."
su - nem <<EOF
sh /usr/nemscript/nis-autorun.sh
EOF
          fi
    fi
  fi
fi
exit 0
