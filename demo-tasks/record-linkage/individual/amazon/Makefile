setup := ../../setup/output
input := $(setup)/2_amazon_music.csv
output := output/amz.parquet
src := src/import-amz.R

.PHONY: all clean

all: $(output)

clean: 
	-rm -r output/*

$(output): $(src) $(input)
	-mkdir output
	Rscript --vanilla $< \
		--input=$(input) \
		--output=$@

# done.
