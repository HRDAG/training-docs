### Input

#### Ideal standard
_when everyone working in the repo has access to `snap`,_
- [] Upstream input is symbolically linked to `task/input/`
- [] Activate symlink has been included in a `snap push` call

#### Secondary standard
_when parent task structure is likely to change and/or not everyone has `snap`_
- [] Upstream input is included via relative path in `task/Makefile`

#### Tertiary standard
_when this task's structure is likely to change and/or not everyone has `snap`_
- [] Upstream input is included via absolute path in `task/Makefile`
