Too many orcs are claiming weapons. The stronghold can only produce 10 weapons by minute.

* Can you make sure that the stronghold only accepts such traffic of orcs ?

#### HELP
* [Cilium L7-Aware](https://docs.cilium.io/en/latest/network/servicemesh/l7-traffic-management/)
* [Envoy Local Rate Limiting](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/local_rate_limit_filter)
* [Circuit Breaker example](https://docs.cilium.io/en/latest/network/servicemesh/envoy-circuit-breaker/)

<details>
<summary>Solution</summary>

```bash
kubectl apply -f https://raw.githubusercontent.com/vmaleze/cilium-hands-on/main/deployments/cilium-too-many-request.yaml

# The following request should success 10 times in one minute. 
# On the 11th call, you should have an error.
# Wait one minute and retry too check that it's working correctly
kubectl exec deploy/orc -- curl -s -XGET http://stronghold:8080/weapons
```
</details>
