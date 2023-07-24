### Makefiles

#### Standard features
- [] Makefile exists at task level (ie. `filter/Makefile`)
- [] Makefile contains
    - [] standard script header and footer
    - [] `.PHONY all clean`
    - [] `all` target listing all targets needed to "build" task
    - [] `clean` target that removes existing output
    - [] all task input paths (ie. `../import/output/complaints.parquet`)
    - [] all task output paths (ie. `output/complaints.parquet`)
    - [] all task script paths (ie. `src/filter.py`)

#### Standard functionality
Your makefile works if:
- [] `make clean` successfully clears `output` contents
- [] `make all` successfully rebuilds `output` contents


### Sample
```
# vim: set ts=8 sts=0 sw=8 si fenc=utf-8 noet:
# vim: set fdm=marker fmr={{{,}}} fdl=0 foldcolumn=4:
# Authors:     BP
# Maintainers: BP
# Copyright:   2023, HRDAG, GPL v2 or later
# =========================================
# DPA/filter/Makefile

# ---- dependencies {{{
input := ../import/output/complaints.parquet
output := output/complaints.parquet
# }}}

# ---- standard {{{
.PHONY: all clean

all: $(output)

clean: 
	-rm -r output/*
# }}}

# ---- task-specific {{{
$(output):\
		src/filter.R \
		$(input)
	-mkdir output
	Rscript --vanilla $< \
		--input=$(input) \
		--output=$@
# }}}
 
# done.
```

# done.
