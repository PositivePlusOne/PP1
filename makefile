
.PHONY: app-import-sorter
app-import-sorter:
	cd app && dart run import_sorter:main && ../scripts/tidy-mobile-import-sorter.sh
