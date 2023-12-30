# Setup

### Languages
We often choose to write in a particular language based on our own comfort level, but it's important to remember that languages are tools in your toolkit, and it's useful to ask whether you've chosen the most appropriate tool for the task.

In these tests, we will deploy some through single-threaded and multi-threaded processes to compare how the performance changes. The tests will vary by number of processes as well as execution source:

- Makefile
- Python
- R
- Julia

##### Makefile
Make does not quietly optimize building targets by multi-threading, but it does natively provide the option. For Makefiles, we will initiate multi-threaded processes using the `-j` flag in a recipe. This approach can be very effective but also very dangerous because Make is memory-unaware.

> TS storytime + talk about `tesseract` famously running on 4 threads

##### Python
Python is designed for running on a single thread, but you can initiate running multiple processes from within a script to divide up some piece of work through 3rd-party packages. In these tests, we'll use [`multiprocessing`](https://docs.python.org/3/library/multiprocessing.html) to do this.

##### R
R, like Python, is designed for running on a single thread, but you can initiate running multiple processes from within a script to divide up some piece of work through 3rd-party packages. 

##### Julia

### Distance Metric
Each language has packages available for install that offer different types of distance metrics. Edit-based distances are the most commonly used and measure the number of edits needed to make string `a` into string `b`. Other types include sequenced-based, like Longest Common Sub String, and token-based, like the Jaccard index, etc.

To keep the results of this experiment comparable across languages, we choose the Levanshtein distance method for each test.

Now, we also need to check whether each method we use self-optimizes with multi-threading. 
- [ ] `stringdist`
- [ ] `fuzzywuzzy` 
- [ ] `rapidfuzz` 
- [ ] `jellyfish` 
- [ ] `Levanshtein` 
- [ ] `textdistance` 
- [ ] `distance`

### Processes
While we're talking about single- and multi-threaded processes, it's important to think about the hardware that will perform the computations. The number of processes we _can_ use and _should_ use are informed by what we have available, in addition to what our task really needs.

Each CPU has a number of cores and each core will have 2 threads. The threads are what we can run a process on, like a script.

The advice used to be that you should limit your request to the number of _cores_ available, not the threads, but we're not sure how practical this advice is today. If you're using shared resources, however, it's good practice to limit the maximum requested resources based on the time of day and other active users (you can schedule large jobs to run in the middle of the night, for example). 

For this 'experiment', each test will be run on a specific number of threads:
- 1 (single-threaded)
- 2 (twofold increase)
- 4 (fourfold increase)

- 32 (1/4 available)
- 64 (1/2 available)
- 128 (all available)

this still might be too much? but i think could be useful

### Benchmarking
We will be using the [`hyperfine`](https://github.com/sharkdp/hyperfine) command-line tool to benchmark our 

We are interested in 3 pieces of information:

- how long it takes to run the calculation for a single piece of data?
- how long it takes to run the calculation for all the data?
- how long it takes to return the run that calculates all metrics for all pieces of data?

Do we want to amend any of this?

# Goal
Explore performance of single-threaded vs. multi-threaded code, including through different languages.

# don't forget to say