FLAGS = -std=c++17 -isysroot$(SYSROOT) -o RootHelper
LDID_FLAGS = -S../Swifile/Swifile.entitlements

.PHONY: RootHelper

RootHelper:
	$(foreach arch, $(subst \s, , $(ARCHS)), \
		$(eval FLAGS += -arch $(arch)))
	g++ RootHelper.cpp $(FLAGS)
	ldid $(LDID_FLAGS) ./RootHelper