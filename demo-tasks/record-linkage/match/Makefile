.PHONY: all \
	import \
	blocking-features \
	blocking \
	compare \
	classify \
	cluster \
	merge \
	export

all: export

export: merge
	cd $@ && make
	
merge: import cluster
	cd $@ && make

cluster: import classify
	cd $@ && make

classify: compare
	cd $@ && make

compare: import blocking
	cd $@ && make

blocking: blocking-features
	cd $@ && make

blocking-features: import
	cd $@ && make

import: 
	cd $@ && make

# done.
