FLAGS = -std=c++17
LDID_FLAGS = -S../Swifile/Swifile.entitlements

.PHONY: all firstnotes RootHelper
all: firstnotes RootHelper

firstnotes:
	@echo
	@echo "This is a C++ project which will be ran on iOS."
	@echo "Get a cross compiler for AArch64 architecture for iOS."
	@echo
	@echo "You must override the CC variable in order to make this use your selected compiler."
	@echo

RootHelper:
	$(CC) $(FLAGS) RootHelper.cpp
	ldid $(LDID_FLAGS) ./RootHelper