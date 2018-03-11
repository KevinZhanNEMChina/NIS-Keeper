# NIS-Keeper
Although NEM Infrastructure Service is a robust system, it will sometime run into unsync status on NEM network. <br>
This is a Linux shell script. There are two basic functions<br>
1、Try to restart it if NIS crashes<br>
2、If you NIS lags 10 blocks or more with your neighbor, and has started for 3 hours. We can assume that your NIS faces unsync problem. The script will delete your NIS blockchain database and download a newest packed up db from bob.nem.ninja to help keep sync quickly and safely.<br>
3、If you are a supernode, please simultaneously use the servant keeper shell script.<br>
The NIS server must be adjust before you use this script<br>
Here is an example of how to setup a new node if you don't know.(if you already have a NIS setup up before please carefully move your NIS code to /opt/nem, make sure you can see nix.runNis.sh under the /opt/nem folder)<br>
1、You must have a "nem" user,Running any user application in root account is considered not safe.<br>
```Shell
adduser nem
```
2、move or download your NIS node file to /opt/nem<br>
```Shell
cd /opt
wget https://bob.nem.ninja/nis-0.6.95.tgz
tar zxvf nis-0.6.95.tgz
mv package nem
chown -R nem:nem /opt/nem
```
4、download the script and mv this script to /usr/nemscript<br>
3、set crontab for periodicity check for example every 10 minutes<br>
```Shell
crontab -e
i
*/10 * * * * root /usr/nemscript/monitor_worldwide.sh >> /tmp/monitor.log 2>&1
press Esc
press :wq Enter
(the way you use vim)
```
4、supernode user please move servant program to /opt/nem/servant and set crontab for periodicity check<br>
```Shell
crontab -e
i
*/8 * * * * /usr/nemscript/servant-autorun.sh
press Esc
press :wq Enter
(the way you use vim)
```
5、after 10 minites please refer to /tmp/monitor.log to see if NIS and script work fine<br>
WARNING:this program will not guarantee anything, for example mistakenly remove or restart NEM supernode process, witch may influence your supernode reward. and some people believe it is not a good idea for everybody to use the same script on the mainnet since there should be some diversity in case or avoiding hack. So try this and give me feed back if you have any question using it.<br>