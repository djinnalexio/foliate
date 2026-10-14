.PHONY: install uninstall run test delete-data

APP := com.github.johnfactotum.Foliate
BRANCH := $$(git rev-parse --abbrev-ref HEAD)

install:
	@flatpak install --user --noninteractive --reinstall \
	/home/$$USER/Projects/.gnome-builder/projects/foliate/flatpak/staging/x86_64-$(BRANCH)/$(APP).flatpak || \
	flatpak install --user --noninteractive --reinstall \
	/var/home/$$USER/Projects/.gnome-builder/projects/foliate/flatpak/staging/x86_64-$(BRANCH)/$(APP).flatpak

uninstall:
	@flatpak uninstall --user --noninteractive $(APP)

run:
	@flatpak run $(APP)

test: install run

delete-data:
	rm -rf /home/user/.var/app/$(APP)

NODE_MODULES_STAMP := node_modules/.install-stamp

$(NODE_MODULES_STAMP): package.json package-lock.json
	npm ci
	@touch $@

lint: $(NODE_MODULES_STAMP)
	npm run lint

lint-fix: $(NODE_MODULES_STAMP)
	npm run lint:fix

