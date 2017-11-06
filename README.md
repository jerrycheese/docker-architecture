### 目录介绍

#### 全局共享目录

`/data1` ：服务层。存放服务应用文件，如网站根目录

`/data2` ：存储层。mysql数据文件、HDFS、图片、视频、上传的文件等

`/data3` ：配置、脚本、sock。如nginx、mysql的配置文件，数据库备份脚本、phpfpm-sock



#### 具体目录





### 服务模型

**一个服务对应一个容器，可相互独立升级，服务与服务直接通过共享sock或网络通信。**

目前有：http服务、php/php-fpm、mysql

以后若加入队列服务，也需单独建立容器，php与之通过网络或sock通信

![架构](https://ws4.sinaimg.cn/large/006tNc79gy1fl582lqo54j30cp0afglt.jpg)

如图，php-fpm将sock放置/data3目录，在nginx配置中使用unix sock方式连接php-fpm



nginx容器名称：nginx

php容器名称：php

mysql容器名称：mysql



### hosts配置

172.17.0.101	server_http

172.17.0.102	server_php

172.17.0.103	server_mysql



### 一些操作命令

#### mysql

启动一个mysql容器，名称为mysql，初始密码为123456789

`docker run --name mysql -e MYSQL_ROOT_PASSWORD=123456789 -d mysql/mysql-server:5.7.20`

在mysql容器中，登录到mysql

`docker exec -it mysql mysql -uroot -p`



#### 常用操作

启动nginx容器并显示命令行，退出容器后删除该容器(—rm)，alpine没有bash，所以是/bin/sh

`docker run -it --rm nginx:1.12-alpine /bin/sh`

