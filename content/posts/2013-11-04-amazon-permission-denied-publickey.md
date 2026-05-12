---
title: "Permission denied en AWS"
date: 2013-11-04
description: "Cómo solucionar el error 'Permission denied (publickey)' al conectarse por SSH a una instancia EC2."
tags: ["aws", "ec2", "linux", "ssh", "troubleshooting"]
categories: ["devops"]
author: "Alberto Paparelli"
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: true
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
cover:
  image: "/images/amazon-permission-denied-publickey.png"
  alt: "Amazon Permission denied (publickey)"
  relative: false
---

El otro día tenía que hacer un deploy de una aplicación en el servidor de un cliente en Amazon. Al intentar acceder por SSH, recibía como respuesta `Permission denied (publickey)`.

No podía acceder de ninguna otra manera. Tuve que hacer algunos pasos para solucionarlo.

Mi problema era que alguien cambió los permisos del home, incluyendo el directorio `~/.ssh/`.

## Cómo lo solucioné

- Parar la instancia.
- Ir a Volumes, encontrar el disco de la instancia con problemas y hacer "Detach".
- Si no tenés otra instancia, crear una micro instancia y hacer "Attach volume".

![Amazon Permission denied (publickey)](/images/amazon-permission-denied-publickey.png)

- El disco ya está montado en la nueva instancia, así que podés debugear hasta encontrar el problema.
- Detach de la nueva instancia.
- Attach a la instancia vieja. En este caso, el punto de montaje debe ser `/dev/sda1` (como estaba antes).
- Iniciar nuevamente la instancia.
