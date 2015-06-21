BINARY_DIRECTORY=bin
BINARY=$(BINARY_DIRECTORY)/sloc-for-jenkins

.PHONY: package clean

package:
	mkdir -p $(BINARY_DIRECTORY)
	> $(BINARY)
	cat src/shebang >> $(BINARY)
	cat src/index.js >> $(BINARY)
	find src/sloc_for_jenkins -type f -exec cat {} >> $(BINARY) \;
	cat src/main.js >> $(BINARY)

clean:
	rm -rf $(BINARY_DIRECTORY)
	find . -name "*~" -delete

