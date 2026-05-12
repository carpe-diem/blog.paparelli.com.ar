---
title: "Corrector ortográfico para Vim"
date: 2019-10-20
description: "Cómo habilitar el corrector ortográfico en Vim, con soporte para español e inglés."
tags: ["vim", "linux", "spell-check", "config"]
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
  image: "/images/corrector-ortografico-para-vim-1.png"
  alt: "Corrector ortográfico para Vim"
  relative: false
---

Los que me conocen o trabajaron conmigo saben que me gusta mucho la consola, ya que me resulta más cómodo y rápido para trabajar. Y además uso Vim para programar.

Cuando empecé a probar Nikola para el blog, me gustó la idea de poder escribir los posts en Vim, pero me resultaba tedioso revisar si me faltaba algún acento o si se me escapaba alguna falta de ortografía.

Así fue como llegué a esta funcionalidad de Vim.

![Corrector ortográfico para Vim](/images/corrector-ortografico-para-vim-1.png)

## Spell

El soporte para el corrector ortográfico se agregó en Vim 7.

## Configuración

Para habilitarlo:

```vim
:set spell
```

Para habilitarlo en inglés:

```vim
:set spell spelllang=en_us
```

Para habilitarlo en español, primero hay que descargar el diccionario:

```bash
cd /usr/share/vim/vim81/spell/
wget http://ftp.vim.org/vim/runtime/spell/es.utf-8.spl
```

Luego habilitarlo:

```vim
:set spell spelllang=es
```

Una vez habilitado, se marcarán los errores y las sugerencias de sintaxis. Situados en modo normal sobre la palabra con error, al escribir `z=` saldrá una lista de palabras recomendadas para su reemplazo.

![Corrector ortográfico para Vim - sugerencias](/images/corrector-ortografico-para-vim-2.png)

## Comandos útiles

| Comando | Descripción |
|---------|-------------|
| `[s`    | Ir al próximo error |
| `]s`    | Ir al error anterior |
| `zg`    | Agrega la palabra al diccionario |
| `zug`   | Elimina la palabra del diccionario |
| `z=`    | Despliega lista de opciones para reemplazar la palabra |

Documentación oficial: [Vim spell](http://vimdoc.sourceforge.net/htmldoc/spell.html)
