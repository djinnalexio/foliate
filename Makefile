.PHONY: run delete-data flatpak-install flatpak-uninstall flatpak-run flatpak-test \
		flatpak-delete-data lint lint-fix format format-fix

APP := com.github.johnfactotum.Foliate
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
DATA := data
STAGING ?= $(HOME)/Projects/.gnome-builder/projects/foliate/flatpak/staging
NODE_MODULES_STAMP := node_modules/.install-stamp

.DEFAULT_GOAL := run

# ---- Testing -----------------------------------------------------------------

$(DATA)/gschemas.compiled: $(wildcard $(DATA)/*.gschema.xml)
	@glib-compile-schemas $(DATA)

run: $(DATA)/gschemas.compiled
	@ G_MESSAGES_DEBUG=all GSETTINGS_SCHEMA_DIR=$(DATA) gjs -m src/main.js

delete-data:
	@rm -rf $(HOME)/.local/share/$(APP) $(HOME)/.cache/$(APP)

# ---- Flatpak -----------------------------------------------------------------

flatpak-install:
	@flatpak install --user --noninteractive --reinstall $(STAGING)/x86_64-$(BRANCH)/$(APP).flatpak

flatpak-uninstall:
	@flatpak uninstall --user --noninteractive $(APP)

flatpak-run:
	@ G_MESSAGES_DEBUG=all flatpak run $(APP)

flatpak-test: flatpak-install flatpak-run

flatpak-delete-data:
	rm -rf $(HOME)/.var/app/$(APP)/data $(HOME)/.var/app/$(APP)/cache

# ---- Quality -----------------------------------------------------------------

$(NODE_MODULES_STAMP): package.json package-lock.json
	npm ci
	@touch $@

lint: $(NODE_MODULES_STAMP)
	npm run lint

lint-fix: $(NODE_MODULES_STAMP)
	npm run lint:fix
