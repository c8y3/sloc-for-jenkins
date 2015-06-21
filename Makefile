package:
	mkdir -p lib
	cp src/index.js lib/sloc-for-jenkins
	find src/sloc_for_jenkins -type f -exec cat {} >> lib/sloc-for-jenkins \;

clean:
	rm -rf lib
	find . -name "*~" -delete

