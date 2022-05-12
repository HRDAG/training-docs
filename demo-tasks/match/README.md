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
  for datasets that have more than a few thousand records.
- classify: we use a supervised binary classifier to classify blocked pairs as
  either co-referent or not. Since calculating features for large numbers of
  candidate pairs (example: for the CO project, blocking generates around 130
  million pairs) can get complicated and messy, we separate that step into its
  own task and call it `compare`.
- cluster: If the classifier deems A to be co-referent with B, and B to be
  co-referent with C, but does not give a high score to the pair (A,C), then
  how do we group records into entities? The cluster step takes pairwise
  classification scores, and outputs a data frame with two columns, `recordid`
  and `entity_id`. All records with the same entity id are considered to refer
  to the same person.

 Depending on context and complexity, either or both of blocking and
 classification can rely on machine learning models, rather than hand-written
 code. The `TS-\*` part of the pipeline manages the generation and collection
 of training samples to supervise these processes.

### Blocking

