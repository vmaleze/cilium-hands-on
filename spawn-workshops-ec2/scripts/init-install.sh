#!/bin/bash -ex

#echo "Docker install..."
#curl -fsSL https://get.docker.com -o get-docker.sh
#sudo sh ./get-docker.sh --dry-run
#sudo usermod -aG docker ubuntu


echo "Installation k3s..."
ufw disable
curl -Lo /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.29.4%2Bk3s1/k3s; chmod a+x /usr/local/bin/k3s

echo "Installation de kubectl..."
curl -Lo /usr/local/bin/kubectl https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl; chmod +x /usr/local/bin/kubectl