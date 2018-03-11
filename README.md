# NIS-Keeper
Although NEM Infrastructure Service is a robust system, it will sometime run into unsync status on NEM network. 
This is a Linux shell script. There are two basic functions
1、Try to restart it if NIS crashes
2、If you NIS lags 10 blocks or more with your neighbor, and has started for 3 hours. We can assume that your NIS faces unsync problem. The script will delete your NIS blockchain database and download a newest packed up db from bob.nem.ninja to help keep sync quickly and safely.
3、If you are a supernode, please simultaneously use the servant keeper shell script.
The NIS server must be adjust before you use this script
Here is an example of how to setup a new node if you don't know.(if you already have a NIS setup up before please carefully move your NIS code to /opt/nem, make sure you can see nix.runNis.sh under the /opt/nem folder)
1、You must have a "nem" user,Running any user application in root account is considered not safe.
Command:
adduser nem
2、move or download your NIS node file to /opt/nem
mkdir /opt
wget https://bob.nem.ninja/nis-0.6.95.tgz
tar zxvf nis-0.6.95.tgz
mv package nem
chown -R nem:nem /opt/nem
4、download the script and mv this script to /usr/nemscript
3、set crontab for periodicity check for example every 10 minutes
crontab -e
*/10 * * * * root /usr/nemscript/monitor_worldwide.sh >> /tmp/monitor.log 2>&1
4、supernode user please move servant program to /opt/nem/servant and set crontab for periodicity check
crontab -e
*/8 * * * * /usr/nemscript/servant-autorun.sh
5、after 10 minites please refer to /tmp/monitor.log to see if NIS and script work fine
WARNING:this program will not guarantee anything, for example mistakenly remove or restart NEM supernode process, witch may influence your supernode reward. and some people believe it is not a good idea for everybody to use the same script on the mainnet since there should be some diversity in case or avoiding hack. So try this and give me feed back if you have any question using it.