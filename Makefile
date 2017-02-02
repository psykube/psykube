test:
	@shards build
	@cd test && sh test.sh

.PHONY: test
