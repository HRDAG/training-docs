# Bash

Bash es un lenguaje para interactuar con el árbol de procesos y el sistema de archivos de Unix/Linux. Es un tipo de metalenguaje, dentro del cual vive todo lo demás en tu computadora.

Para empezar a trabajar en Bash, intenta lo siguiente:

Abre tu terminal y escribe `cd`. Esto cambiará directorios (las carpetas en Unix se llaman directorios) al directorio 'home', tu directorio personal, único para cada usuario. Ahora, si escribes `ls`, debe aparecer una lista de todos los archivos y directorios dentro de tu directorio 'home'. Esto debe incluir todos los archivos y directorios no ocultos dentro del directorio en el que estés. ¿Y los archivos ocultos? Los archivos ocultos son solamente los que empiezan con un punto (.). Para verlos, usa el comando `ls -a`. Estos 'dotfiles' ocultos serán relevantes después, cuando personalices el entorno de tu terminal.

Puede que ya hayas notado el texto que aparece antes de tus comandos, conocido como el indicador (o 'prompt') del intérprete de comandos. El tuyo probablemente sea algo así: `<nombre-de-computadora>:<directorio> <nombre-de-cuenta>$`. No es recomendable usar un indicador así por varias razones: no tiene color, lo cual ayuda a los ojos a diferenciar entre valores; es difícil de leer; y no incluye tu ruta completa.

Con una ruta completa, se puede saber quién eres, en qué computadora estás trabajando (en eleanor, por ejemplo) y en qué directorio te encuentras (`~/git/GT-fingerprints/individual`). Asímismo, se puede dejar el comando en su propia línea para que quepa aunque sea particularmente larga la ruta del directorio de trabajo. Recomiendo determinar qué tipo de indicador te gustaría tener y después programarlo en tus configuraciones. He aquí unas sugerencias básicas.

1. Asigna la fórmula que quieras a la variable `PS1` en bash.
2. Haz todo tu trabajo en `~/.bashrc`. Este archivo es uno de los 'dotfiles' antes mencionados y se ejecuta automáticamente para que bash pueda ver tus preferencias. Escribir una barra invertida antes de un carácter te permite poner variables en tu indicador. Consulta esta lista para conocer algunas combinaciones: https://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html

Estos enlaces son útiles para empezar a trabajar con Bash:

- http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html
- http://cs.lmu.edu/~ray/notes/bash/
- https://programminghistorian.org/es/lecciones/introduccion-a-bash
- https://www.digitalocean.com/community/tutorials/an-introduction-to-the-linux-terminal
- https://www.tjhsst.edu/~dhyatt/superap/unixcmd.html (las listas "essential", "valuable" y "useful" son buenas-las otras son algo anticuadas)
- https://softcover.s3.amazonaws.com/636/learn_enough_command_line/images/figures/anatomy.png (una imagen que explica la estructura de bash)
- http://tldp.org/LDP/abs/html/ (demasiado detallado, enfocado en programas en vez de la línea de comandos. Podría ser útil como un diccionario)
- https://www.youtube.com/watch?v=oxuRxtrO2Ag&t=3922s


