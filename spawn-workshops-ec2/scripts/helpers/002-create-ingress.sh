#!/bin/bash -ex
kubectl create ingress stronghold-ingress --rule="$(curl http://169.254.169.254/latest/meta-data/public-hostname)/stronghold=stronghold-service:8080" -n azeroth