导入虚拟机显示这个界面。
![bd2707b6a0c34e6483f045540202496e.png](../_resources/bd2707b6a0c34e6483f045540202496e.png)
# 初始访问
首先找它的ip 执行netdiscover命令
![c3198f654e69ec2d102844073195378a.png](../_resources/c3198f654e69ec2d102844073195378a.png)
本机IP是.129，所以target机器的IP应该是.128
![21232f6543dd49e5337dabafc6d19333.png](../_resources/21232f6543dd49e5337dabafc6d19333.png)
# 信息搜集
使用nmap 扫描
script命令用来记录屏幕输出->指定文件
![6dc54865ba9fb78ef9e095be198a51b6.png](../_resources/6dc54865ba9fb78ef9e095be198a51b6.png)
扫描结果：
![8ed1287ff0b311d8e2d964a541570aa9.png](../_resources/8ed1287ff0b311d8e2d964a541570aa9.png)
开启了22端口/ssh和80/http服务
有http先进
先nikto扫下http
![5bf0163ebe8fc5899c54802fc19cb0f7.png](../_resources/5bf0163ebe8fc5899c54802fc19cb0f7.png)
再用dirb进行下目录扫描
（部分结果
![6b98143716fb657e25782ad438b53158.png](../_resources/6b98143716fb657e25782ad438b53158.png)
应该是架了wordpress服务
看到/dev目录是200，访问下
![94846eec4c5a83a050ad91449aa75137.png](../_resources/94846eec4c5a83a050ad91449aa75137.png)
它说我level0了 想要进一步还得dig ok
继续访问下个200
![92784a6e95a5cae2125d49727de3b0c1.png](../_resources/92784a6e95a5cae2125d49727de3b0c1.png)
这样一个初始界面
初始界面没啥用
那只能继续dig，继续用dirb
针对一些特殊文件后缀名集中扫描一下
发现了一个secret.txt
![2e1083cc3dc565ecd05bbc47097867f9.png](../_resources/2e1083cc3dc565ecd05bbc47097867f9.png)
访问之
它让我Fuzz。。。行口巴
![b28eaf93e646d631b9b6ef8a48c90aa2.png](../_resources/b28eaf93e646d631b9b6ef8a48c90aa2.png)
但是我很难不注意最下面那行，说实话我也不太想fuzz（我不会，正在学习ing

# 尝试访问
location.txt是啥 是个文件吧，看看能不能访问之
![76a30251a93f77a7f4db4a7989799ffd.png](../_resources/76a30251a93f77a7f4db4a7989799ffd.png)
额 结合之前dirb的结果试试其它的？index.php是200，试着后面加参数
![2c1d38a862b43915411c969edb96cae0.png](../_resources/2c1d38a862b43915411c969edb96cae0.png)
欧耶 可以看出来这个服务器上有本地文件包含的漏洞
给了我们个参数secrettier360
还让我们继续dig
要在其它的php页面继续dig，那也就是第二次dirb的时候还有个.php界面
![3445fc39056ebee2c4d735beb8b3fb75.png](../_resources/3445fc39056ebee2c4d735beb8b3fb75.png)
访问image.php，构造参数secrettier360
![ddb92cfc16be4d2209004afa4fa8f2a3.png](../_resources/ddb92cfc16be4d2209004afa4fa8f2a3.png)
好耶
仔细看看
![71a45e578fec9a1acd097d2687b3a74c.png](../_resources/71a45e578fec9a1acd097d2687b3a74c.png)
那就访问之
![580632ac66021ec5916f8994e3285747.png](../_resources/580632ac66021ec5916f8994e3285747.png)
拿到victor用户密码follow_the_ippsec 
先试下ssh
![fa1a1f5f23e625e1730d20771dae33c1.png](../_resources/fa1a1f5f23e625e1730d20771dae33c1.png)
残念，不是
那只能从web服务继续入手了，回忆一下之前dirb都扫出来了啥
依稀记得有一堆/wordpress/wp-admin/的 直接访问这个会返回302
那就访问试试
![95877b8156e3f5927e55bc0ba0fae3c1.png](../_resources/95877b8156e3f5927e55bc0ba0fae3c1.png)
好的 进入到login界面，拿victor/follow_the_ippsec试下
![cdeeb2bfea5846447ce74337b19da380.png](../_resources/cdeeb2bfea5846447ce74337b19da380.png)
登录成功

# 获取shell

