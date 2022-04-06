# Tasks

At HRDAG, our projects have a lot of what we call "more-than-twos." We have more than two programmers working on it, more than two datasets, or more than two programming languages. To handle all this complexity, we impose structure onto the project: tasks. A task represents one step on the journey from the original datasets to the final analysis.

Tasks, at a minimum, have three directories: `input/`, `src/`, and `output/`. `input/` contains the initial data, and should be read only. `src/` is how Unix spells "source," and so contains the source code that processes the data. `output/` contains the output files, and should only have files generated from running the code in `src/`.

There are other directories that might be in a task as well. Here they are:
* `note/` contains prototyping notebooks (e.g., from jupyter or RStudio).
* `hand/` contains hand-made files, like a csv that translates from city/state (or municipio/departemento) to a numerical geocode.
* `frozen/` contains data files that don't fit in `input/` or `output/`. This will happen when the data is so broken that our open source tools can't deal with it, and so we have to hand-edit it or use another program to open and resave it.
* `doc/` contains documentation.

Tasks generally chain together, so that the output from one task becomes the input of the next. By convention, every branch starts with an `import/` task that converts the file into the correct format for our operations and an `export/` task that converts it to the correct format for whatever the final product is. Importantly, these tasks exist even when the data is already in the correct format. That means that, when you visit the project in six months, you still know where it starts and where it ends.

Read [The Task Is A Quantum of Workflow](https://hrdag.org/2016/06/14/the-task-is-a-quantum-of-workflow/) and watch [Patrick Ball: Principled Data Processing](https://www.youtube.com/watch?v=ZSunU9GQdcI) for more information on this approach.
