## 项目目的

*   用于将数字型的 errno 解释为字符串.

## 安装

```shell
$ make 
$ sudo make install 
$ which strerror
/usr/bin/strerror
```
    
## 使用说明

```shell
$ strerror -h
Usage: strerror 错误码[ 错误码 错误码...]
$ strerror 2
No such file or directory
$ strerror 2 3 4
2: No such file or directory
3: No such process
4: Interrupted system call
```
    