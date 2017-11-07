### 目录介绍

#### 全局共享目录

`/data1` ：服务层。代码为主，如网站根目录，提供服务

`/data2` ：存储层。写/读可能都比较多的文件，如mysql数据文件、sock、临时文件都放这

`/data3` ：静态层。读多写少，如日志、数据库备份、mysql修改记录、配置文件



#### 具体目录

`/data1/sites` ：网站根目录

`/data2/socks` ：sock链接文件。现有mysql.sock、php-fpm.sock

`/data3/conf` ： 配置文件。现有nginx、php、mysql

`/data3/logs` ： 日志文件。现有nginx、php、mysql



### 服务模型

**一个服务对应一个容器，可相互独立升级，服务与服务直接通过共享sock或网络通信。**

目前有：http服务、php/php-fpm、mysql

以后若加入队列服务，也需单独建立容器，php与之通过网络或sock通信

![架构](https://ws4.sinaimg.cn/large/006tNc79gy1fl582lqo54j30cp0afglt.jpg)

nginx容器名称：`nginx`，源镜像为`nginx/nginx:1.12-alpine`

php容器名称：`php`，源镜像为`php/php:7.1-fpm-alpine`，在此基础上添加了pdo_mysql、gd

mysql容器名称：`mysql`，源镜像为`mysql/mysql-server:5.7.20`



**不知道是什么原因，php-fpm以daemon运行时会自动退出，但是搜到了一个[bugpatch](https://bugs.php.net/patch-display.php?bug_id=62886&patch=bug62886.patch.txt&revision=latest)，所以php-fpm配置为daemon=no，即php-fpm为前台运行**



### 常用操作

##### 初始化nmp架构

```
git clone https://github.com/JerryCheese/docker-architecture.git
cd docker-architecture/compose/nmp
docker-compose up -d
docker ps
```

##### 在`.zshrc`(`.bash_profile`)中定义了，以方便之后做一些操作，就像在本机进行一样。

```
nginx_container="nginx"
php_container="php"
mysql_container="mysql"

alias nginx="docker exec -it $nginx_container nginx"
alias php="docker exec -it $php_container php"
alias mysql="docker exec -it $mysql_container mysql"
```

##### 登录mysql的命令为

`mysql -uroot -p`

##### 查看mysql版本

`mysql --version`

##### 启动nginx容器并显示命令行，退出容器后删除该容器(--rm)，alpine没有bash，所以是/bin/sh

`docker run -it --rm nginx:1.12-alpine /bin/sh`

##### 重新构建nmp架构

`docker-compose stop && docker-compose rm && (docker-compose up -d)`