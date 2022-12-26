#!/bin/bash

set -e

apt update

# Java
apt install default-jdk -y

# in case of maven
#apt install maven -y
#wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz -P /tmp
#tar xf /tmp/apache-maven-*.tar.gz -C /opt
#ln -s /opt/apache-maven-3.8.6 /opt/maven
#
#cat << EOF > /etc/profile.d/maven.sh
#export JAVA_HOME=/usr/lib/jvm/default-java
#export M2_HOME=/opt/maven
#export MAVEN_HOME=/opt/maven
#export PATH=${M2_HOME}/bin:${PATH}
#EOF
#
#chmod +x /etc/profile.d/maven.sh
#source /etc/profile.d/maven.sh
#
#update-alternatives --install "/usr/bin/mvn" "mvn" "/opt/apache-maven-3.8.6/bin/mvn" 0
#update-alternatives --set mvn /opt/apache-maven-3.8.6/bin/mvn
