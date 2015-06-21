MKDIR=mkdir -p

BINARY_DIRECTORY=bin
BINARY=$(BINARY_DIRECTORY)/sloc-for-jenkins
COMPONENT_TEST_DIRECTORY=test/component
RESULTS_DIRECTORY=results
COMPONENT_TEST_RESULTS_DIRECTORY=$(RESULTS_DIRECTORY)/$(COMPONENT_TEST_DIRECTORY)

$(BINARY):
	@ echo "Preparing $(BINARY)..."
	@ $(MKDIR) $(BINARY_DIRECTORY)
	@ > $(BINARY)
	@ cat src/shebang >> $(BINARY)
	@ cat src/index.js >> $(BINARY)
	@ find src/sloc_for_jenkins -type f -exec cat {} >> $(BINARY) \;
	@ cat src/main.js >> $(BINARY)
	@ chmod +x $(BINARY)

.PHONY: package test clean

package: $(BINARY)

test: $(BINARY)
	@ for test_case in `ls $(COMPONENT_TEST_DIRECTORY)`; \
	do \
	 	echo "Processing test: $${test_case}..."; \
		$(MKDIR) $(COMPONENT_TEST_RESULTS_DIRECTORY)/$${test_case}/output; \
		$(BINARY) $(COMPONENT_TEST_DIRECTORY)/$${test_case}/input/ -o $(COMPONENT_TEST_RESULTS_DIRECTORY)/$${test_case}/output/sloccount.sc; \
		diff $(COMPONENT_TEST_DIRECTORY)/$${test_case}/output/sloccount.sc $(COMPONENT_TEST_RESULTS_DIRECTORY)/$${test_case}/output/sloccount.sc; \
		result=$$?; \
		if [ $$result != 0 ]; then exit $$result; fi; \
	done

clean:
	rm -rf $(BINARY_DIRECTORY) $(RESULTS_DIRECTORY)
	find . -name "*~" -delete

