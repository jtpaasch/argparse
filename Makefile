VENDOR_DIR=vendor
TESTS_DIR=tests


all: clean install test

clean:
	rm -rf $(VENDOR_DIR)/*

install:
	mkdir -p $(VENDOR_DIR)
	rm -rf $(VENDOR_DIR)/bats
	git clone https://github.com/sstephenson/bats.git $(VENDOR_DIR)/bats

test: $(VENDOR_DIR)/bats/bin/bats $(TESTS_DIR)
	find $(TESTS_DIR) -type d -print | xargs bash $(VENDOR_DIR)/bats/bin/bats

