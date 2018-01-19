### 单机架构

因为`正式环境` 和 `开发环境` 的配置也许会不一样，为了尽可能的模拟真实情况，所以采取模拟多机的架构。逻辑上将容器划分为`开发环境(dev)`和`正式环境(online)` 。



#### 独立的数据目录

每一个逻辑环境有独自的数据目录，对于宿主 `/data-dev` 目录和 `/data-online` 目录 ，宿主本身的docker app的数据存放在根目录 `/` 中。

所以在宿主中有如下的数据目录结构

`/data-dev`：data1、data2

`/data-online`：data1、data2

`/`：data1、data2

这意味着你可以在 `dev` 机器上开发，完成后将代码拷贝至`online` 目录即可完成上线操作。



#### nginx单例模式

nginx的实例只有一个，存在于宿主的docker app中，只有1个。

![](http://os9coobhw.bkt.clouddn.com/d6c6230a46f5cff94d795f28b21dc5cb.jpg)



#### 逻辑划分而非单容器

上面的`dev` 和 `online` 是逻辑概念，只是为了便于区分，它们的php和mysql还是在各自的容器中运行的，例如`dev`的php和mysql是两个单独的容器，而不是在一个容器内。



#### 临时网站

像一些测试用的`sb.html` 文件，应当放在`dev` 环境下或直接放在`真机(推荐)`，`dev` 和 `online` 应该是工程性的项目。



### 数据目录

以下均都是以某一个`逻辑机器`的视角来看的

`/data1` ：代码层。项目代码为主。如网站根目录

`/data2` ：非代码层。除了代码都放这



#### 具体目录

`/data1/sites` ：网站根目录

`/data2/socks` ：sock链接文件。如mysql.sock、php-fpm.sock

`/data2/{$app}/logs` ： 日志文件。如nginx、php、mysql

`/data2/{$app}/conf` ： 配置文件。如nginx、php、mysql



### 镜像源

目前均使用一样的镜像

nginx源镜像为`nginx/nginx:1.12-alpine`

php源镜像为`php/php:7.1-fpm-alpine`，在此基础上添加了pdo_mysql、gd

mysql源镜像为`mysql/mysql-server:5.7.20`

**不知道是什么原因，php-fpm以daemon运行时会自动退出，但是搜到了一个[bugpatch](https://bugs.php.net/patch-display.php?bug_id=62886&patch=bug62886.patch.txt&revision=latest)，所以php-fpm配置为daemon=no，即php-fpm为前台运行**



### 容器命令映射

`scripts/short-cmd.sh` 是用来做命令映射的程序，建议将其拷贝至`/usr/local/bin`中

该脚本接受两个参数，第一个是要映射的命令（可以带命令参数）

经过上面的定义后，如果我们到`/data-dev/data1/sites` 目录下运行如下命令

```shell
sc php hello.php
```

它会根据当前目录`/data-dev/data1/sites` 取出机器名称`dev` 和app名称`php`，容器序号固定为`1` 拼凑出容器名称为`dev_php1` ，再切换至对应的数据目录`/data-dev/data1/sites` 对应容器内的目录是`/data1/sites` 运行指定的命令`php hello.php`。

所以如果在`~/.zshrr` (`~/.bash_profile`)中定义：

```
alias php='sc php'
```

那就可以直接使用php命令了
如果php容器中安装了composer，怎么使用呢？如下：

```shell
sc -c php composer --version
```

`-c`表示使用`php`容器，同理也会切换到与当前目录对应的容器目录下，然后执行`composer --version`命令


### 常用操作

##### 初始化dev环境

```
git clone https://github.com/JerryCheese/docker-architecture.git
cd docker-architecture/compose/dev
docker-compose up -d
docker ps -a
```



##### 重新构建架构

`docker-compose stop && docker-compose rm && (docker-compose up -d)`
