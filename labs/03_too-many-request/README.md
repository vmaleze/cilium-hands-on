Too many orcs are claiming weapons. The stronghold can only produce 10 weapons by minute.

# Make sure that the stronghold only accepts such traffic of orcs !

To allow cilium to be L7 aware, we are going to use Envoy.  
To do this, let's to deploy a `CiliumEnvoyConfig` component to the cluster that will route the trafic to our service

<details>
<summary>Exemple of a router configuration</summary>

```yaml
apiVersion: cilium.io/v2
kind: CiliumEnvoyConfig
metadata:
  name: envoy-rate-limit
spec:
  services:
    # Service that we want to rate-limit
    - name: my-service
      namespace: my-namespace
  resources:
    - "@type": type.googleapis.com/envoy.config.listener.v3.Listener
      name: envoy-lb-listener
      filter_chains:
        - filters:
            - name: envoy.filters.network.http_connection_manager
              typed_config:
                "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
                stat_prefix: envoy-lb-listener
                rds:
                  # Name of the route configuration
                  route_config_name: my_route
                http_filters:
                  - name: envoy.filters.http.router
                    typed_config:
                      "@type": type.googleapis.com/envoy.extensions.filters.http.router.v3.Router
    - "@type": type.googleapis.com/envoy.config.route.v3.RouteConfiguration
      name: my_route
      virtual_hosts:
        - name: "my_route"
          domains: [ "*" ]
          routes:
            - match:
                prefix: "/"
              route:
                # Name of the envoy cluster configuration
                cluster: "my-namespace/my-service"
    - "@type": type.googleapis.com/envoy.config.cluster.v3.Cluster
      name: "my-namespace/my-service"
      connect_timeout: 5s
      lb_policy: ROUND_ROBIN
      type: EDS

```

This only routes the trafic through envoy and applies the `type.googleapis.com/envoy.config.cluster.v3.Cluster` configuration to any http request to the `/` path on the `my-namespace/my-service`
</details>
<br />
<details>
<summary>Let's apply the rate limiter</summary>

```yaml
http_filters:
    - name: envoy.filters.http.local_ratelimit
    typed_config:
        "@type": type.googleapis.com/envoy.extensions.filters.http.local_ratelimit.v3.LocalRateLimit
        stat_prefix: http_local_rate_limiter
        token_bucket:
        # The total number of tokens that can accumulate.
        max_tokens: 10
        # How many tokens are added each fill_interval.
        tokens_per_fill: 10
        # The duration between adding additional tokens to the bucket.
        fill_interval: 60s
        # A percentage of requests to apply the rate limit to. Defaults to 0.
        filter_enabled:
        runtime_key: local_rate_limit_enabled
        default_value:
            numerator: 100
            denominator: HUNDRED
        # The fraction of enabled requests to actually enforce.
        filter_enforced:
        runtime_key: local_rate_limit_enforced
        default_value:
            numerator: 100
            denominator: HUNDRED
        # A header to add when a rate limit is enforced.
        response_headers_to_add:
        - append: true
            header:
            key: x-local-rate-limit
            value: 'true'
```
</details>

#### More info
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

## NEXT

[Deploy and use a better stronghold](../04_better-stronghold/README.md)