# 1. DevOps介绍
##### 软件开发周期
软件开发最早是由两个团队组成的:
- 开发团队从头设计并完成整体系统的构建, 不停的迭代更新系统
- 运维团队将开发团队的Code测试后部署上线

这两个团队协作一下, 共同完成一个软件的开发部署上线。在开发团队完成coding后, 将代码提供到运维团队。运维团队测试后, 向开发团队反馈需要修复的BUG及要返工的任务。<br/>
在这期间, 开发团队需要等待运维团队的反馈, 这种线性开发流程延长了整个软件开发的周期。 <br/>
当然也可以让开发团队不要干等, 在等待期间投入到下一个项目的开发中, 但是这其实对于项目一来说, 还是需要更长的周期才可以完成最终的上线交付

> 如果是在测试环境反复部署的话, 就更加繁琐和重复了, 可以通过DevOps来实现自动化 降低开发团队和运维团队沟通的成本 实现一键构建, 一键部署, 一键监控

现在的互联网更推崇敏捷开发, 这就导致了项目的迭代速度更快, 但是由于开发团队和运维团队之间的沟通问题, 会导致新版本的上线周期很长, 违背了敏捷开发的初衷。<br/>
那么如果让开发团队和运维团队整合成一个团队, 共同应对一套软件呢? 这就是DevOps(Development and Operation)

![img.png](img.png)

# 2. DevOps的生命周期
- PLAN: 开发团队整理技术方案
- CODE: 开发并发布到git
- BUILD: 通过maven/gradle构建项目
- TEST: 自动化测试
- DEPLOY: 代码已经构建完成, 准备好部署
- OPERATE: 容器化部署到test/prod环境
- MONITOR: 监控报警
- INTEGRATE: MONITOR阶段的反馈到PLAN阶段, 整个反复的流程就是DevOps的核心, 即持续集成 持续部署(CI/CD)

![img_1.png](img_1.png)

DevOps: 通过自动化的工具协作来完成软件的生命周期管理, 从而达到更快、更频繁的交付更稳定的软件的目的

RD开发代码并push到git -> git -> jenkins拉取代码并完成构建(maven/gradle) -> 将可运行软件发布到目标服务器的test/stat预发布/prod环境 -> 基于docker完成软件的容器化部署

![img_2.png](img_2.png)

# 3. Code阶段工具
可以使用 git / gitlab

# 4. Build阶段工具
在devops实例中安装jdk和Maven, 为后续安装jenkins作准备

jdk8和maven都安装在了/usr/local/下, 修改maven的confg/settings.xml文件, 配置maven和jdk的环境变量

# 5. Operate阶段工具

##### 安装Docker

1. 下载Docker依赖组件
```shell
yum -y install yum-utils device-mapper-persistent-data lvm2
```

2. 设置Docker的镜像源为阿里云
```shell
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
````

3. 安装Docker服务
```shell
yum -y install docker-ce
```

4. 设置Docker开机自启
```shell
# 启动docker服务
systemctl start docker
# 设置开机自启
systemctl enable docker
```

5. 测试安装成功
```shell
docker version
```

##### 安装Docker Compose (docker的编排工具)
1. github上下载docker-compose-linux-x86_64: https://github.com/docker/compose/releases/tag/v2.2.1

上传到服务器

2. mv docker-compose-linux-x86_64 docker-compose

3. chmod 777 docker-compose

4. mv docker-compose /usr/bin/ (将docker-compose移动到系统环境变量的/usr/bin目录下)

5. docker-compose --version 验证安装成功

# 6. Integrate工具
jenkins串联起了开发和运维, 通过jenkins实现一键构建, 一键部署, 一键监控, 实现DevOps的核心流程。

持续集成、持续部署的工具很多, jenkins就是一个开源的持续集成平台。jenkins可以将开发完成的代码发布到测试环境和生产环境, 完成项目的自动化构建和部署。

> jenkins需要大量的插件, 安装成本较高, 因此我们使用Docker来安装jenkins

## 6.1 jenkins介绍
Jenkins是一个开源软件项目, 是基于Java开发的一种持续集成工具。 jenkins官网: https://www.jenkins.io/

Jenkins应用广泛, 大多数互联网公司都采用Jenkins配合Gitlab、Docker、K8s作为实现DevOps的核心工具。

Jenkins最主要的工作就是将GitLab上可以构建的工程代码拉取并且进行构建, 然后再根据流程选择发布到测试环境或是生产环境

##### CI/CD
![img_3.png](img_3.png)

- CI: CI过程就是Jenkins将代码拉取、构建、制作Docker镜像交给测试人员测试
- - 持续集成: 让软件代码可以持续的集成到主干上, 并自动构建和测试
- CD: CD过程就是Jenkins将打好标签的发行版本代码拉取、构建、制作镜像交给运维人员部署
- - 持续部署: 让可以持续交付的代码随时随地的自动化部署

## 6.2 安装jenkins
1. docker拉取jenkins镜像
```shell
docker pull jenkins/jenkins:lts
```

2. mkdir /usr/local/docker

3. 准备docker-compose.yml, 并启动jenkins
```yml
version: "3.1"
services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins
    restart: always
    ports:
      - 8080:8080
      - 50000:50000
    volumes:
      - /data/:/var/jenkins_home/
