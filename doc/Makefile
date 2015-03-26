all: pod/Spec.pod

pod/%.pod: %.swim
	swim --to=pod --complete --wrap $< > $@
