MONODX_SRCS=$(shell $(SRCDIR)/tools/git-updated-files $(SRCDIR)/monoDX)

define MINGW_TEMPLATE +=
# monodx
$$(BUILDDIR)/monodx-$(1)/.built: $$(MONODX_SRCS) $$(MINGW_DEPS)
	mkdir -p $$(@D)
	+$$(MINGW_ENV) $(MAKE) -C $$(@D) -f $$(SRCDIR_ABS)/monoDX/monodx/Makefile ARCH=$(1) SRCDIR="$$(SRCDIR_ABS)/monoDX/monodx" "MINGW=$$(MINGW_$(1))"
	touch "$$@"
ifeq (1,$(ENABLE_MONODX))
IMAGEDIR_BUILD_TARGETS += $$(BUILDDIR)/monodx-$(1)/.built
endif

monodx-$(1).dll: $$(BUILDDIR)/monodx-$(1)/.built
	mkdir -p "$$(IMAGEDIR)/lib/$(1)"
	$$(INSTALL_PE_$(1)) "$$(BUILDDIR)/monodx-$(1)/monodx.dll" "$$(IMAGEDIR)/lib/$(1)/monodx.dll"
.PHONY: monodx-$(1).dll

monodx.dll: monodx-$(1).dll
.PHONY: monodx.dll

ifeq (1,$(ENABLE_MONODX))
imagedir-targets: monodx-$(1).dll
endif

clean-build-monodx-$(1):
	rm -rf $$(BUILDDIR)/monodx-$(1)
.PHONY: clean-build-monodx-$(1)
clean-build: clean-build-monodx-$(1)
endef

# monodx
$(SRCDIR)/monoDX/Microsoft.DirectX/.built: $(BUILDDIR)/mono-unix/.installed $(MONODX_SRCS) $(BUILDDIR)/resx2srid.exe
	+$(MONO_ENV) $(MAKE) -C $(@D) MONO_PREFIX=$(BUILDDIR_ABS)/mono-unix-install RESX2SRID=$(BUILDDIR_ABS)/resx2srid.exe WINE_MONO_SRCDIR=$(SRCDIR_ABS)
	touch $@

$(SRCDIR)/monoDX/Microsoft.DirectX.Direct3D/.built: $(BUILDDIR)/mono-unix/.installed $(MONODX_SRCS) $(BUILDDIR)/resx2srid.exe $(SRCDIR)/monoDX/Microsoft.DirectX/.built
	+$(MONO_ENV) $(MAKE) -C $(@D) MONO_PREFIX=$(BUILDDIR_ABS)/mono-unix-install RESX2SRID=$(BUILDDIR_ABS)/resx2srid.exe WINE_MONO_SRCDIR=$(SRCDIR_ABS)
	touch $@

$(SRCDIR)/monoDX/Microsoft.DirectX.Direct3DX/.built: $(BUILDDIR)/mono-unix/.installed $(MONODX_SRCS) $(BUILDDIR)/resx2srid.exe $(SRCDIR)/monoDX/Microsoft.DirectX.Direct3D/.built
	+$(MONO_ENV) $(MAKE) -C $(@D) MONO_PREFIX=$(BUILDDIR_ABS)/mono-unix-install RESX2SRID=$(BUILDDIR_ABS)/resx2srid.exe WINE_MONO_SRCDIR=$(SRCDIR_ABS)
	touch $@

$(SRCDIR)/monoDX/Microsoft.DirectX.DirectInput/.built: $(BUILDDIR)/mono-unix/.installed $(MONODX_SRCS) $(BUILDDIR)/resx2srid.exe $(SRCDIR)/monoDX/Microsoft.DirectX/.built
	+$(MONO_ENV) $(MAKE) -C $(@D) MONO_PREFIX=$(BUILDDIR_ABS)/mono-unix-install RESX2SRID=$(BUILDDIR_ABS)/resx2srid.exe WINE_MONO_SRCDIR=$(SRCDIR_ABS)
	touch $@

$(SRCDIR)/monoDX/Microsoft.DirectX.DirectPlay/.built: $(BUILDDIR)/mono-unix/.installed $(MONODX_SRCS) $(BUILDDIR)/resx2srid.exe $(SRCDIR)/monoDX/Microsoft.DirectX/.built
	+$(MONO_ENV) $(MAKE) -C $(@D) MONO_PREFIX=$(BUILDDIR_ABS)/mono-unix-install RESX2SRID=$(BUILDDIR_ABS)/resx2srid.exe WINE_MONO_SRCDIR=$(SRCDIR_ABS)
	touch $@

