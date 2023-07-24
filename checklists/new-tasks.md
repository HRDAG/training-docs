### Task directories

#### Minimum requirements
- [] `src` directory created
- [] Makefile created
- If tracking input, `input` directory should be created (else: not necessary)
- Ideally, the first target in a makefile makes the `output` directory at runtime \
(usually "-mkdir output")

#### Supplemental requirements
_If documents are provided alongside partner data,_
- [] `docs` directory created
- [] relevant doc(s) moved into `docs`

_If hand-coded input referenced by code,_
- [] `hand` directory created
- [] hand-coded files saved to `hand`

_If input/output has been manually altered in task,_
- [] `frozen` directory created
- [] manually altered data saved to `frozen`

_If notebooks used in task,_
- [] `note` directory created
- [] notebook(s) moved to `note`

#### Task-by-task requirements
_If task is first in series,_
- [] `import` task directory created

_If task is last in series,_
- [] `export` created 
- [] `export/Makefile` symbolically links `last-actual-task/output` to `export/output/`

# done.
