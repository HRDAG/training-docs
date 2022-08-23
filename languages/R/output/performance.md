R Performance tips
================

- <a href="#the-main-rules" id="toc-the-main-rules">The main rules</a>
- <a href="#for-loops-" id="toc-for-loops-">For loops …</a>
- <a href="#---vs-multicore-processing---"
  id="toc----vs-multicore-processing---">. . . vs multicore processing . .
  .</a>
- <a href="#-vs-vectorization" id="toc--vs-vectorization">…
  vs. vectorization</a>
- <a href="#lookupcanonicalize"
  id="toc-lookupcanonicalize">lookup/canonicalize</a>
- <a href="#copy-on-modify" id="toc-copy-on-modify">copy-on-modify</a>
- <a href="#use-efficient-packages-andor-built-in-functionality"
  id="toc-use-efficient-packages-andor-built-in-functionality">Use
  efficient packages and/or built-in functionality</a>
- <a href="#compile-if-you-need" id="toc-compile-if-you-need">Compile if
  you need</a>
- <a href="#a-note-about-parallelism" id="toc-a-note-about-parallelism">A
  note about parallelism</a>
- <a href="#a-note-about-data-frames" id="toc-a-note-about-data-frames">A
  note about data frames</a>
  - <a href="#the-two-kinds-of-in-memory-data-frames"
    id="toc-the-two-kinds-of-in-memory-data-frames">The two kinds of
    in-memory data frames</a>
  - <a href="#memory" id="toc-memory">memory</a>
  - <a href="#misc" id="toc-misc">misc</a>
  - <a
    href="#example-free-speedups-by-replacing-dataframetibble-with-datatable"
    id="toc-example-free-speedups-by-replacing-dataframetibble-with-datatable">example:
    free speedups by replacing <code>data.frame/tibble</code> with
    <code>data.table</code></a>
- <a href="#further-reading" id="toc-further-reading">Further reading</a>

# The main rules

1.  Don’t optimize prematurely. Try to write code that is clear and
    expressive, and that utilizes some of the common idioms of the R
    language (specifically, see rule 2), and turn to performance tuning
    when you encounter bottlenecks.
2.  Vectorized operations on atomic vectors that fit comfortably in main
    memory are fast. With few exceptions, all functions that operate on
    atomic data types (integers, doubles, strings, factors) are
    vectorized. So write code that takes advantage of this fact. Also,
    linear algebra operations on dense matrices that fit in memory, are
    fast (including arithmetic but also solving/inverting matrices,
    singular value decomposition, and so forth).