```

```shell
docker-compose up -d
```
4. 开启/data权限 chmod 777 /data

5. 查看jenkins启动日志, 记录初始密码
```shell
docker logs -f jenkins

Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

035b1f27a67d3216beeb52012069312352

This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
```
6. 使用jenkins初始密码访问 http://47.94.88.233:8080 

7. 选择插件安装, 先按默认的安装就好, 后面需要什么再安什么 (插件如果下载失败, don't worry,可以在jenkins内部重新下载 或者可以在jenkins官网的插件市场手动下载, 或者修改jenkins下载的数据源地址)

![img_4.png](img_4.png)

![img_5.png](img_5.png)

8. 创建管理员用户 root/199741xxxx

9. 配置完成, 进入jenkins首页

可以在插件管理中选择插件进行下载(先下载 git parameter 和 publish over ssh), 如果还是下载失败, 修改一下jenkins插件下载的数据源即可

##### 6.3 配置jenkins
git parameter: 支持从git上拉取代码

把maven和jdk挂载到jenkins上
```shell
cp /usr/local/jdk/ /data/

cp /usr/local/maven/ /data/
```
指定jenkins容器中进行jdk和maven的配置:

![img_6.png](img_6.png)

![img_7.png](img_7.png)

publish over ssh: 使得jenkins和远程服务器进行ssh连接, 能够将构建好的可执行文件发布到目标服务器上

配置ssh信息:

![img_9.png](img_9.png)

> 此时jenkins可以通过git parameter插件拉取代码, 内置中了jdk和maven 可以编译、构建代码, publish over ssh插件可以将构建好的可执行代码发布到目标服务器上 实现远程部署(目标服务器上得有docker, 通过docker来部署)

# 7. jenkins实现基础CICD操作
完成 代码开发 -> 代码推送 -> Jenkins拉取代码 -> Jenkins构建部署 -> 项目运行

1. 代码开发: 准备一个BasicController接口, 在本地测试成功

2. 代码推送: 创建完成仓库, 并push到git远程仓库

3. Jenkins拉取代码:

新建任务:

![img_10.png](img_10.png)

配置任务:

![img_11.png](img_11.png)

> 点击构建, 此时jenkins就会从github上拉取代码到jenkins本地, 构建项目

Jenkins构建部署:

点击构建后, Jenkins就会拉取远程代码到jenkins本地 我们先看下日志:

![img_12.png](img_12.png)

登陆服务器 查看项目是否已经在Jenkins本地:

```shell
docker exec -it jenkins /bin/bash

cd ~/workspace/项目名(这里是mytest)

ls -l
```
![img_13.png](img_13.png)

> 代码已经拉取到了jenkins本地

4. Jenkins构建Jar包

增加构建步骤-使用maven build、package项目

![img_14.png](img_14.png)

指定maven命令

![img_15.png](img_15.png)

再次构建

> 第一次构建可能会比较慢 因为会有大量的初始化操作, 后面构建会快一些

![img_16.png](img_16.png)

此时jenkins会在项目路径下生成一个target目录, 里面存放着构建好的可执行jar包

![img_17.png](img_17.png)

5. Jenkins推送Jar包到目标服务器

Jenkins推送jar包, 还是在Jenkins任务的配置里, 配置构建后操作:

![img_18.png](img_18.png)

![img_19.png](img_19.png)

![img_20.png](img_20.png)

再次构建, 到目标服务中确认jar包已经被推送了:

![img_21.png](img_21.png)

6. Jenkins在完成推送jar包后, 部署运行(Docker)

pom.xml的build插件中配置一个 <finalName>mytest</finalName>, 让jar包的名字简单点

编写dockerfile, 构建一个基于Java的Docker镜像文件, 并将本地文件复制到镜像中, 设置工作目录为/usr/local, 启动容器时运行jar包

通过这个 Dockerfile 构建的镜像可以在任何支持 Docker 的环境中运行，而无需手动安装 Java 环境或配置应用程序

```dockerfile
# 基础镜像
FROM daocloud.io/library/java:8u40-jdk
LABEL authors="zhaoyu"

COPY mytest.jar /usr/local/
WORKDIR /usr/local
CMD java -jar mytest.jar
```

编写docker-compose.yml, 构建镜像并创建容器:

```yml
version: '3.1'
services:
  mytest:
    # docker-compose.yml找docker.file
    build:
      context: ./
      dockerfile: docker/Dockerfile
    image: mytest
    container_name: mytest
    ports:
      - 8081:8081

```

将修改内容push到git远程仓库

此时还需要修改jenkins中构建任务的配置：

![img_24.png](img_24.png)

完成Jenkins CICD, 手动点击构建 完成一键部署最新代码到测试环境

![img_25.png](img_25.png)



> 部署代码到生产环境时, 不能部署最新代码, 而是要根据标签进行部署 部署指定的代码版本

