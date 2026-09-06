SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

.PHONY: help setup-ci lint typecheck test test-fast format clean local-validate validate-docs package package-check

help:
	@echo "Available commands:"
	@echo "  make setup-ci    Install CI dependencies for this project"
	@echo "  make lint        Run lint checks"
	@echo "  make typecheck   Run type checks"
	@echo "  make test        Run full test suite"
	@echo "  make test-fast   Run fast/local tests"
	@echo "  make package     Rebuild the distributable template ZIP"
	@echo "  make package-check Verify the ZIP matches tracked template files"
	@echo "  make format      Format code"
	@echo "  make clean       Remove local generated files"
	@echo
	@echo "This repository validates the universal project agent template."

setup-ci:
	@echo "No external CI dependencies are required for template validation."

lint:
	@bash -n universal-project-agent-template/install.sh
	@find scripts universal-project-agent-template/modules -name '*.sh' -print0 | xargs -0 -n1 bash -n
	@python3 scripts/check-agent-kit.py
	@python3 scripts/sync-template-mirrors.py --check

typecheck:
	@python3 -c 'import ast, pathlib; [ast.parse(p.read_text(), filename=str(p)) for base in ("scripts", "universal-project-agent-template/core/scripts") for p in pathlib.Path(base).glob("*.py")]; print("Python syntax passed; no typed application runtime is configured.")'

test:
	@python3 scripts/test-agent-kit.py

test-fast:
	@python3 scripts/check-agent-kit.py
	@python3 scripts/sync-template-mirrors.py --check

validate-docs: test-fast

local-validate: lint typecheck
	@test -n "$(TARGETED_TESTS)" || { echo "Name unittest cases in TARGETED_TESTS" >&2; exit 2; }
	@python3 scripts/test-agent-kit.py $(TARGETED_TESTS)

package:
	@python3 scripts/package-template.py

package-check:
	@python3 scripts/package-template.py --check

format:
	@echo "No formatter is configured for markdown/template files."

clean:
	@echo "Tests use isolated temporary directories and clean them automatically."
