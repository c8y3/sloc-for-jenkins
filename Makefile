BINARY_DIRECTORY=bin
BINARY=$(BINARY_DIRECTORY)/sloc-for-jenkins
RESULTS_DIRECTORY=results
COMPONENT_TEST_DIRECTORY=$(RESULTS_DIRECTORY)/test/component

.PHONY: package test clean

package:
	mkdir -p $(BINARY_DIRECTORY)
	> $(BINARY)
	cat src/shebang >> $(BINARY)
	cat src/index.js >> $(BINARY)
	find src/sloc_for_jenkins -type f -exec cat {} >> $(BINARY) \;
	cat src/main.js >> $(BINARY)
	chmod +x $(BINARY)

test:
	mkdir -p $(COMPONENT_TEST_DIRECTORY)/one_file/output
	$(BINARY) test/component/one_file/input/ -o $(COMPONENT_TEST_DIRECTORY)/one_file/output/sloccount.sc
	diff test/component/one_file/output/sloccount.sc $(COMPONENT_TEST_DIRECTORY)/one_file/output/sloccount.sc
	mkdir -p $(COMPONENT_TEST_DIRECTORY)/component/two_files/output
	$(BINARY) test/component/two_files/input/ -o $(COMPONENT_TEST_DIRECTORY)/component/two_files/output/sloccount.sc
	diff test/component/two_files/output/sloccount.sc $(COMPONENT_TEST_DIRECTORY)/component/two_files/output/sloccount.sc

clean:
	rm -rf $(BINARY_DIRECTORY) $(RESULTS_DIRECTORY)
	find . -name "*~" -delete

