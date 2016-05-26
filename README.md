# jnlp-slave

此image包含kubectl 1.2.4, docker 1.11.1, java 8, sbt[*](https://github.com/paulp/sbt-extras) 0.13.11

[![](https://imagelayers.io/badge/jaohaohsuan/jnlp-slave:latest.svg)](https://imagelayers.io/?images=jaohaohsuan/jnlp-slave:latest 'Get your own badge on imagelayers.io')

- 登入user为jenkins
- 为了加快sbt启动先预执行`sbt aobut`, 好让一堆dependencies都载下来.
注意: `/home/jenkins`被mount后底下的`.sbt`与`.ivy2`会不见, 所以把路径改到`/tmp下`, 务必使用以下`sbt`启动方式要编译的项目.

```
RUN /usr/local/bin/sbt -v -sbt-dir /tmp/.sbt/0.13.11 -sbt-boot /tmp/.sbt/boot -ivy /tmp/.ivy2 -sbt-launch-dir /tmp/.sbt/launchers
```

- jenkins不需要docker in docker那么请`mount /var/run/docker.sock`.

```
docker run -v /var/run/docker.sock:/var/run/docker.sock ...
```

- jenkins需要加入`docker`群组注意要先观察宿主的docker group id是否为`999`, 如果不是的话请修改Dockerfile或改自己宿主的docker group id, 这可能会造成docker需要从新安装.

```
cat /etc/group | grep docker
groupmod -g 999 docker
```

