expected := output/expected-pair-counts.yaml
pairs    := output/candidate-pairs.parquet
features := ../blocking-features/output/blockfeats.parquet

.PHONY: all clean

all: $(expected) $(pairs)

clean: 
	-rm -r output/*

$(expected): src/count-pairs.R $(features)
	-mkdir output
	Rscript --vanilla $<
	
$(pairs): src/generate-pairs.R $(features)
	-mkdir output
	Rscript --vanilla $<

# done.
