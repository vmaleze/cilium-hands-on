---
theme: seriph
colorSchema: light
favicon: /cilium.png
background: /garrosh.jpeg
class: text-center
transition: slide-left
title: Cilium Hands On
titleTemplate: Cilium - mpayet & vmaleze
mdc: true
hideInToc: true
---
<img src="/cilium.png" class="absolute-center mt-7rem op-40 z-0"/>

<div  class="absolute z-2">

# Le service mesh à la sauce eBPF
## Cilium - Hands On Lab

</div>

---
title: About Me
layout: about-me
hideInToc: true
speakerName: Vivien MALEZE
speakerTitle: Technical Architect
speakerImage: /profile_cropped.jpeg
speakerCompanyLogo: /ippon.png
orcImage: /orc-vivien.jpeg
---

::details::

* Background java <logos-java />
* +10 ans d'xp
* +6 ans chez Ippon
* Bordeaux, France 🇫🇷
* Sujets du moments
    * Microservices <logos-kubernetes />
    * DevOps 🛠️
* <logos-twitter /> <logos-github-octocat />@vmaleze

---
layout: default
layout: two-cols
classRight: col-span-2 overflow-auto
clicks: 4
---

# Le service mesh ?

<div class="mt-4rem">

<v-clicks>

* Un moyen d'optimiser la communication entre service
* Une couche d'infrastructure *visible* dans votre système
* Des features qui vous sont offertes :
  * Observabilité
  * Sécurité
  * Circuit Breaking
  * Gestion du trafic
  * ...

</v-clicks>

</div>

::right::

<v-clicks>

<img class="flex justify-center mt-4rem" src="/sidecar-sweep.png" />
<div class="flex justify-center" v-after>
Et si on se débarrasait de la partie visible ?
</div>

</v-clicks>

---
layout: image
image: /servicemesh_comparison.png
backgroundSize: contain
---

---
layout: image
image: /network-layers.png
backgroundSize: contain
---

---
layout: image
image: /l3.png
backgroundSize: contain
---

<div class="absolute top-5 left-5">
<h1 class="text-sky-600">Layer 3 : Network / IP </h1>
</div>

---
layout: image
image: /l7.avif
backgroundSize: contain
---

<div class="absolute top-5 left-5">
<h1 class="text-sky-600">Layer 7 : Application </h1>
</div>

<div class="absolute bottom-0 right-1">
<p class="text-sky-600">Credit: aurelie vache</p>
</div>

---
layout: image
image: /cilium-l7.png
backgroundSize: contain
---
---
layout: image
image: /garrosh-work.jpeg
backgroundSize: contain
---

<img class="w-1/3 absolute bottom-0 left-0" src="/cilium-bee.png" />