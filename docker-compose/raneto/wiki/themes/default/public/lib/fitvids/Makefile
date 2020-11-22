
#
# Binaries
#

BIN := ./node_modules/.bin

#
# Variables
#

DIST = dist

#
# Tasks
#

build: node_modules index.js
	@mkdir -p $(DIST)
	@browserify index.js --standalone fitvids -o $(DIST)/fitvids.js
	@uglifyjs $(DIST)/fitvids.js -o $(DIST)/fitvids.min.js

node_modules: package.json
	@npm install
	@touch node_modules

test:
	@hihat test.js

lint:
	@xo index.js test.js

size: build
	@cat $(DIST)/fitvids.js | gzip -9 | wc -c
