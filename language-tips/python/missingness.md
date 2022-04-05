### Missing Values in Python
Datasets often have missing values, and different languages handle missingness
in data differently. This doc is intended to be an introduction to how python, 
numpy, and pandas handle missing data. A more in depth guide can be found [here](https://jakevdp.github.io/PythonDataScienceHandbook/03.04-missing-values.html).

#### Pandas
Technically, pandas doesn't have its own implementation of a missing value,
it chooses to use two existing null values as sentinels for missingness.

1. numpy's `np.nan` float
2. Python's `None` object

By using two different types of sentinel values, a float and an object, pandas
covers missingness of most data types we might encounter in a dataset with little
additional overhead.

#### [`np.nan`](https://numpy.org/doc/stable/user/misc.html)
"Nan" means "not a number", and numpy uses it to label a missing numeric datapoint.
In fact, numpy compiles `np.nan` as a floating point even when surrounding values
are integer type.

##### Why is that helpful?
Well, we're not always going to store integer type data, and when we do store numeric
data of non-integer type, we can be certain our missing token has been allocated
enough room in our data structure. You probably wouldn't consciously notice this at
runtime, but changes from a smaller dtype that uses little memory to one that carries
more information to store can create a delay as our structure tries to make room. On 
the other hand, if our placeholder reserves the slightly larger room, the operational
cost should be minimal. 

In case that is still too technical, think about it like reserving a meeting room. 
Let's say we have a team of 10 people working on a project, and we decide to meet
in-person to discuss it. Initially, only 4 people say they can make it, so the
smaller meeting room is chosen. But when its meeting day, 2 more people say they can
make it, and now you need room for 6. Depending on how many meeting rooms are 
available, this could be a big problem, but most likely it just takes some shuffling
around and a slight delay to the meeting. _Floating point numbers leave more room
numeric info than integers do, so the `np.nan` placeholder is read as a float._



#### [`None`](https://docs.python.org/3/c-api/none.html)

#### upcasting
In some cases, pandas will switch between the two chosen sentinel values when an
alternate might be more efficient, and this can be helpful to know when we're making
manipulations to our data.

Let's think about an example of when this might happen. Say we have an array full of
integers, and we want to insert an placeholder for a value we don't have yet.

At first, we have an array with dtype `integer`.

But after we insert placeholder, `np.nan`, and re-evaluate the dtype, we realize it's
been changed to `float`. Remember how np.nan compiles to a float? The type of the data
gets upcasted when we do this operation to accommodate 

Here is a table to summarize some of the upcasting scenarios.

| arr.dtype before | arr.dtype after | sentinel output  |
| ---              | ---             | ---              |
| `float`          | no change       | `np.nan`         |
| `object`         | no change       | `np.nan`, `None` |
| `integer`        | `float`         | `np.nan`         |
| `boolean`        | `object`        | `np.nan`, `None` |

#### operations
(I think these are all referring to `data` as a `pd.DataFrame` object, but I need to double check)

I. Arithmetic
     - 
II. Boolean detection
     - `data.isnull()`
          - returns a series of Booleans for all datapoints referring to whether or not they are missing
     - `data.notnull()`
          - returns a series of Booleans for non-null datapoints
     - `data[data.notnull()]`
          - uses the `notnull()` series as an index and returns the corresponding non-null datapoints
III. Convenience
     - `data.dropna()`
          - removes rows with null values in any column from structure
          - **Note:** there are some neat optional parameters to feed to `dropna()` if the default approach
          is not ideal, namely `how` and `thresh`
     - `data.fillna()`
          - fills missing values with the value passed as an argument

##### done.
