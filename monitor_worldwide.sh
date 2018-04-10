#!/bin/bash
# NEM Infrastructure monitor and auto restore database from NEM network
# Author: Kevin Zhan
function restartNIS() {
killall -u nem
echo "`date` restarting nis......."
su - nem <<EOF
cd /opt/nem
/usr/bin/nohup /bin/bash nix.runNis.sh >/dev/null 2>&1 &
EOF
return 0
}

NIS_BASE_URL="http://127.0.0.1:7890"
NODE_INFO_CODE=$(curl --retry 6 --retry-delay 10 -s $NIS_BASE_URL/status|grep -Po '(?<=code":)[0-9]+')
if [ ! "$NODE_INFO_CODE" ]; then
    ## restartNis ##
    echo "`date` NIS dead...."
    restartNIS
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
        restartNIS
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
                  DB_FILE_NAME=$(curl -s -k -4 https://bob.nem.ninja/|grep .db|grep -Po 'nis5_mainnet.(h2-)[0-9]+k.db.zip'|sort|tail -n1)
                  echo "`date` Downloading DB from Worldwide...."
                  wget --no-check-certificate -4 https://bob.nem.ninja/$DB_FILE_NAME -qO db.zip
                  echo "`date` removing old database"
                  rm -rf /home/nem/nem/nis/data/*
                  echo "`date` unziping new database"
                  unzip -qo db.zip -d /home/nem/nem/nis/data/
                  chown -R nem:nem /home/nem/nem/nis/data
                  rm -rf db.zip
                  restartNIS
          fi
    fi
  fi
fi
exit 0
