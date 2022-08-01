## Functions

Functions work basically the way you think they would:

````julia
function add(x, y)
    return x + y
end

add(1, 2)
````

````
3
````

The return value of a function is the value of the last evaluated expression in
    the function, so you could just do:

````julia
function add(x, y)
    x + y
end
````

````
add (generic function with 1 method)
````

There's a compact form for short function definitions:

````julia
add(x, y) = x + y

add(1, 2)
````

````
3
````

Note that the longer form doesn't use curly brackets. This is also true more
generally -- blocks of code are encapsulated in `begin` and `end` instead of
brackets. For things like functions, loops, and conditionals, the keyword does
the same job as `begin`. Also you don't have to use a lot of parentheses that
you'd find in other languages:

````julia
myfunc1 = function(x)
    if x < 5
        print("abcd\n")
    elseif x < 10
        print("efgh\n")
    else
        print("xyz\n")
    end

    while x > 0
        print(x, "\n")
        x -= 1
    end
end;
````

Functions can be composed (notice evaluation is from right to left, as in
mathematics):

````julia
f(x) = 2x
g(x) = x + 7
h = f ∘ g
````

````
Main.var"##312".f ∘ Main.var"##312".g
````

You can make anonymous functions. For example this:

````julia
x -> 2x + 7
````

````
#3 (generic function with 1 method)
````

is the same as

````julia
function(x) 2x + 7 end
````

````
#5 (generic function with 1 method)
````

so you can do:

````julia
(x -> 2x + 7)(3)
13
````

````
13
````

but more likely you  want to pass the anon. function to something else:

````julia
map(x -> 2x + 8, [1, 2, 3])
````

````
3-element Vector{Int64}:
 10
 12
 14
````

You can pipe functions together using the `|>` operator:

````julia
rand(10) |> sum |> round
````

````
4.0
````

## Compilation and waiting

Julia compiles individual methods when you first run them (within a given
session). For that reason, there is compilation overhead to calling a method
for the first time

````julia
add(x, y) = x + y;
````

compiles for {Int, Int}

````julia
@time add(5, 7)
````

````
12
````

already compiled, so no more compilation overhead

````julia
@time add(19, 25)
````

````
44
````

but we haven't compiled a method for {Float64, Float64}

````julia
@time add(5.0, 7.0)
````

````
12.0
````

now it's compiled

````julia
@time add(19.0, 25.0)
````

````
44.0
````

notice that signature {Int, Float64} is its own method
dispatch is on both arguments

````julia
@time add(5, 7.0)

@time add(5, 7.0)
````

````
12.0
````

## Some useful built-in data structures

- Dicts: `Dict("key1" => 123, "key2" => 473, ...)`
- Arrays: `[1, 2, 3]`
- Tuples: `(1, 2, 3)`
- Named Tuples: `(a = 1, b = 2, c = 3)`
- Sets: `Set([1, 2, 3])`

## Python-ish generators/comprehensions:

````julia
[2x for x in 1:5]
mydict = Dict((x => 2x) for x in 1:5);
mydict[5]
````

````
10
````

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

