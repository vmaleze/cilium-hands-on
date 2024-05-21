The simple stronghold can now handle weapon distribution. We can remove the limit we previously added

```bash
kubectl delete ciliumenvoyconfigs.cilium.io/envoy-rate-limit
```

A new version of the stronghold is available. It is delivering better weapons. 

Let's install it :

```bash
kubectl apply -f https://raw.githubusercontent.com/vmaleze/cilium-hands-on/main/deployments/better-stronghold.yaml
```

However, we need to make sure that only a few portion of orcs can reclaim those new weapons as we are not sure that they are suitable for combat.

Can you redirect 10% of the orcs to the better stronghold ?

#### HELP

* [Envoy Traffic Shifting](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_conn_man/traffic_splitting)
* [L7 Traffic Shifting example](https://docs.cilium.io/en/latest/network/servicemesh/envoy-traffic-shifting/)

<details>
<summary>Solution</summary>

```bash
kubectl apply -f https://raw.githubusercontent.com/vmaleze/cilium-hands-on/main/deployments/cilium-better-stronghold.yaml

# The following request should give you simple weapons 90% of the time.
# 10% of the time, you get a SUPER/BLOOD/MAGICAL weapon
kubectl exec deploy/orc -- curl -s -XGET http://localhost:8080/fetch-weapon
```
</details>
