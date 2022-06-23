recs := ../import/output/music.parquet
labs := ../classify/output/match-predictions.parquet

entities := output/entity-ids.parquet
summary  := output/cluster-summary.yaml

.PHONY: all clean

all: $(entities) $(summary)

clean: 
	-rm -r output/*

$(entities): src/cluster.R $(recs) $(labs)
	-mkdir output
	Rscript --vanilla $<

$(summary): src/make-summary.R $(entities)
	Rscript --vanilla $<
	
