FROM java:8-jdk-alpine

ARG DOCKER_BUCKET=get.docker.com
ARG DOCKER_VERSION=1.11.1
ARG DOCKER_SHA256=893e3c6e89c0cd2c5f1e51ea41bc2dd97f5e791fcfa3cee28445df277836339d
ARG HOME=/home/jenkins
ARG K8S_VERSION=1.2.4

# install docker
RUN set -x \
  && apk add --no-cache curl bash git openssh \
  && curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-$DOCKER_VERSION.tgz" -o docker.tgz \
  && echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
  && tar -xzvf docker.tgz \
  && mv docker/* /usr/local/bin/ \
  && rmdir docker \
  && rm docker.tgz \
  && docker -v

# install kubectl
RUN curl https://storage.googleapis.com/kubernetes-release/release/v$K8S_VERSION/bin/linux/amd64/kubectl > /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    kubectl --help

# set up jenkins slave
RUN set -x \
  && addgroup jenkins \
  && adduser -h $HOME -s /bin/bash -D -G jenkins jenkins \
  && addgroup -g 999 docker && adduser jenkins docker \
  && curl --create-dirs -sSLo /usr/share/jenkins/slave.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/2.7/remoting-2.7.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

COPY jenkins-slave /usr/local/bin/jenkins-slave

RUN curl -s https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt > /usr/local/bin/sbt && \
    chmod 0755 /usr/local/bin/sbt && \
    /usr/local/bin/sbt -v -sbt-dir /tmp/.sbt/0.13.11 -sbt-boot /tmp/.sbt/boot -ivy /tmp/.ivy2 -sbt-launch-dir /tmp/.sbt/launchers -211 -sbt-create about && \
    chown -R jenkins:jenkins /tmp/*

WORKDIR $HOME
ENTRYPOINT ["jenkins-slave"]
