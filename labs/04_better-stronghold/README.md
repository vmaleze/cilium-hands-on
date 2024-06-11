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

# Can you redirect 10% of the orcs to the better stronghold ?

Let's use the `CiliumEnvoyConfig` to do this.  
You can use the following examples to help you.

<details>
<summary>Routing configuration</summary>

```yaml
apiVersion: cilium.io/v2
kind: CiliumEnvoyConfig
metadata:
  name: envoy-lb-listener
spec:
  services:
    - name: facade-service
      namespace: myns
  backendServices:
    - name: service-1
      namespace: myns
    - name: service-2
      namespace: myns
  resources:
    - "@type": type.googleapis.com/envoy.config.listener.v3.Listener
      name: envoy-lb-listener
      filter_chains:
        - filters:
            - name: envoy.filters.network.http_connection_manager
              typed_config:
                "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
                stat_prefix: envoy-lb-listener
                http_filters:
                  - name: envoy.filters.http.router
                    typed_config:
                      "@type": type.googleapis.com/envoy.extensions.filters.http.router.v3.Router
    - "@type": type.googleapis.com/envoy.config.cluster.v3.Cluster
      name: "myns/service-1"
      connect_timeout: 5s
      lb_policy: ROUND_ROBIN
      type: EDS
      # Should the endpoint be removed from the load balancing set 
      outlier_detection:
        split_external_local_origin_errors: true
        consecutive_local_origin_failure: 2
    - "@type": type.googleapis.com/envoy.config.cluster.v3.Cluster
      name: "myns/service-1"
      connect_timeout: 5s
      lb_policy: ROUND_ROBIN
      type: EDS
      outlier_detection:
        split_external_local_origin_errors: true
        consecutive_local_origin_failure: 2

```
</details>
<br />
<details>
<summary>Trafic switching</summary>

Add the [RDS](https://www.envoyproxy.io/docs/envoy/latest/api-v3/extensions/filters/network/http_connection_manager/v3/http_connection_manager.proto#envoy-v3-api-msg-extensions-filters-network-http-connection-manager-v3-rds) configuration

```yaml
apiVersion: cilium.io/v2
kind: CiliumEnvoyConfig
metadata:
  name: envoy-lb-listener
  ...
  resources:
    - "@type": type.googleapis.com/envoy.config.listener.v3.Listener
      name: envoy-lb-listener
      filter_chains:
        - filters:
            - name: envoy.filters.network.http_connection_manager
              typed_config:
                "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
                ...
                rds:
                  # Name of the route configuration
                  route_config_name: lb_route
    - "@type": type.googleapis.com/envoy.config.route.v3.RouteConfiguration
      name: lb_route
      virtual_hosts:
        - name: "lb_route"
          domains: [ "*" ]
          routes:
            - match:
                prefix: "/"
              route:
                weighted_clusters:
                  clusters:
                    - name: "myns/service-1"
                      weight: 50
                    - name: "myns/service-2"
                      weight: 50
                retry_policy:
                  retry_on: 5xx
                  num_retries: 3
                  per_try_timeout: 1s
```
</details>


#### More info

* [Envoy Traffic Shifting](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_conn_man/traffic_splitting)
* [L7 Traffic Shifting example](https://docs.cilium.io/en/latest/network/servicemesh/envoy-traffic-shifting/)
* [Outlier Detection](https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/upstream/outlier)

<details>
<summary>Solution</summary>

```bash
kubectl apply -f https://raw.githubusercontent.com/vmaleze/cilium-hands-on/main/deployments/cilium-better-stronghold.yaml

# The following request should give you simple weapons 90% of the time.
# 10% of the time, you get a SUPER/BLOOD/MAGICAL weapon
kubectl exec deploy/orc -- curl -s -XGET http://localhost:8080/fetch-weapon
```
</details>