$(SRCDIR)/monoDX/Microsoft.DirectX.DirectSound/.built: $(BUILDDIR)/mono-unix/.installed $(MONODX_SRCS) $(BUILDDIR)/resx2srid.exe $(SRCDIR)/monoDX/Microsoft.DirectX/.built
	+$(MONO_ENV) $(MAKE) -C $(@D) MONO_PREFIX=$(BUILDDIR_ABS)/mono-unix-install RESX2SRID=$(BUILDDIR_ABS)/resx2srid.exe WINE_MONO_SRCDIR=$(SRCDIR_ABS)
	touch $@

ifeq (1,$(ENABLE_MONODX))
IMAGEDIR_BUILD_TARGETS += $(SRCDIR)/wpf/src/Microsoft.DotNet.Wpf/src/System.Xaml/.built

IMAGEDIR_BUILD_TARGETS += $(SRCDIR)/monoDX/Microsoft.DirectX/.built
Microsoft.DirectX.dll: $(SRCDIR)/monoDX/Microsoft.DirectX/.built
	$(MONO_ENV) gacutil -i $(SRCDIR)/monoDX/Microsoft.DirectX/Microsoft.DirectX.dll -root $(IMAGEDIR)/lib
.PHONY: Microsoft.DirectX.dll
imagedir-targets: Microsoft.DirectX.dll

IMAGEDIR_BUILD_TARGETS += $(SRCDIR)/monoDX/Microsoft.DirectX.Direct3D/.built
Microsoft.DirectX.Direct3D.dll: $(SRCDIR)/monoDX/Microsoft.DirectX.Direct3D/.built
	$(MONO_ENV) gacutil -i $(SRCDIR)/monoDX/Microsoft.DirectX.Direct3D/Microsoft.DirectX.Direct3D.dll -root $(IMAGEDIR)/lib
.PHONY: Microsoft.DirectX.Direct3D.dll
imagedir-targets: Microsoft.DirectX.Direct3D.dll

IMAGEDIR_BUILD_TARGETS += $(SRCDIR)/monoDX/Microsoft.DirectX.Direct3DX/.built
Microsoft.DirectX.Direct3DX.dll: $(SRCDIR)/monoDX/Microsoft.DirectX.Direct3DX/.built
	$(MONO_ENV) gacutil -i $(SRCDIR)/monoDX/Microsoft.DirectX.Direct3DX/Microsoft.DirectX.Direct3DX.dll -root $(IMAGEDIR)/lib
.PHONY: Microsoft.DirectX.Direct3DX.dll
imagedir-targets: Microsoft.DirectX.Direct3DX.dll

IMAGEDIR_BUILD_TARGETS += $(SRCDIR)/monoDX/Microsoft.DirectX.DirectInput/.built
Microsoft.DirectX.DirectInput.dll: $(SRCDIR)/monoDX/Microsoft.DirectX.DirectInput/.built
	$(MONO_ENV) gacutil -i $(SRCDIR)/monoDX/Microsoft.DirectX.DirectInput/Microsoft.DirectX.DirectInput.dll -root $(IMAGEDIR)/lib
.PHONY: Microsoft.DirectX.DirectInput.dll
imagedir-targets: Microsoft.DirectX.DirectInput.dll

IMAGEDIR_BUILD_TARGETS += $(SRCDIR)/monoDX/Microsoft.DirectX.DirectPlay/.built
Microsoft.DirectX.DirectPlay.dll: $(SRCDIR)/monoDX/Microsoft.DirectX.DirectPlay/.built
	$(MONO_ENV) gacutil -i $(SRCDIR)/monoDX/Microsoft.DirectX.DirectPlay/Microsoft.DirectX.DirectPlay.dll -root $(IMAGEDIR)/lib
.PHONY: Microsoft.DirectX.DirectPlay.dll
imagedir-targets: Microsoft.DirectX.DirectPlay.dll

IMAGEDIR_BUILD_TARGETS += $(SRCDIR)/monoDX/Microsoft.DirectX.DirectSound/.built
Microsoft.DirectX.DirectSound.dll: $(SRCDIR)/monoDX/Microsoft.DirectX.DirectSound/.built
	$(MONO_ENV) gacutil -i $(SRCDIR)/monoDX/Microsoft.DirectX.DirectSound/Microsoft.DirectX.DirectSound.dll -root $(IMAGEDIR)/lib
.PHONY: Microsoft.DirectX.DirectSound.dll
imagedir-targets: Microsoft.DirectX.DirectSound.dll
endif
