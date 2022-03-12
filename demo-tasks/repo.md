### Repo demo

Suppose we have a new project to work on, `sample_project`, and we’d like to familiarize ourselves with the existing work before implementing our new task: an exploratory keyword search.

Viewing the repo on GitHub, we observe a README file and two tasks already underway, `import` and `parent_task`.

```
.
├── README.md
├── import
│   ├── dedupe
│   │   ├── Makefile
│   │   └── src
│   ├── export
│   │   ├── Makefile
│   └── preproc
│       ├── Makefile
│       └── src
└── parent_task
    ├── clean
    │   ├── Makefile
    │   └── src
    ├── core_task
    │   ├── Makefile
    │   └── src
    ├── export
    │   ├── Makefile
    └── import
        └── export
            ├── Makefile
```

We click around inside the import task and notice it’s pretty standard cleaning/formatting work that collects our raw partner data from excel spreadsheets and transforms it into a pandas DataFrame for the ensuing tasks. Some deduplication is done to make sure none of the records in the excel files are duplicated in other rows, and then we add a unique identifier for each unique record. It looks like we’re missing some I/O but otherwise it looks good, so we move on to `parent_task` to observe the condition of the data upstream from the task we want to create.

The `parent_task` work requires one special `core_task` alongside `clean`, so we know some more concrete data manipulation is done upstream from us. We can’t see what’s in `export/output` from here but the Makefile tells us to expect another `.parquet` of a DataFrame.

Next, we use the terminal to access our workspace (local or remote) and `git clone` the sample_project into it. We can now move into the project directory and run `snap pull` to fill in the missing I/O and other files not tracked by .git. We take a look at the project’s `tree` and confirm the input and output directories are now in the repo.

*sample_project `tree`*

```
.
├── README.md
├── import
│   ├── dedupe
│   │   ├── Makefile
│   │   ├── input
│   │   ├── output
│   │   └── src
│   ├── export
│   │   ├── Makefile
│   │   └── output
│   └── preproc
│       ├── Makefile
│       ├── input
│       ├── output
│       └── src
└── parent_task
    ├── clean
    │   ├── Makefile
    │   ├── input
    │   ├── output
    │   └── src
    ├── core_task
    │   ├── Makefile
    │   ├── input
    │   ├── output
    │   └── src
    ├── export
    │   ├── Makefile
    │   └── output
    └── import
        └── export
            ├── Makefile
            └── output
```

Before we make a new directory for our task, we create a new branch and check into it with `git checkout -b our-branch`. This allows us to work on the existing repo but from `our-branch`, so that we can explore changes separately from the published `main` branch. As we implement our task and its steps, we will continuously make pushes and merge our work to the main branch, but we keep these changes separate upfront to help avoid merge conflicts and disrupting the work of anyone else making changes to the same repo at the same time as us.

# done.
