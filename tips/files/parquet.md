Author:     LB
Maintainer: BP

## Parquet Files
What is Parquet? According to Databricks.com, “Apache Parquet is an open source, column-oriented data file format designed for efficient data storage and retrieval. It provides efficient data compression and encoding schemes with enhanced performance to handle complex data in bulk”.

## What this means 
Parquet files read, store and write data based on columns and not rows. It turns out that passing data in this way is less expensive than working in a row-oriented direction. 

## Benefits
According to Russell Jurney,  the abilities of column-oriented formatting to store each column of data together and can load them one at a time. This leads to two performance optimizations:
    1. You only pay for the columns you load. This is called columnar storage.
Let m be the total number of columns in a file and n be the number of columns requested by the user. Loading n columns results in justn/m raw I/O volume.
    2. The similarity of values within separate columns results in more efficient compression. This is called columnar compression.

Note the event_type column in both row and column-oriented formats in the diagram below. A compression algorithm will have a much easier time compressing repeats of the value party in this column if they make up the entire value for that row, as in the column-oriented format. By contrast, the row-oriented format requires the compression algorithm to figure out repeats occur at some offset in the row which will vary based on the values in the previous columns. This is a much more difficult task.

(unlinked image representing storage format diagrams)

The column-oriented storage format can load just the columns of interest. Within these columns, similar or repeated values such as ‘party’ within the ‘event_type’ column compress more efficiently.
Columnar storage combines with columnar compression to produce dramatic performance improvements for most applications that do not require every column in the file. I have often used PySpark to load CSV or JSON data that took a long time to load and converted it to Parquet format, after which using it with PySpark or even on a single computer in Pandas became quick and painless.

More later...
- Pyarrow
- Fastparquet

done.
