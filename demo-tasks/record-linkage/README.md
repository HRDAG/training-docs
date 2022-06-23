# Blocking and record linkage (`match`)

This subdirectory contains an example project structure for record linkage. The
goal of record linkage is to take an input database where multiple records may
refer to the same person (very common if you're integrating multiple data
sources), and output a dataset that has one row per distinct person, by linking
co-referent records and using their content to assemble a synthetic "entity"
record.

## Context

Record linkage will depend on data that is already cleaned and canonicalized.
So the pipeline from raw data up through record linkage will look like:


```
.
├── individual
│   ├── SOURCEA
│   ├── SOURCEB
│   └── ...
├── pool-records
│   ├── import
│   ├── canonicalize
│   ├── ...
│   └── export
├── match
│   ├── import
│   ├── ...
│   └── export
└── ... (rest of repo)

```

Where `pool-records` produces a dataframe that contains columns for `recordid`
and `source`, along with the standardized and canonicalized record content.

If there is nothing to do in the `pool-records` step besides concatenate data
sets (this can happen e.g. when the cleaning and standardizing happened within
each of the `individual` tasks), then that step can be rolled in to
`match/import`.

## Parallel `match` tasks

It's often the case that we need to run several different versions of record
linkage, for example to produce preliminary estimates, or to produce estimates
while including or excluding a specific dataset. In that case, we build
multiple match pipelines alongside each other:

```
.
├── ...
├── match
│   ├── phase1-SOURCEA+SOURCEB
│   │   ├── import
│   │   ├── ...
│   │   └── export
│   ├── phase2-SOURCEA+SOURCEB+SOURCEC
│   │   ├── import
│   │   ├── ...
│   │   └── export
│   └── ...
└── ...
```

## Anatomy of the match task

```
match
├── import
├── blocking-features
├── blocking
├── compare
├── classify
├── cluster
├── merge
├── export
├── TS-draw
├── TS-import
├── TS-compare
├── TS-integrate
└── TS-train
```

There are four major steps to get from input data to de-duplicated entity-level
data:

- blocking: a coarse filtering for a set of "candidate pairs" that may contain
  non-matches, but should include all truly co-referent pairs. Directly
  comparing every pair of records in a database is not going to be practical
  for datasets that have more than a few thousand records. Reference: [Database
  Deduplication to Identify Victims of Human Rights Violations](https://hrdag.org/2016/01/08/a-geeky-deep-dive-database-deduplication-to-identify-victims-of-human-rights-violations/)

- classify: we use a supervised binary classifier to classify blocked pairs as
  either co-referent or not. Since calculating features for large numbers of
  candidate pairs (example: for the CO project, blocking generates around 90
  million pairs) can get complicated and messy, we separate that step into its
  own task and call it `compare`.

- cluster: If the classifier deems A to be co-referent with B, and B to be
  co-referent with C, but does not give a high score to the pair (A,C), then
  how do we group records into entities? The cluster step takes pairwise
  classification scores, and outputs a data frame with two columns, `recordid`
  and `entity_id`. All records with the same entity id are considered to refer
  to the same person. Reference: [Clustering and solving the right
  problem](https://hrdag.org/2016/07/28/clustering-and-solving-the-right-problem/)

- merge: once we have grouped co-referent records together, we run into the
  problem of outputting a single canonical record representing that entity.
  Different records referring to the same entity may have conflicting values
  for some fields, and so this step needs to make decisions about how to
  resolve those discrepancies

Depending on context and complexity, either or both of blocking and
classification can rely on machine learning models, rather than hand-written
code. The `TS-*` part of the pipeline manages the generation and collection of
training samples to supervise these processes.

### Blocking

```
match
├── ...
├── blocking-features
├── blocking
└── ...
```

### Classification

```
match
├── ...
├── compare
├── classify
└── ...
```

### Clustering and creating entity records

```
match
├── ...
├── cluster
├── merge
├── export
└── ...
```

### Collecting hand-labeled examples: the TS-\* tasks

```
match
├── ...
├── TS-draw
├── TS-import
├── TS-compare
├── TS-integrate
└── TS-train
```

**NOTE:** by convention, we represent a pair of records by their recordids with
the smaller one coming first. For recordids `r1` and `r2`, that means `(r1,r2)`
is considered the same pair as `(r2,r1)`

- `TS-draw`: samples data for labeling. We can sample data in "block" or "pair"
  format, there are good reasons to include both types. Sampling might be more
  or less random, or might be targeted. All sampling code can live in
  `TS-draw`, which also includes code required to export human-reviewable
  spreadsheets.

- `TS-integrate`: eventually we end up with training data from a variety of
  sources, including labeled pairs, labeled blocks, not to mention the negative
  pairs implied by labeled blocks. This task outputs the full set of labeled
  data used to train classifiers, search for blocking rules, and break up large
  clusters. There are usually two big outputs: `positive-pairs` is used in
  blocking, and can just be a table with two columns, `recordid1` and
  `recordid2`. `labeled-pairs` includes both positive and negative pairs, and
  importantly will include a large sample of implied negative pairs from
  labeled blocks.

- `TS-compare`: this is the equivalent in the TS cycle to the `compare` task in
  the main match pipeline. We can usually re-use the same source code for both
  tasks, the only difference is the input to `TS-compare` is
  `TS-integrate/output/labeled-pairs.xyz` whereas the input to `compare` is
  `blocking/output/candidate-pairs.xyz`

- `TS-train`: train a classifier, using features from `TS-compare` and labels
  from `TS-integrate`.

## About the example

Though the techniques used here can be used in a variety of record linkage
contexts, we most frequently use them for deduplicating databases of deaths or
disappearances in conflicts. In that context, each record will have at least
name, location, and date available to match on.

For training purposes, this repo includes a demo match task across databases of
music, where each row of data describes a single song. Our task is to
deduplicate/match rows that correspond to the same song. In this case, each
record has at least: artist name, song name, album name, release date,
genre(s), and song length available to match on. Though the context is very
different, we'll explore the same workflows and techniques that we use for
deduplicating databases of deaths and disappearances.

The data for the demo task comes from [CompERBench: Complementing Entity
Matching Benchmark
Tasks](http://data.dws.informatik.uni-mannheim.de/benchmarkmatchingtasks/), and
the `setup` directory downloads the required files using `curl`. To run the
setup task, enter the directory and type `make`:

```bash
$ cd setup && make
```

Then, go into the `individual` directory, read the README, run the
individual import tasks, and complete the exercises.

Once the `indiviual` tasks are built, you can run the `match` pipeline:

```bash
$ cd match && make
```

Make sure the pipeline runs without errors or debug as necessary. Then try out
the exercises and further reading suggested in `match/README.md`
