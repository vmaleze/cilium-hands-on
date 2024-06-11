Garrosh is pleased with your work. You have correctly set up his base.  

He would now like to secure its stronghold.

## Make sure that only orcs can access the stronghold !
  
Filthy humans shouldn't event be able to approach the stronghold

To do this, you need to create a Cilium Network Policy
<details>
<summary>Here is an example to secure your resources</summary>

```yaml
apiVersion: "cilium.io/v2"
kind: CiliumNetworkPolicy
metadata:
  # Component name
  name: "secure-stronghold"
spec:
  # The policy will apply to all resources with the following labels
  endpointSelector:
    matchLabels:
      role: backend
  ingress:
  - fromEndpoints:
    # Only resources with the following labels are allowed to access the resource
    - matchLabels:
        role: frontend
```

</details>

# Make sure that no orcs can promote himself as a king ! Garrosh is the only king

The stronghold is safe from humans.  
However, there is a `new-king` route that allows to define a new king.  
Garrosh asks you to only open the `weapons` route to the stronghold so that orcs can only get weapons from the stronghold.

<details>
<summary>Let's improve our CiliumNetworkPolicy</summary>

```yaml
ingress:
  - fromEndpoints:
    - matchLabels:
        ...
    toPorts:
    - ports:
      # Policy applies to this port
      - port: "80"
        protocol: TCP
      rules:
        # Policy applies to this http route
        http:
        - method: "GET"
          path: "/public"
```

</details>

#### More info
* [Cilium Network Policy](https://docs.cilium.io/en/latest/security/policy/)
* [Endpoints Policy](https://docs.cilium.io/en/latest/security/policy/language/#endpoints-based)
* [HTTP Policy](https://docs.cilium.io/en/latest/security/policy/language/#http)

#### NOTES

Labels of the stronghold:
```yaml
  labels:
    class: stronghold
```

Labels of the orcs:
```yaml
  labels:
    app.kubernetes.io/name: orc
```

Labels of the humans:
```yaml
  labels:
    app.kubernetes.io/name: human
```


<details>
<summary>Solution</summary>

```bash
kubectl apply -f https://raw.githubusercontent.com/vmaleze/cilium-hands-on/main/deployments/cilium-secure-stronghold.yaml

# The following request should success
kubectl exec deploy/orc -- curl -s -XGET http://localhost:8080/fetch-weapon

# The following requests should fail
kubectl exec deploy/human -- curl -s -XGET http://localhost:8080/fetch-weapon
kubectl exec deploy/orc -- curl -s -XGET http://stronghold:8080/new-king?kingName=Thuldemm
```

</details>

## NEXT

[Limit too many access to the stronghold](../03_too-many-request/README.md)