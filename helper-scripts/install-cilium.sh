#!/bin/bash -ex

cd $(dirname $0)
k3s-uninstall.sh || echo "pas d'installation précédente de k3s"

# --disable-kube-proxy: Cilium peut remplacer kube-proxy
# --disable traefik: ne pas utiliser le ingress controller embarqué par k3s, car nous allons installer l'ingress controller de cilium
# --write-kubeconfig-mode=666 -o /home/ubuntu/.kube/config: façon quick & dirty pour faire pointer kubectl vers l'installation k3s, ne mettez pas le kubeconfig en 666 dans la vraie vie :)
# --disable-network-policy: comme conseillé dans la documentation de cilium désactiver la gestion des network policy embarqué dans k3s pour ne pas rentrer en conflit avec celle de cilium
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--flannel-backend=none 
        --disable-network-policy
        --disable-kube-proxy
        --disable traefik 
        --write-kubeconfig-mode=666 
        -o /home/ubuntu/.kube/config" sh - 


# --set=ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16": c'est le CIDR par défaut utilisé par k3s, nous mettons le même pour que le CNI Cilium alloue des IPs dans le range prévue par défaut par k3s
# --set k8sServiceHost=$(curl http://169.254.169.254/latest/meta-data/local-ipv4) appel à l'API AWS pour récupérer l'ip privé de l'EC2 sur laquelle tourne ce k3s, on aurait pu également utiliser ip addr pour trouver l'ip
# --set ingressController.enabled=true: installer l'ingress controller de cilium
# --set ingressController.loadbalancerMode=shared: utiliser un loadbalancer partagé entre tous les ingress déployés, l'alternative est dedicated, qui va créer un LB par ingress, l'un ou l'autre dépend de l'environnement de déploiement (un LB par ingress aura du sens dans un environnement cloud par exemple)
# --set ingressController.default=true: définir l'ingress controller de cilium comme celui par défaut si il n'y a pas d'ingressClassName de défini dans la ressource ingress
cilium install --version 1.15.4 --set=ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16" \
                                --set k8sServiceHost=$(curl http://169.254.169.254/latest/meta-data/local-ipv4) \
                                --set k8sServicePort=6443 \
                                --set ingressController.enabled=true \
                                --set ingressController.loadbalancerMode=dedicated \
                                --set ingressController.default=true

# on attend la fin de l'installation de cilium
cilium status --wait

# on regarde que l'installation a bien remplacé kube-proxy
kubectl -n kube-system exec ds/cilium -- cilium-dbg status | grep KubeProxyReplacement

# Déploiement simple pour nous assurer que l'on est capable d'accéder à un pod à travers un service, ce qui veut dire que Cilium a été capable de fournir une IP au pod, et configuré la connectivité avec eBPF :)
kubectl apply -f test-deploy/nginx-deployment.yaml
kubectl expose deployment my-nginx --type=NodePort --port=80
kubectl get svc my-nginx
