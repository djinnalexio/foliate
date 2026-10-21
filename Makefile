.PHONY: delete-data flatpak-delete-data flatpak-install flatpak-run \
		flatpak-test flatpak-uninstall format format-fix lint lint-fix \
		po-check po-stats po-update pot run

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

# ---- Translations ------------------------------------------------------------

pot:
	@xgettext --files-from=po/POTFILES \
		--output='po/$(APP).pot' \
		--from-code=UTF-8 \
		--package-name='$(APP)' \
		--copyright-holder='Foliate Contributors' \
		--add-comments=Translators:

po-update: pot
	@for po in po/*.po; do \
		msgmerge --update --backup=none "$$po" 'po/$(APP).pot' || exit 1; \
	done

po-check:
	@for po in po/*.po; do \
		msgfmt --check-format --check-header --check-domain -o /dev/null "$$po" || exit 1; \
	done

po-stats:
	@for po in po/*.po; do \
		printf '%s: ' "$$(basename "$$po" .po)"; \
		msgfmt --check --statistics -o /dev/null "$$po" 2>&1 || exit 1; \
	done
