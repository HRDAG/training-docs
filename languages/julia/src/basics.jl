#=
## Functions

Functions work basically the way you think they would:
=#

function add(x, y)
    return x + y
end
add(1, 2)

#=

The return value of a function is the value of the last evaluated expression in
the function, so we could also have written:

```julia
function add(x, y)
    x + y
end
```

Furthermore, there's a compact form for short function definitions:

=#


add(x, y) = x + y
add(1, 2)

#=

Notice that the longer form doesn't use curly brackets. This is also true more
generally -- blocks of code are encapsulated in `begin` and `end` instead of
brackets. For things like functions, loops, and conditionals, the keyword does
the same job as `begin`. Also you don't have to use a lot of parentheses that
you'd find in other languages:

=#

myfunc1 = function(x)
    if x < 5
        println("size: small")
    elseif x < 10
        println("size: medium")
    else
        println("size: big")
    end
    println("counting down...")
    while x > 0
        println(x)
        x -= 1
    end
end
myfunc1(7)

# Functions can be composed (notice evaluation is from right to left, as in
# mathematics):

f(x) = 2x
g(x) = x + 7
h = f ∘ g
h(10)

# You can make anonymous functions. For example this:

x -> 2x + 7

# is the same as
function(x) 2x + 7 end

# but can more concisely be passed as an argument to a higher order function:
map(x -> 2x + 7, [1, 2, 3])

# You can pipe functions together using the `|>` operator:
rand(10) |> sum |> round

#=
## Some useful built-in data structures

- Dicts: `Dict("key1" => 123, "key2" => 473, ...)`
- Arrays: `[1, 2, 3]`
- Tuples: `(1, 2, 3)`
- Named Tuples: `(a = 1, b = 2, c = 3)`
- Sets: `Set([1, 2, 3])`

## Python-ish array generators/comprehensions:

The comprehension syntax is similar to what you would use in Python. This
generates a vector (a 1-dimensional array):

=#
[2x for x in 1:5]

# the same syntax can be used to create other datastructures as well:
mydict = Dict((x => 2x) for x in 1:5)
mydict[5]
