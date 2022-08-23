# Tasks

En HRDAG, nuestros proyectos frecuentemente se caracterizan por lo que nosotros llamamos "más de dos". En un mismo proyecto, hay más de dos programadores trabajando y se usan más de dos conjuntos de datos o más de dos lenguajes de programación. Para manejar esta complejidad, implementamos estructura en el proyecto en la forma de tareas, o "tasks". Una tarea representa un paso en el trayecto de los conjuntos de datos desde los datos originales hasta el análisis final. 

Como mínimo, las tareas tienen tres directorios: `input/`, `src/` y `output/`. `input/` incluye los datos iniciales, y debe ser leído solamente. `src/` es la forma que Unix escribe "source" ("fuente""), así que este directorio incluye el código fuente que procesa los datos. `output/` incluye los archivos de salida, y debe contener únicamente los archivos generados al ejecutar el código en `src/`.

También hay otros directorios que a veces existen dentro de una tarea. Estos son:

* `note/` incluye archivos para la prototipación del código fuente (código de jupyter o RStudio, por ejemplo)
* `hand/` incluye archivos generados de forma manual, como un archivo .csv que convierte los nombres de municipios o departamentos en códigos de geolocalización.
* `frozen/` incluye archivos que no caben en `input/` ni `output/`. Esto ocurre cuando los datos están tan defectuosos que nuestras herramientas de fuente abierta no los pueden manejar, entonces los tenemos que editar de forma manual o usar otro programa para abrir y guardarlos de nuevo.
* `doc/` incluye documentación.

Las tareas generalmente se conectan entre sí para que los archivos de salida generados por una tarea sirvan como los archivos de entrada de la siguiente tarea. Normalmente cada rama empieza con la tarea `import/`, que convierte el archivo al formato correcto para nuestras operaciones, y termina con la tarea `export/`, que convierte el archivo al formato correcto para el producto final que queramos. Esto quiere decir que cuando accedes al proyecto en seis meses, todavía sabes dónde empieza y dónde termina.

Lee [The Task Is A Quantum of Workflow](https://hrdag.org/2016/06/14/the-task-is-a-quantum-of-workflow/) y ve [Patrick Ball: Principled Data Processing](https://www.youtube.com/watch?v=ZSunU9GQdcI) para obtener más información sobre la organización de las tareas.
