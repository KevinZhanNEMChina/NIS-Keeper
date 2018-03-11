# NIS-Keeper
Although NEM Infrastructure Service is robust, your node will sometime run into unsync status on NEM network. <br>
NEM has provided a great web based API that I, a Linux sysadmin can easily call for.<br>
This is a Linux shell script. There are two basic functions<br>
1、Try to restart it NIS crashes<br>
2、If your NIS lags 10 blocks or more behind your neighbor, and has been up over 3 hours. We can assume that your NIS faces unsync problem.<br>
The script will delete your NIS blockchain database and download a newest packed up db from bob.nem.ninja to help keep sync quickly and safely.<br>
WARNING：If you are a supernode, please simultaneously use the servant keeper shell script.<br>
The NIS server must be adjust to be compatible with the script<br>
Here is an example of how to setup a new node if you don't know.<br>
if you already have a NIS setup up before please carefully move your NIS code to /opt/nem, make sure you can see nix.runNis.sh under the /opt/nem folder<br>
WARNING：ALWAYS remember to back up your configuration if you are a supernode user<br>
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
3、download the script and mv this script to /usr/nemscript<br>
```Shell
mkdir /usr/nemscript
cd /usr/nemscript
wget https://raw.githubusercontent.com/KevinZhanNEMChina/NIS-Keeper/master/monitor_worldwide.sh
chmod 755 monitor_worldwide.sh
```
4、set crontab for periodicity check for example every 10 minutes<br>
```Shell
crontab -e
i
*/10 * * * * root /usr/nemscript/monitor_worldwide.sh >> /tmp/monitor.log 2>&1
press Esc
press :wq Enter
(the way you use vim)
```
5、supernode user please move servant program to /opt/nem/servant and set crontab for periodicity check<br>
```Shell
wget https://raw.githubusercontent.com/KevinZhanNEMChina/NIS-Keeper/master/servant-autorun.sh
chmod 755 servant-autorun.sh
crontab -e
i
*/8 * * * * /usr/nemscript/servant-autorun.sh
press Esc
press :wq Enter
(the way you use vim)
```
6、after 10 minites please refer to /tmp/monitor.log to see if NIS and script work fine<br>
WARNING：this program will not guarantee anything, for example mistakenly remove or restart NEM supernode process, witch may influence your supernode reward. and some people believe it is not a good idea for everybody to use the same script on the mainnet since there should be some diversity in case or avoiding hack. <br>
So try this and give me feed back if you have any question using it.<br>
If you think this script works feel free to donate:<br>
NEM main net address: NC3ZL4L32GJXNGGD3HNIU5WHBKXFN557CKEXDVYV <br>
NEM主网地址：NC3ZL4L32GJXNGGD3HNIU5WHBKXFN557CKEXDVYV <br>
# NIS守护者
即便NEM区块链基础设施程序已经很强健了，有时我们的节点还是会进入与NEM大网不同步的状态<br>
NEM提供了很棒的基于web的API，我作为一个Linux系管也可以轻易调用起来<br>
这里是一个Linux shell脚本，有两个基本功能<br>
1、当NIS挂了的时候把它启动起来<br>
2、如果你的NIS落后邻居超过10个区块，并且已经启动了超过3个小时，我们就假定NIS已经遇到了同步问题<br>
脚本会删除你的NIS区块链数据库，然后从bob.nem.ninja下载最新打包好的数据，以便快速和安全得恢复<br>
警告：如果你运行的是超级节点，请同时使用servant守护脚本<br>
NIS服务器必须调整才能兼容脚本<br>
下面是一个架设新节点的例子，如果你不熟悉的话<br>
如果你已经架设好了NIS，请小心得将NIS代码放到/opt/nem中，确保你可以在/opt/nem下就看到nix.runNis.sh脚本<br>
警告：如果你是一个超节点拥有者，请务必记得备份<br>
1、你必须有nem这个用户，使用root执行用户程序是不安全的<br>
```Shell
adduser nem
```
2、移动或者下载NIS节点文件到 /opt/nem<br>
```Shell
cd /opt
wget https://bob.nem.ninja/nis-0.6.95.tgz
tar zxvf nis-0.6.95.tgz
mv package nem
chown -R nem:nem /opt/nem
```
3、将脚本下载并移动到/usr/nemscript<br>
```Shell
mkdir /usr/nemscript
cd /usr/nemscript
wget https://raw.githubusercontent.com/KevinZhanNEMChina/NIS-Keeper/master/monitor_worldwide.sh
chmod 755 monitor_worldwide.sh
```
4、将crontab设置好，这样就可以周期性得运行检查脚本了，比如每10分钟<br>
```Shell
crontab -e
i
*/10 * * * * root /usr/nemscript/monitor_worldwide.sh >> /tmp/monitor.log 2>&1
press Esc
press :wq Enter
(the way you use vim)
```
5、超级节点用户请将servant程序移动到/opt/nem/servant，并设置crontab<br>
```Shell
wget https://raw.githubusercontent.com/KevinZhanNEMChina/NIS-Keeper/master/servant-autorun.sh
chmod 755 servant-autorun.sh
crontab -e
i
*/8 * * * * /usr/nemscript/servant-autorun.sh
press Esc
press :wq Enter
(the way you use vim)
```
6、10分钟后，请查看/tmp/monitor.log，看看NIS和这个脚本是不是正常运行了<br>
警告：此程序不对任何结果做出保证，例如误重启NEM超级节点进行导致影响超级节点奖励。同时有些人认为不应该让所有人都使用相同的脚本，这对多样性不利，也不利于防范黑客。<br>
所以就做个尝试吧，如果你有什么疑问，请反馈给我<br>
如果你觉得这个脚本有用，可以随意打赏一点:<br>
NEM主网地址：NC3ZL4L32GJXNGGD3HNIU5WHBKXFN557CKEXDVYV <br>