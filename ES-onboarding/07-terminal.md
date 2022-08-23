# Cómo "vivir" en el terminal

Unas sugerencias para ayudarte a trabajar en el terminal:

## `alias`

Este comando te permite fácilmente crear atajos para otros comandos. Es particularmente útil para asegurarte de no olvidar una opción. Por ejemplo: 

`alias ll="ls -AlFGgh --color='always'"` crea el comando `ll` que funciona como una versión más detallada de `ls`. Este comando muestra los permisos de archivos, coloca el nombre de cada archivo o directorio en su propia línea, usa un código de colores para representar distintos tipos de archivos, ¡y más!

El resultado generado por `ls`:
```
README.md  bash  setup.md  setup.sh  vim
```

El resultado generado por `ll`: (imagina que tiene colores también)
```
total 28K
-rw-r--r--  1 8.1K Aug  4  2017 .DS_Store
drwxr-xr-x 16  512 Aug 29  2019 .git/
-rw-r--r--  1   35 Jun 21  2018 .gitignore
-rw-r--r--  1   27 Jun 26  2017 README.md
drwxr-xr-x  7  224 Aug 29  2019 bash/
-rw-r--r--  1  494 Jul 12  2018 setup.md
-rw-r--r--  1 3.2K Jul 28  2017 setup.sh
drwxr-xr-x 11  352 Jul 22  2019 vim/
```

También he encontrado útil el siguiente bloque de código: 
```
alias gs="git status"
alias gc="git commit -m"
alias gA="git add -A && git status"
```
Esto refuerza buenas prácticas en git--no se puede hacer un commit al repositorio sin un mensaje de confirmación porque si se ejecuta `gc` solamente, se devolverá un error.

Asegúrate de incluir estos comandos en tu archivo .bashrc para que se ejecuten cada vez que abres tu terminal.

## `tree`

`tree` es un excelente comando que presenta una representación más visual de la estructura de tus archivos. Esto es lo que `tree` devuelve para el mismo directorio que usamos anteriormente:

```
.
├── README.md
├── bash
│   ├── bashrc
│   ├── featherhead.py
│   ├── fromproj.py
│   ├── projpath.py
│   └── toproj.py
├── setup.md
├── setup.sh
└── vim
    ├── UltiSnips
    │   ├── make.snippets
    │   ├── python.snippets
    │   └── yaml.snippets
    ├── ftplugin
    │   ├── make.vim
    │   ├── markdown.vim
    │   └── text.vim
    ├── hi-output
    ├── hi-presets.vim
    ├── parens.vim
    ├── plugs.vim
    ├── process-hi.py
    ├── vimconfigs.sh
    └── vimrc

4 directories, 21 files
```
Dos buenas opciones para `tree` son `-C`, que añade color, y `-L NÚMERO`, que hace que `tree` sólo devuelva los primeros NÚMERO niveles del directorio. Por ejemplo, para el mismo directorio, `tree -L 1` devuelve:

```
.
├── README.md
├── bash
├── setup.md
├── setup.sh
└── vim

2 directories, 3 files
```

## Cómo usar los atajos de teclado de vim en bash

Añade la línea `set -o vi` a tu archivo .bashrc. Este comando utiliza vi en vez de vim, así que faltan algunas de las características a las cuales quizás estés acostumbrado/a (para mí, lo más notable es la falta de objetos de texto, entonces los comandos `ciw` y `da` no funcionan). Otro problema es que no hay una buena forma de saber en qué modo estás trabajando (por defecto es el modo de inserción), así que puede ser confuso a veces.

## `cd -`

`cd -` te regresa al último directorio en el que estuviste. Entonces, si estás trabajando en el directorio `~/git/HRDAG-training` y ejecutas `cd /etc` y después `cd -`, estarás de vuelta en `~/git/HRDAG-training`. Este comando es útil si quieres brevemente saltar a otro directorio para hacer algo.

## Cómo buscar comandos de bash

Escribir CTRL-r en la línea de comandos activa el modo de búsqueda. Este modo básicamente toma lo que escribes y encuentra el comando más reciente que ejecutaste que incluya esa cadena de caracteres. Es útil para ejecutar de nuevo un comando largo que ejecutaste hace poco.

<!-- done. -->
