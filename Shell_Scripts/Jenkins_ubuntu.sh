## Author : ARUNKUMAAR R
## Description : Shell script to install JDK and Jenkins
## Date : 14/02/24
## Language : Shell Script

#!/bin/bash

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update
apt install openjdk-11-jdk -y
apt install jenkins -y
