public_ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
private_ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

cilium install --version 1.15.4 \
    --set ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16" \
    --set ingressController.enabled=true \
    --set ingressController.loadbalancerMode=shared

#CILIUM_VERSION="1.15.4"
#helm repo add cilium https://helm.cilium.io/
#helm upgrade --install cilium cilium/cilium --version=${CILIUM_VERSION} \
#    --set global.tag="v${CILIUM_VERSION}" --set global.containerRuntime.integration="containerd" \
#    --set global.containerRuntime.socketPath="/var/run/k3s/containerd/containerd.sock" \
#    --set ingressController.enabled=true \
#    --set ingressController.default=true \
#    --set k8sServiceHost=$private_ip \
#    --set k8sServicePort=6443 \
#    --set ingressController.loadbalancerMode=shared \
#    --set gatewayAPI.enabled=true \
#    --namespace kube-system \
#    --wait
#    --namespace cilium \
#    --create-namespace \



#    --set global.kubeProxyReplacement="strict" \
#    --set global.bpf.masquerade="true" \