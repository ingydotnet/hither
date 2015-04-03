DATASET_NAMES := $(shell echo src/*)
CSV_FILES := $(DATASET_NAMES:src/%=csv/%.csv)

all: $(CSV_FILES)

csv/%.csv: csv
	( \
	    csv=$@; \
	    csv=$${csv#csv/}; \
	    csv=$${csv%.csv}; \
	    curl -s `readlink src/$${csv}` > $@ \
	)

csv:
	mkdir -p $@

clean:
	rm -fr csv
