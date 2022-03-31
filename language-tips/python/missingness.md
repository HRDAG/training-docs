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
additional overhead. In some cases, pandas will switch between the two when an
alternate might be more efficient, but of course this is a chance for us to 
understand our tools better and utilize precision in our approach to data 
processing upfront.

#### `np.nan`


#### `None`

##### done.
