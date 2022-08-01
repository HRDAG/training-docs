# Using data frames in Julia

## [Dataframes.jl](https://dataframes.juliadata.org/stable/)

[DataFrames.jl](https://dataframes.juliadata.org/stable/) implemenets the data
structure most similar to dataframes in R (similar to base R's `data.frame` or
`data.table`) or python/pandas.

````julia
using DataFrames
using CSV

mtcars = CSV.read("../input/mtcars.csv", DataFrame, delim="|")
describe(mtcars)
````

````
12×7 DataFrame
 Row │ variable  mean     min          median  max         nmissing  eltype
     │ Symbol    Union…   Any          Union…  Any         Int64     DataType
─────┼────────────────────────────────────────────────────────────────────────
   1 │ car                AMC Javelin          Volvo 142E         0  String31
   2 │ mpg       20.0906  10.4         19.2    33.9               0  Float64
   3 │ cyl       6.1875   4            6.0     8                  0  Int64
   4 │ disp      230.722  71.1         196.3   472.0              0  Float64
   5 │ hp        146.688  52           123.0   335                0  Int64
   6 │ drat      3.59656  2.76         3.695   4.93               0  Float64
   7 │ wt        3.21725  1.513        3.325   5.424              0  Float64
   8 │ qsec      17.8488  14.5         17.71   22.9               0  Float64
   9 │ vs        0.4375   0            0.0     1                  0  Int64
  10 │ am        0.40625  0            0.0     1                  0  Int64
  11 │ gear      3.6875   3            4.0     5                  0  Int64
  12 │ carb      2.8125   1            2.0     8                  0  Int64
````

### Indexing

Indexing in DataFrames is pretty natural if you've used data frames in R:

````julia
mtcars[1:3, [:mpg, :wt, :drat]]
````

````
3×3 DataFrame
 Row │ mpg      wt       drat
     │ Float64  Float64  Float64
─────┼───────────────────────────
   1 │    21.0    2.62      3.9
   2 │    21.0    2.875     3.9
   3 │    22.8    2.32      3.85
````

or via column indices, not recommended:

````julia
mtcars[1:3, [1,6,5]]
````

````
3×3 DataFrame
 Row │ car            drat     hp
     │ String31       Float64  Int64
─────┼───────────────────────────────
   1 │ Mazda RX4         3.9     110
   2 │ Mazda RX4 Wag     3.9     110
   3 │ Datsun 710        3.85     93
````

If you want to get a dataframe with a single column, make sure you still use
the array brackets:

````julia
mtcars[:, [:mpg]]
````

````
32×1 DataFrame
 Row │ mpg
     │ Float64
─────┼─────────
   1 │    21.0
   2 │    21.0
   3 │    22.8
   4 │    21.4
   5 │    18.7
   6 │    18.1
   7 │    14.3
   8 │    24.4
   9 │    22.8
  10 │    19.2
  11 │    17.8
  12 │    16.4
  13 │    17.3
  14 │    15.2
  15 │    10.4
  16 │    10.4
  17 │    14.7
  18 │    32.4
  19 │    30.4
  20 │    33.9
  21 │    21.5
  22 │    15.5
  23 │    15.2
  24 │    13.3
  25 │    19.2
  26 │    27.3
  27 │    26.0
  28 │    30.4
  29 │    15.8
  30 │    19.7
  31 │    15.0
  32 │    21.4
````

compare to:

````julia
mtcars[:, :mpg]
````

````
32-element Vector{Float64}:
 21.0
 21.0
 22.8
 21.4
 18.7
 18.1
 14.3
 24.4
 22.8
 19.2
 17.8
 16.4
 17.3
 15.2
 10.4
 10.4
 14.7
 32.4
 30.4
 33.9
 21.5
 15.5
 15.2
 13.3
 19.2
 27.3
 26.0
 30.4
 15.8
 19.7
 15.0
 21.4
````

you can also return a vector this way:

````julia
mtcars.mpg
````

````
32-element Vector{Float64}:
 21.0
 21.0
 22.8
 21.4
 18.7
 18.1
 14.3
 24.4
 22.8
 19.2
 17.8
 16.4
 17.3
 15.2
 10.4
 10.4
 14.7
 32.4
 30.4
 33.9
 21.5
 15.5
 15.2
 13.3
 19.2
 27.3
 26.0
 30.4
 15.8
 19.7
 15.0
 21.4
````

### Joins

`innerjoin`, `leftjoin`, and `antijoin` work the way you would expect:

````julia
main_data = mtcars[:, [:car, :mpg, :wt]]
additional_data = DataFrame(car = ["Volvo 142E", "Datsun 710", "Ferrari Dino"],
                            variable = [13, 42, 17])

innerjoin(main_data, additional_data, on = :car)
leftjoin(main_data, additional_data, on = :car)
antijoin(main_data, additional_data, on = :car)
````

````
29×3 DataFrame
 Row │ car                  mpg      wt
     │ String31             Float64  Float64
─────┼───────────────────────────────────────
   1 │ Mazda RX4               21.0    2.62
   2 │ Mazda RX4 Wag           21.0    2.875
   3 │ Hornet 4 Drive          21.4    3.215
   4 │ Hornet Sportabout       18.7    3.44
   5 │ Valiant                 18.1    3.46
   6 │ Duster 360              14.3    3.57
   7 │ Merc 240D               24.4    3.19
   8 │ Merc 230                22.8    3.15
   9 │ Merc 280                19.2    3.44
  10 │ Merc 280C               17.8    3.44
  11 │ Merc 450SE              16.4    4.07
  12 │ Merc 450SL              17.3    3.73
  13 │ Merc 450SLC             15.2    3.78
  14 │ Cadillac Fleetwood      10.4    5.25
  15 │ Lincoln Continental     10.4    5.424
  16 │ Chrysler Imperial       14.7    5.345
  17 │ Fiat 128                32.4    2.2
  18 │ Honda Civic             30.4    1.615
  19 │ Toyota Corolla          33.9    1.835
  20 │ Toyota Corona           21.5    2.465
  21 │ Dodge Challenger        15.5    3.52
  22 │ AMC Javelin             15.2    3.435
  23 │ Camaro Z28              13.3    3.84
  24 │ Pontiac Firebird        19.2    3.845
  25 │ Fiat X1-9               27.3    1.935
  26 │ Porsche 914-2           26.0    2.14
  27 │ Lotus Europa            30.4    1.513
  28 │ Ford Pantera L          15.8    3.17
  29 │ Maserati Bora           15.0    3.57
````

## [Query.jl](http://www.queryverse.org/Query.jl/stable/)

[Query.jl](http://www.queryverse.org/Query.jl/stable/) allows you to build
dplyr-like query pipelines for dataframe manipulation:

````julia
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
````

````
3x4 query result
cyl │ mean_mpg │ max_wt │ median_mpg_wt
────┼──────────┼────────┼──────────────
6   │ 19.7429  │ 3.46   │ 6.6563       
4   │ 26.6636  │ 3.19   │ 12.1495      
8   │ 15.1     │ 5.424  │ 4.11558      
````

## Reading and writing

The [`CSV`](https://csv.juliadata.org/stable/) package is for reading and
writing any delimited files, the delimiter does not have to be a comma. The
syntax above already shows how to read in a CSV file as a dataframe.
Alternately, if you need to process the file in a streaming manner, `CSV.File`
returns an iterator over rows:

````julia
mtcars_streaming = CSV.File("../input/mtcars.csv", delim ="|");

for row in mtcars_streaming
    println(row.car, ": ", row.mpg)
end
````

````
Mazda RX4: 21.0
Mazda RX4 Wag: 21.0
Datsun 710: 22.8
Hornet 4 Drive: 21.4
Hornet Sportabout: 18.7
Valiant: 18.1
Duster 360: 14.3
Merc 240D: 24.4
Merc 230: 22.8
Merc 280: 19.2
Merc 280C: 17.8
Merc 450SE: 16.4
Merc 450SL: 17.3
Merc 450SLC: 15.2
Cadillac Fleetwood: 10.4
Lincoln Continental: 10.4
Chrysler Imperial: 14.7
Fiat 128: 32.4
Honda Civic: 30.4
Toyota Corolla: 33.9
Toyota Corona: 21.5
Dodge Challenger: 15.5
AMC Javelin: 15.2
Camaro Z28: 13.3
Pontiac Firebird: 19.2
Fiat X1-9: 27.3
Porsche 914-2: 26.0
Lotus Europa: 30.4
Ford Pantera L: 15.8
Ferrari Dino: 19.7
Maserati Bora: 15.0
Volvo 142E: 21.4

````

## Parquet files

Use [`Parquet`]()

## Abstract interface: Tables.jl

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

