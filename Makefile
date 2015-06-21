BINARY_DIRECTORY=bin
BINARY=$(BINARY_DIRECTORY)/sloc-for-jenkins
COMPONENT_TEST_DIRECTORY=test/component
RESULTS_DIRECTORY=results
COMPONENT_TEST_RESULTS_DIRECTORY=$(RESULTS_DIRECTORY)/$(COMPONENT_TEST_DIRECTORY)

$(BINARY):
	mkdir -p $(BINARY_DIRECTORY)
	> $(BINARY)
	cat src/shebang >> $(BINARY)
	cat src/index.js >> $(BINARY)
	find src/sloc_for_jenkins -type f -exec cat {} >> $(BINARY) \;
	cat src/main.js >> $(BINARY)
	chmod +x $(BINARY)

.PHONY: package test clean

package: $(BINARY)

test: $(BINARY)
	mkdir -p $(COMPONENT_TEST_RESULTS_DIRECTORY)/one_file/output
	$(BINARY) $(COMPONENT_TEST_DIRECTORY)/one_file/input/ -o $(COMPONENT_TEST_RESULTS_DIRECTORY)/one_file/output/sloccount.sc
	diff $(COMPONENT_TEST_DIRECTORY)/one_file/output/sloccount.sc $(COMPONENT_TEST_RESULTS_DIRECTORY)/one_file/output/sloccount.sc
	mkdir -p $(COMPONENT_TEST_RESULTS_DIRECTORY)/two_files/output
	$(BINARY) $(COMPONENT_TEST_DIRECTORY)/two_files/input/ -o $(COMPONENT_TEST_RESULTS_DIRECTORY)/two_files/output/sloccount.sc
	diff $(COMPONENT_TEST_DIRECTORY)/two_files/output/sloccount.sc $(COMPONENT_TEST_RESULTS_DIRECTORY)/two_files/output/sloccount.sc

clean:
	rm -rf $(BINARY_DIRECTORY) $(RESULTS_DIRECTORY)
	find . -name "*~" -delete

