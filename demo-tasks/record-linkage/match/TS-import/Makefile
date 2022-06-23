setupdir := ../../setup/output/downloaded

inputs := $(setupdir)/gs_train.csv \
	  $(setupdir)/gs_val.csv \
	  $(setupdir)/gs_test.csv

output := output/labeled-pairs.parquet

.PHONY: all clean

all: $(output)

clean: 
	-rm -r output/*

$(output): src/import-pair-labels.R $(inputs)
	-mkdir output
	Rscript --vanilla $<

# done.
	
