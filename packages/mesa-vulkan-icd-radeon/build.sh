TERMUX_PKG_HOMEPAGE=https://github.com/JimVulkan/radv-xclipse
TERMUX_PKG_DESCRIPTION="Mesa's Radeon Vulkan ICD modified to run with Samsung's Xclipse GPUs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.9.0"
TERMUX_PKG_SRCURL="https://github.com/JimVulkan/radv-xclipse/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d2fe7a69ae076b2c305e5932afaeb640e32bb4e84d437bc46f84d12e5812f5a1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libwayland, libx11, libxext, libxfixes, libxshmfence, libxxf86vm, vulkan-loader, zlib"
TERMUX_PKG_BUILD_DEPENDS="libwayland-cross-scanner, libwayland-protocols, libxrandr, mlir, spirv-tools, xorgproto"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686, x86_64"

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
