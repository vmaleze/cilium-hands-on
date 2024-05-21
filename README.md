# Le service mesh à la sauce eBPF

Ce projet contient toutes les resources nécessaires pour le workshop.  
La documentation est en anglais.

## Abstract
La horde des orcs cherche à améliorer ses communications internes.
Elle aimerait beaucoup pouvoir faire du service mesh pour mieux gérer ses troupes au sein de sa forteresse kubernetes.

Garrosh Hurlenfer a déjà entendu parler de Istio et d'autres solutions basées sur les sidecars mais a toujours hésité à les mettre en place car cela semblait trop compliqué. Avoir des sidecars pour ses orcs ou bien ses bastions lui a toujours paru coûteux par rapport à la plus-value qu'il pouvait en tirer.

Par chance, il a récemment entendu parler de cilium qui propose un service mesh sans sidecar grâce à la technologie eBPF. Mais comment ça marche ? Et comment en profiter de manière efficace ?

La horde cherche donc des volontaires pour venir l'aider à mettre en place son service mesh sans sidecars afin de

Mieux diriger ses orcs vers les bons bastions.
Sécuriser les accès à ses bâtiments
Avoir une meilleure visibilité sur ce qu'il se passe au sein de sa forteresse.
Et surtout comment profiter de tous les avantages du service mesh

## References
Ce workshop a pour but de mettre en place du service mesh basé sur la technologie eBPF grâce à cilium.

L'atelier mêlera pratique et théorie pour bien assimiler les différents concepts. Il se déroulera de la manière suivante :

Généralité sur le service mesh
Introduction à eBPF et cilium
Mise en place d'un cluster kubernetes basé sur k3s avec cilium
Déploiement de services
Observation de l’architecture et du network via Hubble
Mise en place de règles de service mesh
Sécurisation des ressources
Load balancing
Rate limiting
Trouver un use case plus poussé sur le déploiement ?
Démo sur une stratégie de canary release

## Resources

* [slides](slides) - Support of the conference
* [labs](labs) - Labs for the conference
* [deployments](deployments) - Contains all the deployment files and the Cilium configurations
* [microservices](microservices) - Microservices used as example for the labs
* [spawn-workshops-ec2](spawn-workshops-ec2) - Allows to spawn an ec2 environment for the lab if necessary
