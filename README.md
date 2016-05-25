# jnlp-slave

因为/home/jenkins被mount之后文件夹会被覆盖, 当使用sbt编译scala项目我们将`.ivy2`缓存到/tmp下
```
RUN /usr/local/bin/sbt -v -sbt-dir /tmp/.sbt/0.13.11 -sbt-boot /tmp/.sbt/boot -ivy /tmp/.ivy2 -sbt-launch-dir /tmp/.sbt/launchers
```