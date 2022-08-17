#=

# Using data frames in Julia

## [Dataframes.jl](https://dataframes.juliadata.org/stable/)

[DataFrames.jl](https://dataframes.juliadata.org/stable/) implemenets the data
structure most similar to dataframes in R (similar to base R's `data.frame` or
`data.table`) or python/pandas.

=#

using DataFrames
using CSV

mtcars = CSV.read("../input/mtcars.csv", DataFrame, delim="|")
describe(mtcars)

#=

### Indexing

Indexing in DataFrames is pretty natural if you've used data frames in R:

=#


mtcars[1:3, [:mpg, :wt, :drat]]

# or via column indices, not recommended:

mtcars[1:3, [1,6,5]]

# If you want to get a dataframe with a single column, make sure you still use
# the array brackets:

mtcars[:, [:mpg]]

# compare to:

mtcars[:, :mpg]

# you can also return a vector this way:

mtcars.mpg

#=

### Joins

`innerjoin`, `leftjoin`, and `antijoin` work the way you would expect:

=#

main_data = mtcars[:, [:car, :mpg, :wt]]
additional_data = DataFrame(car = ["Volvo 142E", "Datsun 710", "Ferrari Dino"],
                            variable = [13, 42, 17])

innerjoin(main_data, additional_data, on = :car)
leftjoin(main_data, additional_data, on = :car)
antijoin(main_data, additional_data, on = :car)
#=

## [Query.jl](http://www.queryverse.org/Query.jl/stable/)

[Query.jl](http://www.queryverse.org/Query.jl/stable/) allows you to build
dplyr-like query pipelines for dataframe manipulation:

=#

using Query
using Statistics

mtcars |>
    @select(:car, :cyl, :mpg, :wt) |>
    @mutate(car = uppercase(_.car),
            mpg_wt = _.mpg/_.wt) |>
    @groupby(_.cyl) |>
    @map({cyl           = key(_),
          mean_mpg      = mean(_.mpg),
          max_wt        = maximum(_.wt),
          median_mpg_wt = median(_.mpg_wt)})


#=

## Reading and writing

The [`CSV`](https://csv.juliadata.org/stable/) package is for reading and
writing any delimited files, the delimiter does not have to be a comma. The
syntax above already shows how to read in a CSV file as a dataframe.
Alternately, if you need to process the file in a streaming manner, `CSV.File`
returns an iterator over rows:

=#

mtcars_streaming = CSV.File("../input/mtcars.csv", delim ="|");

for row in mtcars_streaming
    println(row.car, ": ", row.mpg)
end

#=

## Parquet files

Use [`Parquet`]()

=#

#=

## Abstract interface: Tables.jl

=#

