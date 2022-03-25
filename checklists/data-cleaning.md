### Data Cleaning routines
There are many stages of work and types of tasks that begin first with cleaning.
This checklist is meant to provide a standard routine and starting block of 
scripts that can be followed in these cases. This is an iterative process that 
should be expected to be revised throughout your work on the task and your 
exposure to the dataset.

Repetitive assert statements and logging can seem redundant, and in some cases 
can be, but it's useful to rigorously vet and record the characteristics of a 
dataset to chart how it changes or doesn't change. In the event debugging is 
necessary, abundant asserting and logging habits can save us from an otherwise 
overwhelming investigation into the cause of an error. It can also clue us in 
to a need to re-run a task on the dataset if it's changed since our last run.

#### Import
The import script is meant to read in upstream data before any other script, 
and it should not do any data manipulation or formatting(1). Instead, it should
vet the dataset according to the known features and unique values we expect to see
after some exploratory analysis.
- [] no changes to core dataset or data structure
- [] assert statements for all known features (ie. shape, column names, etc)
- [] logging of unique features and a sample of unique values for a random sample

#### Clean
The clean script is the first run at cleaning up data with inconsistent or 
unruly characteristics. A lot of our datasets will have text data which 
*should* represent some underlying artifact, like names, jurisdictions, etc. 
These have parameters we recognize as humans, but may include features that 
could confuse or mislead the compiler or model like inconsistent 
capitalization, erroneous symbols, extra spaces, etc. It's also likely 
numeric data needs attention, like integers converted from Excel files that 
now appear as strings as in '42.0'. This script should get the contents of the 
dataset ready formatting to the task.
- [] none to minimal changes to the data or content structure
- [] assert statements for cleaning methods, known features, expected shape
- [] logging of unique features and a sample of unique values for a random sample

#### Format
The format script is where changes to data structure and relational features 
happens, and those artifacts we expect to see should be formatted according to 
their rules. For things like badge numbers, this may not be as straightforward 
as we hope, and the rules may be best informed by repeated sampling of the data.
- [] only changes to data contents happen in a formatting procedure
- [] assert statements for formatting methods, known features, expected shape
- [] logging of unique features and a sample of unique values for a random sample 

#### Task-specific steps
After data has been imported, cleaned, and formatted for the proceeding task,
then task-specific steps can be completed. This may be another series of 
formatting scripts, combining the data with another similar dataset,
other record linkage, etc. As is standard, you should have:
- [] asserts for what is known at this level, and for methods created for this task
- [] logging of unique characteristics that appear at this level, and of a random sample of datapoints

##### Footnotes:
1. When necessary, the import script may convert an upstream dataset to another file type,
but otherwise shouldn't alter the data. (ie. fname.xlsx to fname.parquet)

###### done.
