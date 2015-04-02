.PHONY: doc test

default: help

help:
	@echo "Targets:"
	@echo '  test	- Run tests'
	@echo '  doc    - Build docs'

test:
	prove -vr test/

doc:
	make -C doc/

clean:
	rm -fr django
