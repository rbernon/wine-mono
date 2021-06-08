FNA_SRCS=$(shell $(SRCDIR)/tools/git-updated-files $(SRCDIR)/FNA)
FNA_NETSTUB_SRCS=$(shell $(SRCDIR)/tools/git-updated-files $(SRCDIR)/FNA.NetStub)

define MINGW_TEMPLATE +=
# FNAMF
$$(BUILDDIR)/FNAMF-$(1)/.built: $$(FNA_SRCS) $$(MINGW_DEPS)
	mkdir -p $$(@D)
	+$$(MINGW_ENV) $(MAKE) -C $$(@D) -f $$(SRCDIR_ABS)/FNA/lib/FNAMF/Makefile ARCH=$(1) SRCDIR="$$(SRCDIR_ABS)/FNA/lib/FNAMF" "MINGW=$$(MINGW_$(1))"
	touch "$$@"
ifeq (1,$(ENABLE_FNAMF))
IMAGEDIR_BUILD_TARGETS += $$(BUILDDIR)/FNAMF-$(1)/.built
endif

FNAMF-$(1).dll: $$(BUILDDIR)/FNAMF-$(1)/.built
	mkdir -p "$$(IMAGEDIR)/lib/$(1)"
	$$(INSTALL_PE_$(1)) "$$(BUILDDIR)/FNAMF-$(1)/FNAMF.dll" "$$(IMAGEDIR)/lib/FNAMF-$(1).dll"
.PHONY: FNAMF-$(1).dll

FNAMF.dll: FNAMF-$(1).dll
.PHONY: FNAMF.dll

ifeq (1,$(ENABLE_FNAMF))
imagedir-targets: FNAMF-$(1).dll
endif

clean-build-FNAMF-$(1):
	rm -rf $$(BUILDDIR)/FNAMF-$(1)
.PHONY: clean-build-FNAMF-$(1)
clean-build: clean-build-FNAMF-$(1)
endef

# FNA
$(SRCDIR)/FNA/bin/Release/FNA.dll: $(BUILDDIR)/mono-unix/.installed $(FNA_SRCS)
	+$(MONO_ENV) $(MAKE) -C $(SRCDIR)/FNA release
IMAGEDIR_BUILD_TARGETS += $(SRCDIR)/FNA/bin/Release/FNA.dll

FNA.dll: $(SRCDIR)/FNA/bin/Release/FNA.dll
	$(MONO_ENV) gacutil -i $(SRCDIR)/FNA/bin/Release/FNA.dll -root $(IMAGEDIR)/lib
.PHONY: FNA.dll
imagedir-targets: FNA.dll

clean-FNA:
	+$(MAKE) -C $(SRCDIR)/FNA clean
.PHONY: clean-FNA
clean: clean-FNA

$(SRCDIR)/FNA.NetStub/bin/Strongname/FNA.NetStub.dll: $(BUILDDIR)/mono-unix/.installed $(SRCDIR)/FNA/bin/Release/FNA.dll $(FNA_SRCS)
	+$(MONO_ENV) $(MAKE) -C $(SRCDIR)/FNA.NetStub
IMAGEDIR_BUILD_TARGETS += $(SRCDIR)/FNA.NetStub/bin/Strongname/FNA.NetStub.dll

FNA.NetStub.dll: $(SRCDIR)/FNA.NetStub/bin/Strongname/FNA.NetStub.dll
	$(MONO_ENV) gacutil -i $(SRCDIR)/FNA.NetStub/bin/Strongname/FNA.NetStub.dll -root $(IMAGEDIR)/lib
.PHONY: FNA.NetStub.dll
imagedir-targets: FNA.NetStub.dll

clean-FNA.NetStub:
	+$(MAKE) -C $(SRCDIR)/FNA.NetStub clean
.PHONY: clean-FNA.NetStub
clean: clean-FNA.NetStub

$(SRCDIR)/FNA/abi/.built: $(SRCDIR)/FNA/bin/Release/FNA.dll $(SRCDIR)/FNA.NetStub/bin/Strongname/FNA.NetStub.dll
	+$(MONO_ENV) $(MAKE) -C $(SRCDIR)/FNA/abi
	touch $@
IMAGEDIR_BUILD_TARGETS += $(SRCDIR)/FNA/abi/.built

Microsoft.Xna.Framework.dll: $(SRCDIR)/FNA/abi/.built
	for i in $(SRCDIR)/FNA/abi/Microsoft.Xna.*.dll; do $(MONO_ENV) gacutil -i $$i -root $(IMAGEDIR)/lib; done
.PHONY: Microsoft.Xna.Framework.dll
imagedir-targets: Microsoft.Xna.Framework.dll

clean-FNA-abi:
	+$(MAKE) -C $(SRCDIR)/FNA/abi clean
.PHONY: clean-FNA-abi
clean: clean-FNA-abi