让我进行一波任意点击，访问了很多页面……
直到这个界面
![6d7e452dc9ecd395de75f11497f4e068.png](../_resources/6d7e452dc9ecd395de75f11497f4e068.png)
只有secret.php可以成功写入
![0042e4cd5a16c3f4fb45c1fac56fa523.png](../_resources/0042e4cd5a16c3f4fb45c1fac56fa523.png)
那就考虑写入一句话木马拿反弹shell
说实话我不会 所以我搜索了一下，最后我屈服了，使用了msf
![0a6fc206b0d28f1bb7e24ab4cacf4e46.png](../_resources/0a6fc206b0d28f1bb7e24ab4cacf4e46.png)
在这里上传生成的shell.php
![78b0d4ce0bdc25a49a3bf4cee6693ca8.png](../_resources/78b0d4ce0bdc25a49a3bf4cee6693ca8.png)
在msfconsole配置监听端口
![8041244ea2fabae4f1d7f97f60c852e7.png](../_resources/8041244ea2fabae4f1d7f97f60c852e7.png)
![0abfdbdcf465fa77b3d8148e04a11d50.png](../_resources/0abfdbdcf465fa77b3d8148e04a11d50.png)
访问
![6cf2396b140598346f35668a7cd331ac.png](../_resources/6cf2396b140598346f35668a7cd331ac.png)
拿到shell
![2a68092a238aa1a369e5677692861c00.png](../_resources/2a68092a238aa1a369e5677692861c00.png)
ls一下
![42f5cc720e5dfc1f2092faa0a1d8b280.png](../_resources/42f5cc720e5dfc1f2092faa0a1d8b280.png)

# 提权

使用python切到交互式shell
![82c20a544ed074e61af7d5bdd66c279a.png](../_resources/82c20a544ed074e61af7d5bdd66c279a.png)
当前用户www-data
到根目录ls -al
![62b98a8c166572a46e4c9c01ad533b2c.png](../_resources/62b98a8c166572a46e4c9c01ad533b2c.png)
试一下sudo -l
www-data可以以sudo执行这个文件
![66b9d552224d9ddbb8508ff6263d8c84.png](../_resources/66b9d552224d9ddbb8508ff6263d8c84.png)
到处看看
![ad90b6984998e1002f7fa34fb9117632.png](../_resources/ad90b6984998e1002f7fa34fb9117632.png)
好像是加密字符串
sudo一下enc 需要密码 我们现在没有密码 执行不了
![4f571466ebb321c3b33be2c1ca4a48b5.png](../_resources/4f571466ebb321c3b33be2c1ca4a48b5.png)
最后到处tour，发现这里藏着密码(不看提示要tour到何年何月)
![ac197b0502c39702705f81b98b02a073.png](../_resources/ac197b0502c39702705f81b98b02a073.png)
那就用sudo执行一下enc
![e7d80402df79e832dae05d3dba80cba8.png](../_resources/e7d80402df79e832dae05d3dba80cba8.png)
得到一个good
看看发生了啥
![b676ac7b6ce00fd098ae6002b463d33a.png](../_resources/b676ac7b6ce00fd098ae6002b463d33a.png)
多了两个文件
看看
![08ae811ef4e6167ae6acabae2b26f37e.png](../_resources/08ae811ef4e6167ae6acabae2b26f37e.png)
给了提示，使用ippsec进行加密，密钥是把ippsec md5一下
用在线工具解密即可
https://www.devglan.com/online-tools/aes-encryption-decryption
https://www.cmd5.com/
ippsec-md5=>366a74cb3c959de17d61db30591c39d1
enc解密：
Dont worry saket one day we will reach toour destination very soon. And if you forget your username then use your old password==> "tribute_to_ippsec"Victor,

好耶 拿到密码了
切到saket
![871c26ff05c8975073b2f8eef8388336.png](../_resources/871c26ff05c8975073b2f8eef8388336.png)
看看saket权限
![aa9842133b1525fd043a1a0320a0b2ad.png](../_resources/aa9842133b1525fd043a1a0320a0b2ad.png)
可以执行这个文件
先执行下
![48c01a29dc3edd7602553400e3a4bf9a.png](../_resources/48c01a29dc3edd7602553400e3a4bf9a.png)
说找不到/tmp/challenge
依稀记得tmp目录普通用户可写！那就自己建一个/tmp/challenge并写入/bin/bash
![340c0eb3ed5080dcb8267ec95432bcc7.png](../_resources/340c0eb3ed5080dcb8267ec95432bcc7.png)
拿到root
![20110a799edc8441fdfce9399862e511.png](../_resources/20110a799edc8441fdfce9399862e511.png)
结束












