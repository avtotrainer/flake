# Makefile — NixOS system generations cleanup (SAFE MODE)

PROFILE := /nix/var/nix/profiles/system
KEEP_FILE := KEEP

.PHONY: list keep-file last gc boot clean

list:
	sudo nix-env --profile $(PROFILE) --list-generations

# ─────────────────────────────────────────────
# MODE 1: KEEP file (explicit, mandatory)
# ─────────────────────────────────────────────

keep-file:
	@if [ ! -f $(KEEP_FILE) ]; then \
		echo "ERROR: KEEP file not found. Aborting."; \
		exit 1; \
	fi
	@KEEP="$$(cat $(KEEP_FILE))"; \
	echo "Keeping generations: $$KEEP"; \
	DEL="$$(sudo nix-env --profile $(PROFILE) --list-generations \
		| awk '{print $$1}' \
		| grep -vwE "$$(echo $$KEEP | tr ' ' '|')")"; \
	if [ -z "$$DEL" ]; then \
		echo "Nothing to delete."; \
	else \
		echo "Deleting generations: $$DEL"; \
		sudo nix-env --profile $(PROFILE) --delete-generations $$DEL; \
	fi
	@rm -f $(KEEP_FILE)
	@echo "KEEP file removed."

# ─────────────────────────────────────────────
# MODE 2: keep last N generations
# usage: make last N=3
# ─────────────────────────────────────────────

last:
	@if [ -z "$(N)" ]; then \
		echo "ERROR: N is not set. Usage: make last N=3"; \
		exit 1; \
	fi
	@echo "Keeping last $(N) generations"
	sudo nix-env --profile $(PROFILE) --delete-generations +$(N)

# ─────────────────────────────────────────────
# GC & boot sync
# ─────────────────────────────────────────────

gc:
	sudo nix-collect-garbage

boot:
	sudo nixos-rebuild boot --flake .#laptop

clean: gc boot

