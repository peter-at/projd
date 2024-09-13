MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

all : help ;

PHONY_TGTS := help
.PHONY: $(PHONY_TGTS)

help:
	@echo "**** Help ****"
	@grep -E "(^# make|^#\s+-)" Makefile

# make clone  - clone repos for development
#	[ -d pystructurizr ] || git clone --filter=blob:none https://github.com/nielsvanspauwen/pystructurizr.git
clone:
	[ -d kroki ] || git clone --filter=blob:none https://github.com/yuzutech/kroki.git