3.  R is at its best when used as a “glue language”, scripting together
    calls to specific algorithms that have been implemented performantly
    in FORTRAN, C, etc. A lot has already been implemented, and it’s
    worth finding and using these implementations. If you encounter a
    performance bottleneck that can’t be refactored into calls to
    library functions, the [`Rcpp`](https://www.rcpp.org/) package makes
    it convenient to sprinkle performant C++ into your R code at key
    locations.
4.  When performance tuning, be empirical: set up controlled experiments
    (using actual data) and measure time/memory requirements for
    different solutions using one of the `microbenchmark` or `bench`
    packages. In particular, be sure to identify the correct areas for
    improvement: getting a 100x speedup on part of your code that was
    only responsible for 1% of the overall time taken by the script will
    not make much of a difference.

# For loops …

Are for loops slower than `*-apply` or `purrr::map_*`? In this
experiment, we want to search a collection of strings for the
case-insensitive pattern “waldo”.

``` r
library(stringi)

make_test_strings <- function(n) {
    prfx  <- stringi::stri_rand_strings(n, sample(10:20,      n, replace = T))
    suffx <- stringi::stri_rand_strings(n, sample(10:20,      n, replace = T))
    waldo <- sample(c("Waldo", "WALDO", "waldo", "", "", ""), n, replace = T)
    paste0(prfx, waldo, suffx)
}

small <- make_test_strings(1000)
large <- make_test_strings(100000)
```

To start, we’ll compare a for loop, the base R function `vapply`, and
the corresponding function from the `purrr` package. To make our task
precise, we want to return a logical vector that is `TRUE` for indices
where the pattern matched, and `FALSE` otherwise

``` r
library(bench)
library(dplyr)
library(purrr)
library(stringr)

# `check` verifies that the results are the same for each expression
bm <- function(...) bench::mark(..., check = TRUE) %>%
        select(expression, min, median, mem_alloc)

waldo_pattern <- regex("waldo", ignore_case = TRUE)

loop_version <- function(strings, pattern = waldo_pattern) {
    # always pre-allocate results!
    out <- vector("logical", length = length(strings))
    for (i in seq_along(strings)) out[i] <- str_detect(strings[i], pattern)
    out
}

purrr_version <- function(strings, pattern = waldo_pattern)
    map_lgl(strings, str_detect, pattern = pattern)

vapply_version <- function(strings, pattern = waldo_pattern)
    vapply(strings, str_detect,
           FUN.VALUE = logical(1), USE.NAMES = FALSE,
           pattern = pattern)

bm(
    loop_version(small),
    vapply_version(small),
    purrr_version(small),
)
```

    ## # A tibble: 3 × 4
    ##   expression                 min   median mem_alloc
    ##   <bch:expr>            <bch:tm> <bch:tm> <bch:byt>
    ## 1 loop_version(small)     6.64ms    6.7ms   53.62KB
    ## 2 vapply_version(small)   6.53ms    6.6ms    3.95KB
    ## 3 purrr_version(small)    6.55ms   6.61ms   18.02KB

# . . . vs multicore processing . . .

As long as I pre-allocate results, there is no real difference in
performance between a for-loop and using a higher-order function. The
main advantage of the `purrr_version` is not performance, but rather it
is easier to read and debug. It also has the benefit of being
straightforwardly parallelizable (for more on the use of parallelism to
improve performance, see the [note on
parallelism](#a-note-about-parallelism)):

``` r
library(furrr)

multi_version <- function(strings, pattern = waldo_pattern, strategy) {
    plan(strategy)
    on.exit(plan("default"))
    future_map_lgl(strings, str_detect, pattern = pattern)
}

# note we can't memory profile multi-core code with `bench`:
bm(
    purrr_version(large),
    multi_version(large, strategy = multicore),
    memory = FALSE
)
```

    ## # A tibble: 2 × 4
    ##   expression                                      min   median mem_alloc
    ##   <bch:expr>                                 <bch:tm> <bch:tm> <bch:byt>
    ## 1 purrr_version(large)                          929ms    929ms        NA
    ## 2 multi_version(large, strategy = multicore)    237ms    246ms        NA

# … vs. vectorization

The reason for-loops in R have the reputation of being slow is that they
are usually redundant. The functions we’re calling are already
vectorized, as per rule 2:

``` r
vectorized_version <- function(s, p = waldo_pattern) str_detect(s, p)

bm(
    purrr_version(small),
    multi_version(small, strategy = multicore),
    vectorized_version(small),
    memory = FALSE
)
```

    ## # A tibble: 3 × 4
    ##   expression                                      min   median mem_alloc
    ##   <bch:expr>                                 <bch:tm> <bch:tm> <bch:byt>
    ## 1 purrr_version(small)                         6.49ms   6.56ms        NA
    ## 2 multi_version(small, strategy = multicore)  80.85ms  81.67ms        NA
    ## 3 vectorized_version(small)                  179.78µs 183.52µs        NA

These speedups are still present in the face of larger data:

``` r
bm(
    purrr_version(large),
    multi_version(large, strategy = multicore),
    vectorized_version(large),
    memory = FALSE
)
```

    ## # A tibble: 3 × 4
    ##   expression                                      min   median mem_alloc
    ##   <bch:expr>                                 <bch:tm> <bch:tm> <bch:byt>
    ## 1 purrr_version(large)                        754.8ms  754.8ms        NA
    ## 2 multi_version(large, strategy = multicore)  245.8ms  246.4ms        NA
    ## 3 vectorized_version(large)                    18.3ms   18.4ms        NA

Finally, notice that even if our task only requires counting the number
of matches, allocating the full logical vector using the vectorized
version of `str_detect` is still faster than a for loop that does not
make unnecessary allocations:

``` r
noalloc_version <- function(strings, pattern = waldo_pattern) {
    total <- 0
    for (s in strings) total <- total + str_detect(s, pattern)
    return(total)
}

bm(
   noalloc_version(large),
   sum(vectorized_version(large))
)
```

    ## # A tibble: 2 × 4
    ##   expression                          min   median mem_alloc
    ##   <bch:expr>                     <bch:tm> <bch:tm> <bch:byt>
    ## 1 noalloc_version(large)          743.6ms  743.6ms    17.1KB
    ## 2 sum(vectorized_version(large))   18.4ms   18.5ms   390.7KB

# lookup/canonicalize

A common data-cleaning operation is to take unstandardized input values
and map them to a known controlled vocabulary for further analysis. Here
we build a list of keys and values to be used for bulk replacement:

``` r
make_lookup_example <- function(n, n_uniq_orig, n_uniq_canon) {
    unstandard <- stri_rand_strings(n_uniq_orig, 25, pattern = "[A-Za-z]")
    canon <- stri_rand_strings(n_uniq_canon, 10, pattern = "[a-z]")
    kv_pairs <- list(keys = unstandard,
                     values = sample(canon, n_uniq_orig, replace = TRUE))
    list(data = sample(unstandard, n, replace = TRUE),
         kv = kv_pairs)
}

# this example has 1,000 unique unstandardized values, some of which repeat,
# for a total of 5,000 records of input data. Each unique unstandardized value
# is mapped to one of 25 canonical values:
test_data <- make_lookup_example(5000, 1000, 25)
```

Indexing into a named vector requires a linear scan through the names of
the vector until a match is found. It would make sense that a hash-table
lookup, which can be performed in constant time, is faster:

``` r
vec_dict <- set_names(test_data$kv$values, test_data$kv$keys)

# we could also have used: list2env(as.list(vec_dict), hash = TRUE)
hash_dict <- new.env(hash = TRUE, parent = emptyenv())
walk2(test_data$kv$keys, test_data$kv$values, assign, envir = hash_dict)

k <- sample(test_data$data, 1)

bm(
    vec_dict[[k]],
    hash_dict[[k]]
)
```

    ## # A tibble: 2 × 4
    ##   expression          min   median mem_alloc
    ##   <bch:expr>     <bch:tm> <bch:tm> <bch:byt>
    ## 1 vec_dict[[k]]      82ns    164ns        0B
    ## 2 hash_dict[[k]]        0     41ns        0B

However, for the common scenario where we have to lookup and replace an
entire column of values, rule 2 is still in effect. Here `unname` and
`as.character` are formalities required to make sure the output formats
are the same, so that the results pass the equality test, but they do
not meaningfully alter the measurement results:

``` r
bm(
    vec = unname(vec_dict[test_data$data]),
    hash = as.character(mget(test_data$data, envir = hash_dict))
)
```

    ## # A tibble: 2 × 4
    ##   expression      min   median mem_alloc
    ##   <bch:expr> <bch:tm> <bch:tm> <bch:byt>
    ## 1 vec           123µs    132µs   152.8KB
    ## 2 hash          624µs    639µs    78.2KB

# copy-on-modify

One of the primary drivers of performance issues in R code has to do
with the fact that R makes a *lot* of copies. As an illustrative
example, consider this bit of code:

``` r
myvec <- letters[1:10]
modify_vec <- function(vec) {
    vec[2] <- "XXX"
    return(vec)
}

modify_vec(myvec)
```

    ##  [1] "a"   "XXX" "c"   "d"   "e"   "f"   "g"   "h"   "i"   "j"

Despite the `modify_vec` function appearing to modify its input
in-place, `myvec` remains unchanged:

``` r
myvec
```

    ##  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j"

That’s because most functions in R create copies of their input
arguments, rather than allowing functions to mutate their arguments[^1].
This feature enables the kind of interactive data exploration that is
common in R, and also makes code easier to reason about and debug. But
it can lead to lots of memory allocations, which are slow, and can also
trigger lots of garbage collector interventions, slowing things down
more. This is *especially* true if your data is very large, such that
multiple copies no longer can fit comfortably in memory – in these
cases, all of the copying will cause lots of utilizations of virtual
memory, in the worst case resulting in thrashing.

The easiest way to diagnose allocation-related performance issues is to
watch `htop` or something similar during slow-running scripts, paying
special attention to the amount of memory being used by your script. For
more on dealing with performance issues caused by excessive memory
usage, see [the note on data frames](#a-note-about-data-frames)

That said, R is sort of clever about avoiding totally unnecessary
copies. For example:

``` r
library(pryr)
x <- runif(100000)
y <- x
pryr::object_size(x)
```

    ## 800.05 kB

``` r
pryr::object_size(y)
```

    ## 800.05 kB

``` r
pryr::object_size(x,y)
```

    ## 800.05 kB

In this example, `y` is just another pointer to `x`, rather than a full
copy. The copy only happens when we modify `y`, at which point a copy is
made in order to keep `x` unchanged (notice how this is different from
languages that make regular use of mutable data structures including
arrays):

``` r
y[3] <- 0
pryr::object_size(x,y)
```

    ## 1.60 MB

We see something even more interesting with data frames:

``` r
dfx <- data.frame(measurement = x)
dfy <- mutate(dfx, rounded = round(measurement))
pryr::object_size(dfx)
```

    ## 800.74 kB

``` r
pryr::object_size(dfy)
```

    ## 1.60 MB

``` r
pryr::object_size(dfx, dfy)
```

    ## 1.60 MB

The two data structures utilize shared memory for the parts of their
data that are identical, and so only the space for the new column is
allocated, rather than the entire data frame (this design concept is
called “structural sharing”).

The point of these examples is to emphasize rule 1: don’t worry about
optimizing out unnecessary copies until you’ve encountered a performance
problem and determined that memory allocations related to copying are
the cause. Instead, write readable and idiomatic R code and learn how to
profile slow code when necessary.

# Use efficient packages and/or built-in functionality

See rule 3. A small, non-exhaustive collection of examples (all of these
are interfaces to compiled libraries that you might have to install
separately along with the R package):

- `data.table` for data.frame manipulations, fast indexed data frames,
  etc.

- `igraph` for graph algorithms and data structures

- `sf` for geo-spatial analysis

- `stringi` for string manipulations and regexes (and `stringr`, which
  provides a consistent interface to several `stringi` functions)

- `stringdist` for string distance and fuzzy matching

- `rstan` for Bayesian modeling

- `magick` for image processing

A good place to look if you’re trying to find a particular package is
the [CRAN task views](https://cran.r-hub.io/web/views/), which are
curated lists of packages organized by topic.

# Compile if you need

Let’s try to apply some of what we learned. We start with a function
that we’ve decided is too slow, with an adequately sized set of test
data for running experiments:

``` r
myfunc <- function(xs) sum(sqrt(sin(xs^3)))
testxs <- runif(10000000)
```

I’m already using vectorized functions. Perhaps copies are an issue?
Let’s take a look:

``` r
pryr::object_size(testxs)
```

    ## 80.00 MB

``` r
bm(myfunc(testxs))
```

    ## # A tibble: 1 × 4
    ##   expression          min   median mem_alloc
    ##   <bch:expr>     <bch:tm> <bch:tm> <bch:byt>
    ## 1 myfunc(testxs)    338ms    339ms    76.3MB

It appears I’m allocating a full copy of my input vector, even though I
should be able to calculate the result without any copies.

(Note: this is a contrived example for demonstration purposes. It is
very unlikely that a function like `myfunc` will be the performance
bottleneck in your code).

Let’s see if we can re-write `myfunc` in C++:

``` r
library(Rcpp)

# note we use 0-based indexing in C code

cppFunction(
"double myfunc_cpp(NumericVector xs) {
  double sum = 0;
  for (int i = 0; i < xs.size(); i++) {
      sum += sqrt(sin(pow(xs[i], 3)));
  }
  return sum;
}")
```

There I used the `cppFunction` function that lets you enter C++ code as
a quoted string. In practice, you’ll want to keep your C++ functions in
their own text file and source them using `Rcpp::sourceCpp`. Now Let’s
see if that worked to reduce our memory allocations:

``` r
bm(
   myfunc(testxs),
   myfunc_cpp(testxs)
)
```

    ## # A tibble: 2 × 4
    ##   expression              min   median mem_alloc
    ##   <bch:expr>         <bch:tm> <bch:tm> <bch:byt>
    ## 1 myfunc(testxs)        337ms    337ms   76.29MB
    ## 2 myfunc_cpp(testxs)    179ms    179ms    2.49KB

# A note about parallelism

The [future package](https://future.futureverse.org/) provides an
interface to various forms of parallelism that are available in R,
including `multicore` which is based on forking the existing R process.
There is some overhead, both in terms of time and memory, so this will
be most useful with larger amounts of input data. If you already write
your code using higher order functions such as the `apply` family or the
`purrr` functions, then `future.apply` and `furrr`, respectively,
provide very familiar interfaces, making it easy to parallelize your
code when data gets big. On eleanor (28 cores, 250gb of ram) with large
datasets, this can lead to substantial speedups, without any re-writing
or re-factoring of your code.

Several packages utilize multi-threading, often compiled in at the C
level. This kind of parallelism still has overhead, but it is lower than
the kind described above, and so utilizing the multi-thread options
(usually via one of the function arguments) can help performance even
for medium sized problems. However, you have to ensure the package in
question gets compiled correctly in order to enable this
multi-threading. [Here are some tests I
use](https://github.com/tarakc02/dotfiles/blob/main/test/open-mp-install-tests.R)
to make sure `data.table` and `stringdist` have been compiled with
multi-threading ability. Finally, if you’re using the built-in
multi-threading capability of these packages within a function, don’t
also run that function through the `future::multicore` form of
parallelism, you’ll only end up slowing things down.

# A note about data frames

*This note is specifically about data frames that fit comfortably in
main memory. If data is too big to fit in memory, there are R packages
implementing the [dbi interface](https://dbi.r-dbi.org/) for [hundreds
of database backends](https://github.com/r-dbi/backends#readme)
including postgres, sqlite, bigquery, redshift, spark, and so on. With
[dbplyr](https://dbplyr.tidyverse.org/) you can switch from a local data
frame to a dbi-backed data frame without having to change your code.*

## The two kinds of in-memory data frames

- `base::data.frame` and `tibble::tbl_df`: R’s `base` package (that is
  loaded by default when you start R) defines the `data.frame`, as well
  as a handful of functions for indexing, subsetting, and summarizing
  `data.frame`s. The `tbl_df` that is common across
  [tidyverse](https://www.tidyverse.org/) packages, is just a
  `base::data.frame` with a few tweaks, and for all performance purposes
  can be thought of as the same as `base::data.frame`

- `data.table::data.table`: The [`data.table`
  package](https://www.tidyverse.org/) implements a totally separate
  version of data frames, optimized for speed and memory efficiency.
  `data.table` comes with its own functionality for indexing and
  subsetting that is similar to `base`, but cleaner and easier to read
  and write.

The `dplyr` package defines a family of functions (`select`, `mutate`,
`filter`, `group_by`, `summarize`, etc.) that operate on data frames and
return data frames, making it easy to compose them and chain together
longer queries. These functions are defined on `base::data.frame` as
well as `data.table::data.table` (once you’ve installed the [dtplyr
package](https://dtplyr.tidyverse.org/)). This makes it easier to switch
between packages without lots of changes to your code (see [the example
below](#example-free-speedups-by-replacing-data.frametibble-with-data.table)).

## memory

R’s excessive copying of data can cause especially bad slowdowns when
working with large data frames. If you’ve got a task that works on a
data frame with \~millions of records or more, and you’ve confirmed (for
instance by watching `htop`) that memory use is causing performance
problems:

- if you’re hitting the point of swap/virtual memory use, that can cause
  really huge slowdowns compared to if your script can work all in main
  memory. Check for and if possible exit any other programs that are
  using a lot of memory, for instance a separate RStudio or Jupyter
  session you’re using for prototyping where you’ve read in the same big
  data set.

- check code for bad joins. sudden spikes in memory usage can happen
  when your data size jumps from
  ![n](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;n "n")
  to
  ![n^{2}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;n%5E%7B2%7D "n^{2}"),
  and one way that can happen is through an accidental [cartesian
  product](https://en.wikipedia.org/wiki/Cartesian_product).

- Do you need all of the columns? A lot of times we write scripts that
  operate on a handful of columns of data, but read in and pass around a
  full dataset with dozens or hundreds of columns, meaning a lot of the
  copying that R is doing is of data that never gets looked at or
  touched. `arrow::read_parquet` includes a `col_select` argument so you
  can just read in specific columns, which speeds up the initial reading
  of the data as well as other operations once you’ve read it in.

- When working with larger data frames, it’s essential to check out the
  [`data.table`](https://rdatatable.gitlab.io/data.table/) package.
  `data.table` is [extremely
  fast](https://h2oai.github.io/db-benchmark/), and also due to its
  memory-efficiency enables you to work with much larger datasets than
  you otherwise would be able to handle in memory. If you have code
  written in `dplyr`, you can migrate it over to `data.table` without
  changing too much code by using the
  [`dtplyr`](https://dtplyr.tidyverse.org/) package.

## misc

- for CSV’s, `data.table::fread` gives huge speedups to initial reading
  in the data, and better column-type inference, than either `read.csv`
  or `readr::read_csv`.

- `data.table` is much faster than the alternatives for
  filter/groupby/join type operations, with or without indexing. The
  benefits of this are apparent not only when you have large data, but
  also when you are doing lots of grouped summaries over lots of smaller
  groups, as is common in blocking and record linkage. In those
  settings, using `data.table` rather than `dplyr` or base R will have
  noticeable benefits even without especially large data.

## example: free speedups by replacing `data.frame/tibble` with `data.table`

During blocking, we have to repeatedly calculate the number of pairs
generated by a given blocking rule.

``` r
make_grouped_tbl <- function(len, n_distinct_keys = len/15) {
    keys <- stri_rand_strings(n_distinct_keys, 50)
    tibble(
        key = sample(keys, len, replace = T),
        somedata = runif(len)
    )
}

summarise_groups <- function(records, keycol)
     records %>% group_by(key) %>% summarise(n = n())

calc_pairs <- function(smry) {
     ns <- smry$n
     sum(ns * (ns - 1) / 2)
}

set.seed(19481210)
ex_tbl <- make_grouped_tbl(100000)
ex_tbl %>% summarise_groups %>% calc_pairs
```

    ## [1] 749288

Because `dplyr` functions work with `data.table`s, we don’t have to
change much about our code to switch backends. The two changes are: add
`library(dtplyr)` during setup, and add `as_tibble` after
`summarise_groups`:

``` r
library(data.table)
library(dtplyr)
ex_dt <- data.table(ex_tbl)
ex_dt %>% summarise_groups %>% as_tibble %>% calc_pairs
```

    ## [1] 749288

For the most fair comparison, in my benchmarking code I include the time
it takes to convert the input to a data.table rather than feeding it
`ex_dt` directly:

``` r
bm("data.frame" = ex_tbl %>% summarise_groups %>% calc_pairs,
   "data.table" = ex_tbl %>% data.table %>% summarise_groups %>% as_tibble %>% calc_pairs)
```

    ## # A tibble: 2 × 4
    ##   expression      min   median mem_alloc
    ##   <bch:expr> <bch:tm> <bch:tm> <bch:byt>
    ## 1 data.frame   46.8ms   47.2ms    2.36MB
    ## 2 data.table   7.02ms   13.4ms    5.98MB

# Further reading

Check out the [Improving
performance](https://adv-r.hadley.nz/perf-improve.html) chapter of
[Advanced R](https://adv-r.hadley.nz/index.html)

[^1]: To see why this might be surprising, compare to this very similar
    looking code and outputs in python:

        >>> mylist = list(range(9))
        >>>
        >>> def modify_list(lst):
        ...     lst[1] = 99
        ...     return lst
        ...
        >>> mylist
        [0, 1, 2, 3, 4, 5, 6, 7, 8]
        >>> modify_list(mylist)
        [0, 99, 2, 3, 4, 5, 6, 7, 8]
        >>> mylist
        [0, 99, 2, 3, 4, 5, 6, 7, 8]

    In that example, the function `modify_list` is able to reach outside
    of its scope and modify the contents of one of its arguments,
    changing the contents of `mylist` for any other function that might
    access it. Except for a few important exceptions, that is not the
    way data structures and functions work in R; if you did want similar
    behavior, you would have to explicitly use the `<<-` assignment
    operator or use the `assign` function and specify the enviornment
    for assignment explicitly. But most of the time, the appropriate
    thing to do is have functions that return values (for example, the
    way that `dplyr::filter` returns a filtered data frame which has a
    separate existence from the input data, as opposed to removing rows
    directly from the input). It’s instructive to compare what we have
    in R to [Clojure’s built-in data
    structures](https://clojure.org/reference/data_structures), which
    are immutable and share the semantics of R’s, but use structural
    sharing more cleverly so that they are able to maintain the big-O
    performance guarantees of their mutable counterparts.
