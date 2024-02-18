C = ppcrossa64
FLAGS = -Tios -oRootHelper -n @$(HOME)/.fpccfg
LDID_FLAGS = -S../Swifile/Swifile.entitlements

.PHONY: all firstnotes RootHelper
all: firstnotes RootHelper

firstnotes:
	@echo
	@echo "This is a Pascal project which will be ran on iOS."
	@echo "Build a compiler (no prebuilt for now), using AArch64 architecture for iOS and a preinstalled compiler for the host machine."
	@echo
	@echo "Use samplecfg to create a new configuration file for the compiler to work."
	@echo "If installed system-wide, remove -n @<path> in FLAGS variable (inside this Makefile) and ignore this."
	@echo "Otherwise, run samplecfg and change the name of ~/.fpc.cfg to ~/.fpccfg."
	@echo

RootHelper:
	$(C) $(FLAGS) main.pas
	ldid $(LDID_FLAGS) ./RootHelper