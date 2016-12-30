deps:
	shards install

build: deps
	crystal build --release ./src/psykube.cr
