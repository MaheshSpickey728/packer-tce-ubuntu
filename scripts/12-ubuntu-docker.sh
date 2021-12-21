#!/bin/bash -eu

#--------------------------------------------------------------------------------------
# Ubuntu OS - Install Docker & Docker Compose [ 12-ubuntu-docker.sh ]
# juliusn - Sun Dec  5 08:48:39 EST 2021 - first version
#--------------------------------------------------------------------------------------

echo "#--------------------------------------------------------------"
echo "# Starting 12-ubuntu-docker.sh"
echo "#--------------------------------------------------------------"

export DEBIAN_FRONTEND="noninteractive"

## Install prerequisites.
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

## Sdd the GPG key for the official Docker repository to your system:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  apt-key add -

## Add the Docker repository to APT sources
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

apt-get update
apt-cache policy docker-ce

## Install Docker
apt-get install -y docker-ce docker-ce-cli 

## Setup daemon.
mkdir -p /etc/docker
mkdir -p /etc/systemd/system/docker.service.d

# https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file
cat << EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ],
  "ipv6": true,
  "fixed-cidr-v6": "2001:db8:1::/64"
}
EOF

echo "Enabling Docker..."
systemctl start docker
systemctl start containerd

systemctl enable docker
systemctl enable containerd
docker --version
chmod 666 /var/run/docker.sock

echo "Instaling docker-compose..."
curl -L "https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose
docker-compose --version

echo "Done 12-ubuntu-docker.sh"

