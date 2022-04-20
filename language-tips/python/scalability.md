### Python
Because the Python language is type-agnostic, in order to compile it uses an Interpreter to make inferences about types at runtime. This can result in signficant bottlenecks in performance if we aren't careful about exactly how our code should be implemented.

This document shows some samples from:
- [Python Performance Tuning: 20 Simple Tips](https://stackify.com/20-simple-python-performance-tuning-tips/)
- [High Performance Pandas: eval() and query()](https://jakevdp.github.io/PythonDataScienceHandbook/03.12-performance-eval-and-query.html)

## *Tips*
- Purge unused dependencies
- Use as few global variables as possible
- [Built-ins](https://docs.python.org/3/library/functions.html)
    - Don’t write your own version of a built-in method that does exactly the same thing! The built-in version will be faster and include better error handling than a custom implementation.
- Utilize memory profilers to identify bottlenecks in your code

&nbsp;  

## *Tricks*

> Goal: Make a list of integers in a given range

Possible solution: 
```
indices = []
for i in range(len(some_list)):
    indices.append(i)
```
Better solution: 
```
indices = [ i for i in range(len(some_list)) ]
```
&nbsp;  

> Goal: Check if an exact match for a value is in a list

Possible solution: 
```
target = 5
for val in some_list:
    if val == target:
        (do work)
```
OR
```
target = 5
if target in set(some_list):
    (do work)
```
Better solution: 
```
target = 5
if target in some_list:
    (do work)
```
&nbsp;  

> Goal: Find values in one list that are also present in another

Possible solution: 
```
dupes = []
for x in left_list:
  for y in right_list:
    if x==y:
      dupes.append(x)
```
Better solution: 
```
dupes = set(left_list) & set(right_list)
```
&nbsp;  

> Goal: Assign multiple values in one call

Possible solution: 
```
def format_full_name( some_name ):
    lower_name = some_name.lower()
    return lower_name.split(“ “)

name_list = format_full_name(“Some Guys Name”)
first = name_list[0]
middle = name_list[1]
last = name_list[2]
```
Better solution: 
```
def format_full_name( some_name ):
    lower_name = some_name.lower()
    return lower_name.split(“ “)

first, middle, last = format_full_name(“Some Guys Name”)
```
&nbsp;  

> Goal: Swap the contents of two variables

Possible solution: 
```
temp = x
x = y
y = temp
```
Better solution: 
```
x, y = y, x
```
&nbsp;  

> Goal: Combine multiple string values

Possible solution: 
```

```
OR
```
def rebuild_full_name( a_first, a_middle, a_last ):
    return a_first + “ “ + a_middle + “ “ + a_last

full_name = rebuild_full_name(first, middle, last)
```
Better solution: 
```
def rebuild_full_name( a_first, a_middle, a_last ):
    return “ “.join(a_first, a_middle, a_last)

full_name = rebuild_full_name(first, middle, last)
```

# done.
