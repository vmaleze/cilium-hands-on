Let's begin by creating the base environment for your work.  
As explain in its original request, we need to use Cilium.

Garrosh's shamans have found some documentation that should help you start :

* [Quick Start](https://docs.cilium.io/en/latest/gettingstarted/k8s-install-default/#install-cilium)

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

<details>
<summary>A wild human is now trying to access the stronghold</summary>


```bash
kubectl apply -f https://raw.githubusercontent.com/vmaleze/cilium-hands-on/main/deployments/human.yaml
kubectl exec deploy/human -- curl -s -XGET http://localhost:8080/fetch-weapon
```

Oh ! No ! The stronghold was destroyed...

Garrosh urges you to do something about this.

</details>
