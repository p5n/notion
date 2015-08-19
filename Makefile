##
## Notion Makefile
##

# Include system-specific configuration: auto-generated and optionally local 
include build/system-inc.mk

# List of modules
include modulelist.mk

######################################

INSTALL_SUBDIRS=\
	$(MODULE_LIST) \
	ioncore notion etc utils man po xdg

SUBDIRS = $(LIBS_SUBDIRS) $(INSTALL_SUBDIRS)

DOCS = README.md LICENSE CHANGELOG

TO_REALCLEAN = build/ac/system-ac.mk

POTFILE=po/notion.pot

######################################

include build/rules.mk

######################################

_install:
	$(INSTALLDIR) $(DESTDIR)$(DOCDIR)
	for i in $(DOCS); do \
		$(INSTALL) -m $(DATA_MODE) $$i $(DESTDIR)$(DOCDIR); \
	done

relocatable_build:
	$(MAKE) RELOCATABLE=1 PREFIX=

snapshot:
	PWD=`pwd` ;\
	DIR=`basename "$$PWD"` ;\
	RELEASE=`./nextversion.sh`-snapshot ;\
	perl -p -i -e "s/^#define NOTION_RELEASE.*/#define NOTION_RELEASE \"$$RELEASE\"/" version.h ;\
	cd .. ;\
	tar --exclude-vcs -czf notion-$$RELEASE-src.tar.gz $$DIR ;\
	tar --exclude-vcs -cjf notion-$$RELEASE-src.tar.bz2 $$DIR ;\
	cd $$DIR ;\
	git checkout version.h

dist:
	PWD=`pwd` ;\
	DIR=`basename "$$PWD"` ;\
	RELEASE=`./nextversion.sh` ;\
	perl -p -i -e "s/^#define NOTION_RELEASE.*/#define NOTION_RELEASE \"$$RELEASE\"/" version.h ;\
	git add version.h; git commit -m "Releasing version $$RELEASE" ;\
	git tag -s -m "Release $$RELEASE" $$RELEASE ; git push --tags ;\
	git archive --prefix notion-$$RELEASE/ --format=tar.gz $$RELEASE > ../notion-$$RELEASE-src.tar.gz ;\
	git archive --prefix notion-$$RELEASE/ --format=tar $$RELEASE | bzip2 > ../notion-$$RELEASE-src.tar.bz2 ;\
	perl -p -i -e "s/^#define NOTION_RELEASE.*/#define NOTION_RELEASE \"snapshot\"/" version.h ;\
	git add version.h; git commit -m "Released version $$RELEASE" ; git push 

.PHONY: test

test:
	$(MAKE) -C mod_xrandr test
	$(MAKE) -C mod_xinerama test
	$(MAKE) -C test
