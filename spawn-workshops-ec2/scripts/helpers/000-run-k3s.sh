#!/bin/bash -x

nohup sudo k3s server --flannel-backend=none --disable traefik -o ~/.kube/config --write-kubeconfig-mode=666 &

#--node-external-ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4) sh 