SHELL   := /bin/bash
VERSION := v1.1.0
GOOS    := $(shell go env GOOS)
GOARCH  := $(shell go env GOARCH)

.PHONY: all
all: vet build

.PHONY: build
build:
	go build -ldflags "-X main.version=$(VERSION)" ./cmd/rsslap

.PHONY: vet
vet:
	go vet

.PHONY: package
package: clean vet build
ifeq ($(GOOS),windows)
	zip rsslap_$(VERSION)_$(GOOS)_$(GOARCH).zip rsslap.exe
	sha1sum rsslap_$(VERSION)_$(GOOS)_$(GOARCH).zip > rsslap_$(VERSION)_$(GOOS)_$(GOARCH).zip.sha1sum
else
	gzip rsslap -c > rsslap_$(VERSION)_$(GOOS)_$(GOARCH).gz
	sha1sum rsslap_$(VERSION)_$(GOOS)_$(GOARCH).gz > rsslap_$(VERSION)_$(GOOS)_$(GOARCH).gz.sha1sum
endif

.PHONY: clean
clean:
	rm -f rsslap rsslap.exe
