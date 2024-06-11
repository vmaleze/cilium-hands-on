Let's begin by creating the base environment for your work.  
As explain in its original request, we need to use Cilium.

Garrosh's shamans have found some documentation that should help you start :

# Install the kubernetes cluster

The first step is to install kubernetes. We will use k3s for this lab.  
As we want to use cilium, we will also make sure to not use k8s network defaults.

```bash
# --disable-kube-proxy: Cilium peut remplacer kube-proxy
# --disable traefik: ne pas utiliser le ingress controller embarqué par k3s, car nous allons installer l'ingress controller de cilium
#--write-kubeconfig-mode=666 -o /home/ubuntu/.kube/config: façon quick & dirty pour faire pointer kubectl vers l'installation k3s, ne mettez pas le kubeconfig en 666 dans la vraie vie :)
# --disable-network-policy: comme conseillé dans la documentation de cilium désactiver la gestion des network policy embarqué dans k3s pour ne pas rentrer en conflit avec celle de cilium
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--flannel-backend=none 
        --disable-network-policy
        --disable-kube-proxy
        --disable traefik 
        --write-kubeconfig-mode=666 
        -o /home/ubuntu/.kube/config" sh - 
```

# Install Cilium

Once the cluster ise ready, let's add cilium on top of it
```bash
# --set=ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16": c'est le CIDR par défaut utilisé par k3s, nous mettons le même pour que le CNI Cilium alloue des IPs dans le range prévue par défaut par k3s
# --set k8sServiceHost=$(curl http://169.254.169.254/latest/meta-data/local-ipv4) appel à l'API AWS pour récupérer l'ip privé de l'EC2 sur laquelle tourne ce k3s, on aurait pu également utiliser ip addr pour trouver l'ip
# --set ingressController.enabled=true: installer l'ingress controller de cilium
# --set ingressController.loadbalancerMode=shared: utiliser un loadbalancer partagé entre tous les ingress déployés, l'alternative est dedicated, qui va créer un LB par ingress, l'un ou l'autre dépend de l'environnement de déploiement (un LB par ingress aura du sens dans un environnement cloud par exemple)
# --set ingressController.default=true: définir l'ingress controller de cilium comme celui par défaut si il n'y a pas d'ingressClassName de défini dans la ressource ingress
cilium install --version 1.15.5 --set=ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16" \
                                --set k8sServiceHost=$(curl http://169.254.169.254/latest/meta-data/local-ipv4) \
                                --set k8sServicePort=6443 \
                                --set ingressController.enabled=true \
                                --set ingressController.loadbalancerMode=dedicated \
                                --set ingressController.default=true
```

Wait for the installation
```bash
cilium status --wait
```

Once the environment is ready, let's create our realm and some resources to it :

```bash
kubectl create ns azeroth
kubectl config set-context --current --namespace=azeroth

kubectl apply -f https://raw.githubusercontent.com/vmaleze/cilium-hands-on/main/deployments/simple-stronghold.yaml
kubectl apply -f https://raw.githubusercontent.com/vmaleze/cilium-hands-on/main/deployments/orc.yaml
```

Orcs should now be able to fetch weapons from the stronghold

```bash
kubectl exec deploy/orc -- curl -s -XGET http://localhost:8080/fetch-weapon
```

Let's see this with a bigger picture by activating [hubble](https://docs.cilium.io/en/latest/gettingstarted/hubble/#service-map-hubble-ui)

```bash
cilium hubble enable --ui
```

<details>
<summary>A wild human is now trying to access the stronghold</summary>


```bash
kubectl apply -f https://raw.githubusercontent.com/vmaleze/cilium-hands-on/main/deployments/human.yaml
kubectl exec deploy/human -- curl -s -XGET http://localhost:8080/fetch-weapon
```

Oh ! No ! The stronghold was destroyed...

Garrosh urges you to do something about this.

## NEXT
[Let's secure the stronghold](../02_secure-stronghold/README.md)

</details>
