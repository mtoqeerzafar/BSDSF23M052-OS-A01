# Root Makefile

.PHONY: all build clean

# Default target
all: build

# Delegate compilation to src/Makefile
build:
	$(MAKE) -C src

clean:
	$(MAKE) -C src clean

