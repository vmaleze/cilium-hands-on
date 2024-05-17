#!/bin/bash -x

#nohup sudo k3s server \
#    --disable-network-policy \
#    --flannel-backend=none \
#    --disable traefik \
#    -o ~/.kube/config \
#    --node-external-ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4) \
#    --node-ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4) \
#    --write-kubeconfig-mode=666 &

#--node-external-ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4) sh 
k3s-uninstall.sh
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--flannel-backend=none
 --disable servicelb 
 --disable-network-policy 
 --disable-cloud-controller
 --disable traefik 
 --write-kubeconfig-mode=666 

 -o ~/.kube/config" sh -



