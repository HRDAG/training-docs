features := ../compare/output/pair-classifier-features.parquet
labels := output/match-predictions.parquet
classifier := src/classify.R

.PHONY: all clean

all: $(labels)

clean: 
	-rm -r output/*

$(labels): $(classifier) $(features)
	-mkdir output
	Rscript --vanilla $<
	
