Garrosh is pleased with your work. You have correctly set up his base.  

He would now like to secure its stronghold.

* Can you make sure that only orcs can access the stronghold ?  
  Filthy humans shouldn't event be able to approach the stronghold
* Can you also make sure that no orcs can promote himself as a king ? Garrosh is the only king

#### HELP
* [Cilium Network Policy](https://docs.cilium.io/en/latest/security/policy/)
* [Endpoints Policy](https://docs.cilium.io/en/latest/security/policy/language/#endpoints-based)
* [HTTP Policy](https://docs.cilium.io/en/latest/security/policy/language/#http)

#### NOTES

The API documentation of the stronghold is available here (TODO)

Labels of the stronghold:
```yaml
  labels:
    class: stronghold
    version: v1
    app.kubernetes.io/name: simple-stronghold
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
