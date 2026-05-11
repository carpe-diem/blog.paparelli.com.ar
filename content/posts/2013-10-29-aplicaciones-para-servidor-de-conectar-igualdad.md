---
title: "Aplicaciones para servidor de Conectar Igualdad"
date: 2013-10-29
description: "Aplicaciones para los servidores del plan Conectar Igualdad: instalación y detalles del proyecto."
tags: ["python", "conectar-igualdad", "gnu/linux"]
categories: ["proyectos"]
author: "Alberto Paparelli"
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: true
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
---

Ya está liberado el CD de instalación para los servidores del plan Conectar Igualdad.

Este proyecto lo realizamos cuando trabajaba en la Cooperativa de Trabajo [Devecoop](https://www.devecoop.com/) Ltda. Surgió de la necesidad de las escuelas de tener disponible en la intranet aplicaciones como WordPress, Moodle, etc. Pero como no todas las escuelas tienen internet, se tuvo que buscar otra solución.

El CD se va a repartir en las escuelas oficialmente, pero desconozco cuándo.

Uno de los puntos que tuvimos que resolver es que el administrador del servidor no tiene permisos para instalar paquetes en la virtual, así que no podíamos usar herramientas como pyGTK. Esto lo solucionamos incorporando pyzenity en el código.

En esta versión libre, incorporo la aplicación [ALBA](http://www.proyectoalba.com.ar/) que es un Sistema Informático Abierto de Gestión Unificada para Unidades Educacionales. En la versión oficial, nos pidieron que la saquemos, así que solo está en esta versión libre.

El código está disponible en [GitHub](https://github.com/carpe-diem/conectar-igualdad-server-apps).

Una vez que se eligen y se instalan las aplicaciones, estas están disponibles en la URL del servidor de apps. También ahí están los manuales.

- Link directo a la [Guía de instalación](https://github.com/carpe-diem/conectar-igualdad-server-apps/raw/master/manuales/Instalacion.pdf)
- Link directo al [Detalle de aplicaciones](https://github.com/carpe-diem/conectar-igualdad-server-apps/raw/master/manuales/detalles_aplicaciones.pdf)
