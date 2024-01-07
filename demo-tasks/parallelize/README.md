# parallel-ize
This subdirectory contains an example project structure for record linkage. The
goal of record linkage is to take an input database where multiple records may
refer to the same person (very common if you're integrating multiple data
sources), and output a dataset that has one row per distinct person, by linking
co-referent records and using their content to assemble a synthetic "entity"
record.

This subdirectory contains an example evolution from a serial approach to a multi-threaded approach, modeled with a couple different setups. The goal of parallelization is to improve the performance of some code and its utilization of available resources by sharing work that can be done more efficiently as separate processes. Along with this development comes questions about how to measure performance, as well as how different methodology and tools underlying the task can influence it.

## Background
- assumptions about use cases / the user
- review of serial methods (the assumed current standard)
- overview of the goals / components of this demo-task
    * levanshtein distance between string values

## Current
* Rmd review doc (tempted to do both Rmd and ipynb)

- levanshtein distance on string pairs
- python and R implementations
- single thread
- external profiling
    - `time`
    - `hyperfine`
- internal profiling
    - python: `cProfile`, `pstats`, `line_profiler`(?) (mention `snakeviz`)
    - R: `bench`, `microbenchmark`

## Parallelized
* Rmd review doc

- using Makefile (is this intuitive, or should we lead with python or R?)
- revising serial approach to parallelize for python, R
- using Julia

## Experiment
- metric: total time
- method: python/R/Julia
- nthreads: 1/2/4/32/64/127

## Results
- review the experiment (it should be a file or set of files to load into a table)

## Thoughts
- suggestions/conclusion/summary/etc.