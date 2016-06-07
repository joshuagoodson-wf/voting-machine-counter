# Adds support for the `vendor` directory
# Only needed for $(go version) < 1.6
export GO15VENDOREXPERIMENT := 1
GLIDE_VERSION := 0.10.2
GLIDE_PLATFORM?=darwin
EXEC=voting-machine-counter

ARGS = $(filter-out $@,$(MAKECMDGOALS))

## Build

all:
	@echo "Please specifiy a make target."

glide:
ifndef GOPATH
	$(error GOPATH is undefined)
endif
	@echo "[glide] Downloading glide "$(GLIDE_VERSION)" for "$(GLIDE_PLATFORM)
	@curl -OLSs \
		https://github.com/Masterminds/glide/releases/download/$(GLIDE_VERSION)/glide-$(GLIDE_VERSION)-$(GLIDE_PLATFORM)-amd64.tar.gz
	@tar -xzf glide*.tar.gz
	@mv $(GLIDE_PLATFORM)*/glide $(GOPATH)/bin/glide
	@echo "[glide] Cleaning up..."
	@rm -rf $(GLIDE_PLATFORM)*
	@rm -rf glide*.tar.gz
	@echo "[glide] done."
	@echo "[glide] glide is now installed on your GOPATH."

get:
	@glide get $(ARGS)

update:
	@glide up

deps:
	@echo "[deps] Starting..."
	@glide install
	@echo "[deps] done."

build:
	@echo "[build] Starting..."
	@go build -o $(EXEC) main.go
	@echo "[build] done."

test:
	@echo "[test] Starting..."
	@go test -cover $$(./glide novendor)
	@echo "[test] done."

lint:
	@echo "[lint] Starting..."
	@golint ./...
	@echo "[lint] done."

lint-novendor:
	@echo "[lint-novendor] Starting... (Error 1 is a success)"
	@golint ./... | grep -v vendor/

coverage:
	@go test -coverprofile=coverage.out ./$(ARGS)
	@go tool cover -html=coverage.out

run:
	@./$(EXEC)

smithy: lint glide deps test build

# "Catch-all" target to silence errors associated with
# passing arguments to targets
%:
	@:
