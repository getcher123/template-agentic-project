SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

.PHONY: help setup-ci lint typecheck test test-fast format clean configure-required local-validate validate-docs validate-kit

help:
	@echo "Available commands:"
	@echo "  make setup-ci    Install CI dependencies for this project"
	@echo "  make lint        Run lint checks"
	@echo "  make typecheck   Run type checks"
	@echo "  make test        Run full test suite"
	@echo "  make test-fast   Run fast/local tests"
	@echo "  make format      Format code"
	@echo "  make clean       Remove local generated files"
	@echo
	@echo "This generic Makefile must be configured for <PROJECT_NAME> before PR validation can be trusted."

configure-required:
	@echo "This target is not configured for <PROJECT_NAME> yet." >&2
	@echo "Replace the generic Makefile targets with project-specific commands before marking CI green." >&2
	@exit 2

setup-ci lint typecheck test test-fast format:
	@$(MAKE) configure-required

# Kit structure is not evidence that the consuming application's tests passed.
validate-kit:
	@python3 scripts/check-agent-kit.py

validate-docs: validate-kit

local-validate: lint typecheck
	@test -n "$(TARGETED_TESTS)" || { echo "Name affected tests in TARGETED_TESTS" >&2; exit 2; }
	@$(MAKE) test-fast TARGETED_TESTS="$(TARGETED_TESTS)"

clean:
	@echo "No project-specific clean command configured."
