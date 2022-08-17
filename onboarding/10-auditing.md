We'd like to catch surprises in our processing pipelines as early as possible,
as that will allow us to avoid more serious problems, and also make it easier
to debug.

# Assertions

Assertions are a way to test assumptions or verify things that should be true.
An assertion is made up of a condition (some expression that evluates to
true/false) and, optionally, a custom error message. When the condition is
false, we get an error.

## Syntax

In python, we can use the `assert` statement:

```python
>>> assert 1 == 1
>>> assert 1 == 2
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AssertionError
```

A more informative error message will make debugging easier:

```python
>>> assert 1 == 2, "input values should be equal"
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AssertionError: input values should be equal
```

Julia has a similar syntax, using the built-in `@assert` macro:

```julia
julia> @assert 1 == 1

julia> @assert 1 == 2
ERROR: AssertionError: 1 == 2
Stacktrace:
 [1] top-level scope
   @ REPL[2]:1
```

Once again, we can add an informative error message

```julia
julia> @assert 1 == 2 "input values should be equal"
ERROR: AssertionError: input values should be equal
Stacktrace:
 [1] top-level scope
   @ REPL[1]:1
```

R, on ther hand, uses `stopifnot`, which we call like a function:

```r
> stopifnot(1 == 1)
> stopifnot(1 == 2)
Error: 1 == 2 is not TRUE
```

Use named arguments to specify custom error messages, and you can use one
`stopifnot` to check multiple assumptions:

```r
> stopifnot("input values should be equal" =  1  ==  2,
            "characters should be equal"   = 'a' == 'a')
Error: input values should be equal
```

If multiple assertions in a `stopifnot` fail, only the first error is thrown.

## Examples of useful assertions

A helpful assertion will encode some substantive knowledge you have about the
data in the form of an expectation.

### we haven't dropped data or created duplicates

Code that requires joining data frames assumes


```r
input <- read(args$input)
supplement <- read(args$supplement)

output <- input %>% inner_join(supplement, by = "id")

stopifnot(nrow(output) == nrow(input))
write_parquet(output, args$output)
```

### constraints on discrete values a field should take

R example:

```r
clean_date <- function(dates) {
    out <- some_parsing_code(dates)
    stopifnot(
        all(out$month %in% 1:12),
        all(out$day %in% 1:31)
    )
    return(out)
}
```

python example:

```python
def clean_age_group(ages):
    out = some_parsing_code(ages)
    assert all(grp in ['adult', 'child'] for grp in out)
    return out
```

### fields that have a known prior distribution

```r
clean_age <- function(ages) {
    clean_ages <- some_parsing_code(ages)
    stopifnot( all(clean_ages < 150) )
    return(clean_ages)
}
```

```python
def extract_year(date_strings, conflict_start, conflict_end):
    years = some_extraction_code(date_strings)
    assert all(y >= conflict_start and y <= conflict_end for y in years)
    return years
```

### knowledge about the data sources or generating processes

Some of our background knowledge gets encoded into our models as priors, making
that knowledge unsuitable for this type of test. But, for a variety of reasons,
we often have substantive knowledge or assumptions about the distribution of
data that we do not encode into our models. The content of these assertions are
context and/or data-source specific.

```r
stopifnot(sum(data$sex == "M") > sum(data$sex == "F"))
stopifnot(sum(data$age_cat == "ADULT") > sum(data$age_cat == "CHILD"))
```

```python
# e.g. when one data source is known to be an aggregate
# collection that covers the other
assert overlap_rate(source1, source2) > .5
```

# Unit tests

When code has intricate logic or has to handle a lot of weird edge cases, use
unit tests to make sure it works. These are especially valuable when you need
to make changes to the code, allowing you to confirm that the changes haven't
broken anything.

```r
library(testthat)

samples <- c(
    "123 Main Street",
    "9866 N. Park Avenue",
    "   789 15th",
    " 123   Main St."
)

hand_cleaned <- c(
    "123 MAIN STREET",
    "9866 N PARK AVENUE",
    "789 15th",
    "123 MAIN STREET"
)

test_that("address cleaning works as expected", {
    expect_equal(clean(samples), hand_cleaned),
    epect_type(clean(samples), "character")
})
```

If there are more than a few examples, you can store them in a YAML or CSV
file. As you encounter bugs or corner cases, add them to the examples.

# Audits that require some manual intervention

Assertions and unit tests can automatically stop data processing rather than
outputting incorrect results. Sometimes, we can design audit reports that don't
necessarily throw errors, but can allow a person reviewing them to spot
potential issues.

example: plot histograms of the length of the person's name for each imported
data source side by side, and look for any that are out of the ordinary. If the
names all came from the same time and place, they should have similar
statistical characteristics (similar lengths, similar distribution of
characters, etc.)

