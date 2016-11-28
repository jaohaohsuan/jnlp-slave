#!/bin/bash 
tar -xf /opt/sbt-caches.tar.gz
/usr/local/bin/jenkins-slave "$@"
