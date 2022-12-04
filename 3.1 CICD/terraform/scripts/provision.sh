#!/bin/bash

set -e

apt update

# Java
apt install openjdk-11-jre -y

# Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
apt update
apt install jenkins -y

systemctl enable jenkins

# Docker
apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor --y -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
chmod a+r /etc/apt/keyrings/docker.gpg
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

usermod -aG docker jenkins

# AWS CLI
apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install


# Python
apt -y install python3-venv python3-pip
apt install python-is-python3 -y

# Ansible
apt -y install ansible

## needs to install manually
# install standard plugins and
# ansible plugin
# parameterized build plugin
# add ssh-key for github
# add ssh-key for web-server

# AWS EB CLI - in case to try with beanstalk
#apt -y install python3-venv python3-pip
#apt install python-is-python3 -y
#git clone https://github.com/aws/aws-elastic-beanstalk-cli-setup.git
#apt install virtualenv -y
#python ./aws-elastic-beanstalk-cli-setup/scripts/ebcli_installer.py
#echo 'export PATH="/root/.ebcli-virtual-env/executables:$PATH"' >> ~/.bash_profile && source ~/.bash_profile
