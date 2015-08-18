##
## Notion xdg Makefile
##

# System-specific configuration is in system.mk
TOPDIR=..
include $(TOPDIR)/build/system-inc.mk

######################################

include $(TOPDIR)/build/rules.mk

######################################

_install:
	$(INSTALL) -m $(DATA_MODE) notion.desktop $(DESTDIR)$(PREFIX)/share/xsessions/notion.desktop
