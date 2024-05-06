CILIUM_VERSION="1.15.4"
helm repo add cilium https://helm.cilium.io/
helm upgrade --install cilium cilium/cilium --version=${CILIUM_VERSION} \
    --set global.tag="v${CILIUM_VERSION}" --set global.containerRuntime.integration="containerd" \
    --set global.containerRuntime.socketPath="/var/run/k3s/containerd/containerd.sock" \
    --set global.kubeProxyReplacement="strict" \
    --set global.bpf.masquerade="true" \
    --set ingressController.enabled=true \
    --set ingressController.default=true \
    --namespace cilium \
    --create-namespace \
    --wait