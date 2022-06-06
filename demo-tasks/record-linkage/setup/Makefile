path := "http://data.dws.informatik.uni-mannheim.de/benchmarkmatchingtasks/data/music_(iTunes-Amazon)"
filenames := gs_train.csv gs_val.csv gs_test.csv feature_vector.zip records.zip

.PHONY: all clean

all: $(patsubst %,output/downloaded/%,$(filenames)) \
	output/2_amazon_music.csv \
	output/1_itunes.csv

clean: 
	-rm -r output/*

output/downloaded/%: 
	curl $(path)/$* --create-dirs -o $@

output/%.csv: output/downloaded/records.zip
	unzip $< record_descriptions/$(shell basename $@) -d output
	mv output/record_descriptions/$*.csv output/
	rm -r output/record_descriptions
	touch $@

# done.
