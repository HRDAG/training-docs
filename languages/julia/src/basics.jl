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
    the function, so you could just do:
=#

function add(x, y)
    x + y
end

# There's a compact form for short function definitions:

add(x, y) = x + y

add(1, 2)

#=

Note that the longer form doesn't use curly brackets. This is also true more
generally -- blocks of code are encapsulated in `begin` and `end` instead of
brackets. For things like functions, loops, and conditionals, the keyword does
the same job as `begin`. Also you don't have to use a lot of parentheses that
you'd find in other languages:

=#

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

# Functions can be composed (notice evaluation is from right to left, as in
# mathematics):

f(x) = 2x
g(x) = x + 7
h = f ∘ g

# You can make anonymous functions. For example this:

x -> 2x + 7

# is the same as
function(x) 2x + 7 end

# so you can do:
(x -> 2x + 7)(3)
13

# but more likely you  want to pass the anon. function to something else:
map(x -> 2x + 8, [1, 2, 3])

# You can pipe functions together using the `|>` operator:

rand(10) |> sum |> round

#=

## Compilation and waiting

Julia compiles individual methods when you first run them (within a given
session). For that reason, there is compilation overhead to calling a method
for the first time

=#

add(x, y) = x + y;

# compiles for {Int, Int}
@time add(5, 7)

# already compiled, so no more compilation overhead
@time add(19, 25)

# but we haven't compiled a method for {Float64, Float64}
@time add(5.0, 7.0)

# now it's compiled
@time add(19.0, 25.0)

# notice that signature {Int, Float64} is its own method
# dispatch is on both arguments
@time add(5, 7.0)

@time add(5, 7.0)

#=
## Some useful built-in data structures

- Dicts: `Dict("key1" => 123, "key2" => 473, ...)`
- Arrays: `[1, 2, 3]`
- Tuples: `(1, 2, 3)`
- Named Tuples: `(a = 1, b = 2, c = 3)`
- Sets: `Set([1, 2, 3])`

## Python-ish generators/comprehensions:
=#

[2x for x in 1:5]
mydict = Dict((x => 2x) for x in 1:5);
mydict[5]
