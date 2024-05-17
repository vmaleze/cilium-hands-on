#!/bin/bash -ex

cd $(dirname $0)
k3s-uninstall.sh || echo "pas d'installation précédente de k3s"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--flannel-backend=none 
        --disable-network-policy
        --disable-kube-proxy
        --disable-cloud-controller
        --disable traefik 
        --write-kubeconfig-mode=666 
        -o /home/ubuntu/.kube/config" sh - 

cilium install --version 1.15.4 --set=ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16" \
                                --set k8sServiceHost=$(curl http://169.254.169.254/latest/meta-data/local-ipv4) \
                                --set k8sServicePort=6443

cilium status --wait

kubectl -n kube-system exec ds/cilium -- cilium-dbg status | grep KubeProxyReplacement

kubectl apply -f nginx-deployment.yaml
kubectl expose deployment my-nginx --type=NodePort --port=80
kubectl get svc my-nginx