# Develop

## Install k3d with cilium on macos

```bash
k3d cluster create --agents 2 --k3s-arg "--disable-network-policy@server:*" --k3s-arg "--flannel-backend=none@server:*"

kubectl get nodes -o custom-columns=NAME:.metadata.name --no-headers=true | xargs -I {} docker exec {} mount bpffs /sys/fs/bpf -t bpf
kubectl get nodes -o custom-columns=NAME:.metadata.name --no-headers=true | xargs -I {} docker exec {} mount --make-shared /sys/fs/bpf

cilium install
cilium hubble enable --ui
```
