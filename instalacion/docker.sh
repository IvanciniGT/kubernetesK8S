#!/bin/bash

sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update -y
sudo apt install docker-ce -y

sudo systemctl status docker > /dev/null
if [[ $? != 0 ]]
then
    echo ERROR. Error al instalar docker.
fi

sudo usermod -aG docker ${USER}
# id -nG
if [[ $(cat /lib/systemd/system/docker.service | grep -c cgroupdriver=systemd) == 0 ]]
then
    sudo sed -i 's/--containerd=\/run\/containerd\/containerd.sock/--containerd=\/run\/containerd\/containerd.sock  --exec-opt native.cgroupdriver=systemd/' /lib/systemd/system/docker.service

    sudo systemctl daemon-reload
    sudo systemctl restart docker
fi


if [[ $(sudo systemctl status docker | grep -c cgroupdriver=systemd) == 1 ]]
then
    echo INFO. Docker instalado y configurado correctamente.
else
    echo ERROR. Error al configurar docker.
fi