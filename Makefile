SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

.PHONY: help setup-ci lint typecheck test test-fast format clean configure-required

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
	@echo "This repository validates the universal project agent template."

setup-ci:
	@echo "No external CI dependencies are required for template validation."

lint:
	@bash -n universal-project-agent-template/install.sh
	@find scripts universal-project-agent-template/modules -name '*.sh' -print0 | xargs -0 -n1 bash -n

typecheck:
	@echo "No typed runtime is configured for this template repository."

test:
	@rm -rf /tmp/template-agentic-project-ci
	@mkdir -p /tmp/template-agentic-project-ci
	@universal-project-agent-template/install.sh --target /tmp/template-agentic-project-ci --mode new --profile full --apply >/tmp/template-agentic-project-install.log
	@cd /tmp/template-agentic-project-ci && scripts/check-agent-kit.sh

test-fast:
	@scripts/check-agent-kit.sh

format:
	@echo "No formatter is configured for markdown/template files."

clean:
	@rm -rf /tmp/template-agentic-project-ci /tmp/template-agentic-project-install.log
