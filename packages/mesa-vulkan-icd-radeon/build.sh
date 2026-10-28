TERMUX_PKG_HOMEPAGE=https://github.com/JimVulkan/radv-xclipse
TERMUX_PKG_DESCRIPTION="Mesa's Radeon Vulkan ICD modified to run with Samsung's Xclipse GPUs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="27.0.0"
TERMUX_PKG_SRCURL="https://github.com/JimVulkan/radv-xclipse/archive/d29b3afcecc542119bd548308a34e8dead6f5655.tar.gz"
TERMUX_PKG_SHA256=a8f1a45fc2c5ec95ad408cd3425f4547fb60698107ee1a425a0a003a2951b461
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libwayland, libx11, libxext, libxfixes, libxshmfence, libxxf86vm, vulkan-loader, zlib"
TERMUX_PKG_BUILD_DEPENDS="libwayland-cross-scanner, libwayland-protocols, libxrandr, mlir, spirv-tools, xorgproto"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686, x86_64"

# FIXME: Set `shared-llvm` to disabled if possible
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cmake-prefix-path ${TERMUX_PREFIX}
-Dgbm=disabled
-Dopengl=false
-Degl=disabled
-Dgles1=disabled
-Dgles2=disabled
-Dglx=disabled
-Dllvm=disabled
-Dplatforms=x11,wayland
-Dgallium-drivers=
-Dxmlconfig=enabled
-Dvulkan-drivers=amd
-Dvulkan-layers=
-Dtools=
-Dzstd=disabled
-Dlmsensors=disabled
-Dperfetto=false
-Dvalgrind=disabled
-Dlibunwind=disabled
-Dallow-fallback-for=libdrm
--force-fallback-for=libdrm
-Dlibdrm:default_library=static
"

termux_step_pre_configure() {
	termux_setup_cmake

	CFLAGS+=""
	CPPFLAGS+=" -D__USE_GNU -DPROP_VALUE_MAX=92"
	LDFLAGS+=" -landroid-shmem -llog"

	_WRAPPER_BIN=$TERMUX_PKG_BUILDDIR/_wrapper/bin
	mkdir -p "$_WRAPPER_BIN"
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		sed 's|@CMAKE@|'"$(command -v cmake)"'|g' \
			"$TERMUX_PKG_BUILDER_DIR/cmake-wrapper.in" \
			> "$_WRAPPER_BIN/cmake"
		chmod 0700 "$_WRAPPER_BIN/cmake"
		termux_setup_wayland_cross_pkg_config_wrapper
	fi
	PATH="${_WRAPPER_BIN}:${PATH}"
}

termux_step_post_configure() {
	rm -f "$_WRAPPER_BIN/cmake"
}

termux_step_make_install () {
	# Much of the stuff compiled is useless and would collide with other packages
	# so it's better to install manually
	install -Dm644 "${TERMUX_PKG_BUILDDIR}/src/amd/vulkan/libvulkan_radeon.so" "${TERMUX__PREFIX__LIB_DIR}/libvulkan_radeon.so"
	install -Dm644 "${TERMUX_PKG_BUILDDIR}/src/amd/vulkan/radeon_icd.${TERMUX_ARCH}.json" "${TERMUX__PREFIX__SHARE_DIR}/vulkan/icd.d/radeon_icd.json"
}
