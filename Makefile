BINDIR = $(PWD)/node_modules/.bin

SRC = $(shell find src -name "*.coffee")
SRCJS = $(SRC:src/%.coffee=lib/%.js)

lib/%.js: src/%.coffee
	rm -f $@
	$(BINDIR)/coffee -b -o $(@D) -c $<
	cat ./tmp/app.test.pid 2>/dev/null | xargs kill -s SIGUSR2 2>/dev/null | true
	cat ./tmp/app.development.pid 2>/dev/null | xargs kill -s SIGUSR2 2>/dev/null | true

www/js/app/%.js: lib/app/%.js
	echo "define(function (require,exports,module) {\n" > $@
	cat $< >> $@
	echo "\n\nreturn module.exports;\n});" >> $@

INTTESTS = $(shell find test/integration -name "*.coffee")
INTTESTSJS = $(INTTESTS:test/integration/%.coffee=www/js/test/%.js)

www/js/test/%.js: test/integration/%.coffee
	$(BINDIR)/coffee -o $(@D) -c $<

LESS = $(shell find src/style -name "*.less")
www/css/app.css: $(LESS)
	$(BINDIR)/lessc -Ivendor/bootstrap/less src/style/app.less > $@

www/css/mocha.css: node_modules/mocha/mocha.css
	cp $< $@

NCT = $(shell find templates -name "*.nct")
NCTCOMPILED = $(NCT:templates/%.nct=lib/templates/%.js)

lib/templates/%.js: templates/%.nct
	$(BINDIR)/nct --dir templates/ $< > $@

www/js/templates.js: $(NCTCOMPILED)
	echo "define(['nct','underscore'], function(nct, _) {" > $@
	cat $(NCTCOMPILED) >> $@
	echo "});" >> $@

APPJS = $(shell find lib/app -name "*.js")
REQUIREAPPJS = $(APPJS:lib/app/%.js=www/js/app/%.js)

www/js/app.js: $(REQUIREAPPJS) requirejs.build.js
	$(BINDIR)/r.js -o requirejs.build.js
	say "Done"

www/js/require.js: node_modules/requirejs/require.js
	cp node_modules/requirejs/require.js www/js/require.js

www/js/sockjs-0.3.2.min.js: vendor/js/sockjs-0.3.2.min.js
	cp vendor/js/sockjs-0.3.2.min.js www/js/sockjs-0.3.2.min.js

www/js/vendor/jquery.js: vendor/js/jquery-1.7.2.min.js
	cp $< $@

www/js/vendor/underscore.js: vendor/js/underscore-1.3.3.min.js
	cp $< $@

www/js/vendor/moment.js: vendor/js/moment.min.js
	cp $< $@

www/js/vendor/nct.js: node_modules/nct/dist/nct.js
	cp $< $@

www/js/vendor/backbone.js: node_modules/backbone/backbone.js
	cp $< $@

www/js/vendor/page.js: node_modules/page/build/page.js
	cp $< $@

www/js/vendor/toObject.js: vendor/js/toObject.js
	cp $< $@

www/js/vendor/mocha.js: node_modules/mocha/mocha.js
	cp $< $@

VENDORJS = jquery underscore moment backbone nct page toObject mocha
VENDORJS := $(VENDORJS:%=www/js/vendor/%.js)
JSFILES = www/js/templates.js www/js/require.js www/js/sockjs-0.3.2.min.js

all: $(SRCJS) $(VENDORJS) $(REQUIREAPPJS) www/css/app.css www/css/mocha.css $(JSFILES) $(INTTESTSJS)

prod: all www/js/app.js
