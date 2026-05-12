---
title: "Problemas con Notebook Dell (Extraño la ThinkPad)"
date: 2019-10-18
description: "Cómo solucionar el problema del touchpad que deja de funcionar después del suspend en una Dell G3 con Arch Linux."
tags: ["dell", "systemd", "arch-linux", "linux", "hardware", "troubleshooting"]
categories: ["linux"]
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
  image: "/images/problemas-con-notebook-dell-extrano-la-thinkpad.png"
  alt: "Dell G3"
  relative: false
---

Hace un tiempo tuve que comprar una nueva notebook. Mi ThinkPad T430 ya estaba bastante obsoleta.

Por un tema de precios, tuve que desistir de seguir con la línea de Lenovo y opté por una Dell (Dell G3).

Instalé Arch Linux y lo configuré como siempre, y aunque tuve algunos problemas por la compatibilidad de Dell con Linux (por ejemplo, la placa de video), había un solo problema que me volvía loco: cuando cerraba la notebook y pasaba a estado sleep.

![Dell G3](/images/problemas-con-notebook-dell-extrano-la-thinkpad.png)

## El problema

Al "despertarla", el touchpad no respondía. Encontré que volviendo a cargar el módulo `i2c_hid` volvía a funcionar, así que al principio dejaba una consola abierta para hacer:

```bash
modprobe -r i2c_hid
modprobe i2c_hid
```

## La solución definitiva

Luego de unos días, lo solucioné definitivamente. Por un lado, agregué `i2c_hid` en `/etc/suspend-modules.conf`.

Luego creé el archivo `/usr/lib/systemd/system-sleep/suspend-modules` con lo siguiente:

```bash
#!/bin/bash

case $1 in
    pre)
        for mod in $(</etc/suspend-modules.conf); do
            modprobe -r $mod
        done
    ;;
    post)
        for mod in $(</etc/suspend-modules.conf); do
            modprobe $mod
        done
    ;;
esac
```

Con esto, systemd se encarga de descargar y recargar el módulo en cada ciclo de suspend/resume automáticamente.
