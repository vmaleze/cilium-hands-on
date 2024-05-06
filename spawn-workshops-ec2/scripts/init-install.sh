#!/bin/bash -ex

echo "Installation k3s..."
ufw disable
curl -Lo /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.29.4%2Bk3s1/k3s; chmod a+x /usr/local/bin/k3s

echo "Installation de kubectl..."
curl -Lo /usr/local/bin/kubectl https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl; chmod +x /usr/local/bin/kubectl

echo "Installation de Helm"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh


echo "installation de kubectx+kubens"
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens