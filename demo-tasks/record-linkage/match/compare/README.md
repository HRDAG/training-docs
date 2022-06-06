## The Basics
The `compare` task takes in pairs of data and the original records, and
compares the record contents of paired records in order to output features
associated with the pairs. These can be indicators (example: artist name is the
same, true or false) or distance metrics (string distance between song name in
record1 and song name in record 2). These features are used by the `classify`
step to label candidate pairs (coming from `blocking`)

## Further reading

[string metric wikipedia entry](https://en.wikipedia.org/wiki/String_metric)

To-do: other readings

## Exercises

What other features would be useful here? Records are identified by the song
time, song name, artist name, and date of release. So any of these fields can
be compared between records in a variety of ways: difference in song time, ...
