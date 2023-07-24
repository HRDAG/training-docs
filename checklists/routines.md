# routines
Before a leg of data processing or analysis, it's often useful to do a pass at cleaning 
and formatting the data for the work ahead. This checklist is meant to provide a sample 
outline of data processing steps from import to export.

Reminder: Development is an iterative process and revisions should be expected as your 
skills and understanding of the dataset evolve. Most if not all of the work we create 
is added in a logical order overtime as a project progresses and we look for things to 
inform our next steps, but it's important to be critical about where a unit of code 
"belongs" in the workflow and revise earlier work when doing so would eliminate the 
need for corrective steps downstream.

Repetitive assert statements and logging can seem redundant, and in some cases 
can be, but it's useful to rigorously vet and record the characteristics of a 
dataset to chart how it changes or doesn't change. In the event debugging is 
necessary, abundant asserting and logging habits can save us from an otherwise 
overwhelming investigation into the cause of an error between several tasks. It can 
also clue us in to a need to re-work a task whose input's changed since our last run, 
or catch a major flaw in a recent update that changed the output in unexpected ways.

### Import
The import script is meant to read in upstream data before any other task in a series, 
acting as the starting point to a leg of processing. It should not do any data 
manipulation or formatting of content.
- [] no changes to dataset contents
- [] assert statements for known features (ie. shape, column names, etc) and select values
- [] logging of unique features and a sample of unique values for a few random records
- [] format column names to "clean" equivalent ([per janitor](https://www.rdocumentation.org/packages/janitor/versions/1.2.0/topics/clean_names))
- [] filetype to .parquet if not already

### Filter
The filter script is not always necessary but it can be useful to formalize steps to 
drop records that are not suited for downstream work. For example, if the next steps 
are about cleaning narrative text and setting up indicator variables, then it would be 
appropriate to drop records missing narrative text before we do that. If we were 
specifically looking at narratives from incidents in the last 10 years, we could apply 
that cutoff here, too.

With small datasets, these decisions don't make much of a change 
in processing time, but as a project scales being critical of what work is done on what 
records can improve performance and auditability.

- [] records are not altered but might be dropped from input
- [] assert statements for filtering methods, known features, sample of records
- [] logging of unique features and a sample of unique values for a random sample 

### Clean
The clean script is the first run at cleaning up data with inconsistent or 
unreliable values. 

##### missingness
A lot of our datasets contain free text fields which are meant to represent some 
underlying artifact, like names, jurisdictions, etc. These artifacts can have 
boundaries we understand conceptually, like whether negative values are possible 
(think measurements of time), and we should do our best to apply the conceptual 
boundaries to our data processing. This might mean adding steps to recover salvageable 
records or marking them as lost for possible hand labeling at a later time.

##### datatypes
We should know some logical boundaries for data fields as well as their ideal or 
expected data _type_. This is the place to convert fields to the appropriate type and 
make any other cleaning steps needed to do so.

##### simplifying
We may want to apply some cleaning ahead of doing ML or analysis, where things like 
inconsistent capitalization, erroneous symbols, extra spaces, etc. can add superficial 
uniqueness and complicate results.

Overall:
- [] minimal changes to the data, content structure (ie. only what needs doing)
- [] assert statements for support methods, known features, sample of records
- [] logging of unique features and a sample of unique values for a random sample
- [] fields are appropriate datatypes (missing values are missing, numeric fields numeric)

### Export
Here we'd use a makefile to symlink clean/output to export/output. This is the final 
task in a series and the data coming out of it is "done" as far as this series of tasks 
is concerned.

- [] if any source code is needed, it is not better suited in an upstream script


***note:*** This example specifies the task order import -> filter -> clean -> export, 
but we think critically about the order of steps and ensure they're appropriate for 
the data as it actually exists. What might be a reason to reverse the task order?

done.
