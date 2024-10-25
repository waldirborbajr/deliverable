# Binary name
BINARY_NAME=deliverable

# Build directory
BUILD_DIR=bin

# Go parameters
GOCMD=go
GORUN=$(GOCMD) run
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean -cache
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
TIDY=$(GOCMD) mod tidy
UPDATE=$(GOCMD) get -u all

# Main package path
MAIN_PATH=./cmd/main.go

# Build flags
LDFLAGS=-ldflags "-s -w -X=main.version=$(VERSION)"
GCFLAGS=-gcflags="all=-trimpath=$(pwd);-N -l"
ASMFLAGS=-asmflags="all=-trimpath=$(pwd)"

# Optimization flags
OPTIMIZATION_FLAGS=-tags 'osusergo netgo static_build' -installsuffix netgo

# Release flags combining speed, size, and security optimizations
RELEASE_FLAGS=$(LDFLAGS) $(GCFLAGS) $(ASMFLAGS) $(OPTIMIZATION_FLAGS) -trimpath

.PHONY: all build clean test install release deps

build:
	$(GOBUILD) -o $(BUILD_DIR)/$(BINARY_NAME) $(MAIN_PATH)

run:
	$(GORUN) $(MAIN_PATH)

release:
	# Linux AMD64
	env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 $(GOBUILD) $(RELEASE_FLAGS) -o $(BUILD_DIR)/linux/$(BINARY_NAME) $(MAIN_PACKAGE_PATH)

# Help target
help:
	@echo "Available targets:"
	@echo "  deps     - Get dependencies"
	@echo "  build    - Build the binary"
	@echo "  clean    - Clean build artifacts"
	@echo "  test     - Run tests"
	@echo "  install  - Install the plugin to ~/.tmux/plugins/tmux-docker-monitor"
	@echo "  release  - Build optimized release version (speed, size, and security)"
	@echo "  help     - Show this help message"
