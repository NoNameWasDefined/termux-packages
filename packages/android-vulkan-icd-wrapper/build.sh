TERMUX_PKG_HOMEPAGE=https://github.com/Pipetto-crypto/mesa
TERMUX_PKG_DESCRIPTION="Android's Vulkan driver as a Vulkan ICD (AdrenoTools included)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="docs/license.rst"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.1"
TERMUX_PKG_SRCURL=(
	"https://github.com/Pipetto-crypto/mesa/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
	https://github.com/Pipetto-crypto/libadrenotools/archive/refs/heads/master.tar.gz
	https://github.com/Pipetto-crypto/liblinkernsbypass/archive/refs/heads/master.tar.gz
)
TERMUX_PKG_SHA256=(
	8ebb38a36a8b9755105b66a9cf40bc2a7c517cd77e74afef8583f74ba5ee4a02
	76aea1d680b74f4dd4031a8a540018f9502971b455a9e62e57c316b654e74ccf
	06a4a9cee0b6fbbf09e9d5bc160736f34e0a34f784fcf502d2290fa9cff8e994
)
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libdrm, libx11, libxcb, libxshmfence, libwayland, vulkan-loader-generic, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="libandroid-shmem-static, libwayland-protocols, libxrandr, xorgproto"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686, x86_64"

TERMUX_PKG_API_LEVEL=28

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cmake-prefix-path ${TERMUX_PREFIX}
-Dgbm=disabled
-Dopengl=false
-Dllvm=disabled
-Dshared-llvm=disabled
-Dplatforms=x11
-Dgallium-drivers=
-Dxmlconfig=disabled
-Dvulkan-drivers=wrapper
-Dcpp_rtti=false
"

termux_step_post_get_source() {
	mv -T libadrenotools-master subprojects/libadrenotools
	# Git submodules are not included in Git archives
	mv -T liblinkernsbypass-master subprojects/libadrenotools/lib/linkernsbypass
}

termux_step_pre_configure() {
	termux_setup_cmake

	# error: 'AHardwareBuffer_release' is unavailable: introduced in Android 26 android
	if [[ "${TERMUX_ON_DEVICE_BUILD}" = true ]]; then
		if [ "${TERMUX_ARCH}" = arm ]; then
			CFLAGS+=" --target=armv7a-linux-androideabi${TERMUX_PKG_API_LEVEL}"
		fi
		CFLAGS+=" --target=${TERMUX_HOST_PLATFORM}${TERMUX_PKG_API_LEVEL}"
	fi

	LDFLAGS+=" -landroid-shmem"
}
