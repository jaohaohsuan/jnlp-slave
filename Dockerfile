FROM anapsix/alpine-java:jdk8

ENV DOCKER_BUCKET=get.docker.com \
    DOCKER_VERSION=1.11.1 \
    DOCKER_SHA256=893e3c6e89c0cd2c5f1e51ea41bc2dd97f5e791fcfa3cee28445df277836339d \
    HOME=/home/jenkins

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

# install sbt if possible
RUN set -x \
  && curl -s https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt > /usr/local/bin/sbt \
  && chmod 0755 /usr/local/bin/sbt

# install kubectl
ENV K8S_VERSION 1.2.4
RUN apk --no-cache add --virtual .build-deps && \
    curl https://storage.googleapis.com/kubernetes-release/release/v$K8S_VERSION/bin/linux/amd64/kubectl > /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    apk del .build-deps && \
    kubectl --help

# set up jenkins slave
COPY jenkins-slave /usr/local/bin/jenkins-slave
RUN set -x \
  && addgroup jenkins \
  && adduser -h $HOME -s /bin/bash -D -G jenkins jenkins \
  && addgroup -g 999 docker && adduser jenkins docker \
  && curl --create-dirs -sSLo /usr/share/jenkins/slave.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/2.52/remoting-2.52.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar 

#WORKDIR /home/jenkins
USER jenkins
RUN /usr/local/bin/sbt -v -sbt-dir /tmp/.sbt/0.13.11 -sbt-boot /tmp/.sbt/boot -ivy /tmp/.ivy2 -sbt-launch-dir /tmp/.sbt/launchers -211 -sbt-create about
# COPY your project to here
#
# TODO: uncomment bellow otherwise you will suffer permission deny error
# RUN chown -R jenkins:jenkins /home/jenkins \
# VOLUME /home/jenkins
#WORKDIR /home/jenkins
#USER jenkins
#ENTRYPOINT ["jenkins-slave"]
