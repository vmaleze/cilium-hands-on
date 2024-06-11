# Trainers doc

## Spawn new EC2 clusters

To spawn ec2 clusters, simply edit the `spawn-workshops-ec2/terraform.tfvars` file and edit the `ec2_instances` list to add new instances and run the following:

```bash
# Login to AWS
aws sso login

terraform init
terraform apply
```

Once the script finishes, you can find the connection information in the `generated/distribution` folder.  
Share this folder with the participant. Inside, they will find the `run-vscode-with-ssh` script for either windows or linux/macos.  

Running this script will launch vscode with the ssh connection towards the ec2 cluster. (Make sure to install the recommended plugin and allow the ssh connection)


## Install k3d with cilium on macos

```bash
k3d cluster create cilium --agents 2 --k3s-arg "--disable-network-policy@server:*" --k3s-arg "--flannel-backend=none@server:*"

kubectl get nodes -o custom-columns=NAME:.metadata.name --no-headers=true | xargs -I {} docker exec {} mount bpffs /sys/fs/bpf -t bpf
kubectl get nodes -o custom-columns=NAME:.metadata.name --no-headers=true | xargs -I {} docker exec {} mount --make-shared /sys/fs/bpf

cilium install --version 1.15.5 --set kubeProxyReplacement=true --set envoyConfig.enabled=true --set loadBalancer.l7.backend=envoy
cilium hubble enable --ui
```
