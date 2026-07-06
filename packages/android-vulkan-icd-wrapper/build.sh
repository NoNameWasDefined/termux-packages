TERMUX_PKG_HOMEPAGE=https://github.com/Pipetto-crypto/mesa
TERMUX_PKG_DESCRIPTION="Android's Vulkan driver as a Vulkan ICD (AdrenoTools included)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="docs/license.rst"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.0.0"
# set package revision to 1 then increment it next time after changing the commits
# pinning libadrenotools is needed since this project is not stable
_COMMITS_SHA=(
	7eae6442f5d8a7414e66adc0d42857c143f20fa9
	8483dfdaa2abf97ee89ad0e5f337e7b508550c6b
	b10d48548d608dfca38ffc449d0350335b2f3737
)
TERMUX_PKG_SRCURL=(
	"https://github.com/Pipetto-crypto/mesa/archive/${_COMMITS_SHA[0]}.tar.gz"
	"https://github.com/Pipetto-crypto/libadrenotools/archive/${_COMMITS_SHA[1]}.tar.gz"
	"https://github.com/Pipetto-crypto/liblinkernsbypass/archive/${_COMMITS_SHA[2]}.tar.gz"
)
TERMUX_PKG_SHA256=(
	0da3999306d430b49f0a538adfd7946339b00cc81e979c251009c617992c0747
	d6060f3dc8b0d67259784162add0d9f281a9bfc87e7c49324eea6e3fb1e00f6a
	b130c51f26a5f697e0ab32564cf3a8f18b65985cacb2d0ca17d6a94faea05053
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
	mv -T "libadrenotools-${_COMMITS_SHA[1]}" subprojects/libadrenotools
	# Git submodules are not included in Git archives
	mv -T "liblinkernsbypass-${_COMMITS_SHA[2]}" subprojects/libadrenotools/lib/linkernsbypass
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
