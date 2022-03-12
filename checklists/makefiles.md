### Makefiles

#### Standard features
- [] Makefile exists at task level (ie. `clean/Makefile`)
- [] Makefile contains
    - [] standard script header and footer, including path/to/here
    - [] `.PHONY all clean`
    - [] `all` target
    - [] `clean` target
    - [] all task input paths (ie. `clean/input/all-mentions.parquet`, `clean/hand/ref-table.parquet`)
    - [] all task output paths (ie. `clean/output/clean-mentions.parquet`)
    - [] all task script paths (ie. `clean/src/clean.py`)

#### Standard functionality
- [] `make clean` successfully purges `output` contents
- [] `make all` successfully rebuilds `output` contents
