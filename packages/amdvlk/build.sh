# shellcheck disable=SC2034,SC2164
TERMUX_PKG_HOMEPAGE=https://github.com/GPUOpen-Drivers/AMDVLK
TERMUX_PKG_DESCRIPTION="AMD Open Source Driver for Vulkan"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2025.Q2.1"
# from the AMDVLK `repo` manifest `./default.xml`
TERMUX_PKG_SRCURL_COMMIT_SHA=(
	e9782eb33ce5e5e4ed2e339542a28c1b933624b4
	c5e800072a32f68b6ccc4422936d96167c6e0728
	40cb8d95ad8d6f7f1652e3fd47d39667594cce08
	7b226d48b46b7e92fec3b9ecc5712e5bf2bf3dd9
	8fd93e26cf9b1235fc9573b68b96233818be0ed4
	6ab6ee5d31d001ba73feb5e7f13dbc75da96b620
	73d612971b3a73341f241b021e5cbda220eef7f2
)
TERMUX_PKG_SRCURL=(
	"https://github.com/GPUOpen-Drivers/xgl/archive/${TERMUX_PKG_SRCURL_COMMIT_SHA[0]}.tar.gz"
	# "https://github.com/GPUOpen-Drivers/gpurt/archive/${TERMUX_PKG_SRCURL_COMMIT_SHA[3]}.tar.gz"
	"https://github.com/GPUOpen-Drivers/MetroHash/archive/${TERMUX_PKG_SRCURL_COMMIT_SHA[5]}.tar.gz"
	"https://github.com/GPUOpen-Drivers/CWPack/archive/${TERMUX_PKG_SRCURL_COMMIT_SHA[6]}.tar.gz"
	"https://github.com/GPUOpen-Drivers/pal/archive/${TERMUX_PKG_SRCURL_COMMIT_SHA[1]}.tar.gz"
	"https://github.com/GPUOpen-Drivers/llpc/archive/${TERMUX_PKG_SRCURL_COMMIT_SHA[2]}.tar.gz"
	"https://github.com/GPUOpen-Drivers/llvm-project/archive/${TERMUX_PKG_SRCURL_COMMIT_SHA[4]}.tar.gz"
)
TERMUX_PKG_SHA256=(
	f0248a721f97bb944163f67fa112d66a166a196e1d460a8d6690556a03a3b583
	# 03c897e7925286a9f473c11ef0319da19440721412a8e9a75784ca136c00d125
	bf27a8c55c4ed66ef61f26b2c284cbb77b9d572aabf67ea761d66c65f6c43e6a
	a9e7e5c3ed57d8180f44f029a0cf2da1c2cad356ad16d949b60e94365e96888b
	42072c7c5981ea5639d12dcc1828d145a0c2c23bc2e4785303d4e94182e005de
	6c1152d085bdf6dcf972d06fc6d0e40a3ad53da5f5e5cbca50681aed7ce60342
	9924e50b82127ac6b16fd2e0b0c9797b72899000d5ce7b1f4acbc5508520a35a
)
TERMUX_PKG_AUTO_UPDATE=false

TERMUX_PKG_DEPENDS="libxrandr, libxshmfence"
# TERMUX_PKG_BUILD_DEPENDS="directx-shader-compiler"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="Jinja2, ruamel.yaml"

TERMUX_PKG_CMAKE_BUILD="Ninja"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Wno-author
-DPROJECT_NAME=${TERMUX_PKG_NAME}
-DXGL_METROHASH_PATH=${TERMUX_PKG_SRCDIR}/MetroHash
-DXGL_CWPACK_PATH=${TERMUX_PKG_SRCDIR}/CWPack
-DXGL_PAL_PATH=${TERMUX_PKG_SRCDIR}/pal
-DXGL_LLVM_SRC_PATH=${TERMUX_PKG_SRCDIR}/llvm-project/llvm
-DVKI_RAY_TRACING=OFF
-DVKI_BUILD_DRI3=OFF
-DVKI_BUILD_WAYLAND=OFF
"

termux_step_post_get_source() {
	mv "MetroHash-${TERMUX_PKG_SRCURL_COMMIT_SHA[5]}" MetroHash
	mv "CWPack-${TERMUX_PKG_SRCURL_COMMIT_SHA[6]}" CWPack
	mv "pal-${TERMUX_PKG_SRCURL_COMMIT_SHA[1]}" pal
	mv "llpc-${TERMUX_PKG_SRCURL_COMMIT_SHA[2]}" icd/api/compiler
	mv "llvm-project-${TERMUX_PKG_SRCURL_COMMIT_SHA[4]}" llvm-project
}

termux_step_pre_configure() {
	# goofy ahh workaround for on-device builds
	if [[ ${TERMUX_ON_DEVICE_BUILD} = true ]]; then
		if [[ ${TERMUX_ARCH} != aarch64 ]]; then
			termux_error_exit "Work is needed to build on device for other archs than aarch64"
		fi
		(
			cd "${TERMUX_PKG_CACHEDIR}"
			termux_download \
				http://mirror.archlinuxarm.org/aarch64/core/glibc-2.43+r22+g8362e8ce10b2-2-aarch64.pkg.tar.xz \
				glibc.pkg.tar.xz \
				8fac217e98c6e4342326726b2640ac254e8c82032f06f30bfa13ebbcc4fcb25b
			termux_download \
				http://mirror.archlinuxarm.org/aarch64/core/libgcc-16.1.1+r12+g301eb08fa2c5-1-aarch64.pkg.tar.xz \
				libgcc.pkg.tar.xz \
				0f98bdf94a6e2f6758b9ffe98cbc9391a109326ed23bd264cabe0a81a04d7ae4
			termux_download \
				http://mirror.archlinuxarm.org/aarch64/core/libstdc++-16.1.1+r12+g301eb08fa2c5-1-aarch64.pkg.tar.xz \
				libstdc++.pkg.tar.xz \
				19832a38b2c4820695d28289f1c4f371955586d39fb893d8cbc0d8dbb09a4383
			termux_download \
				http://mirror.archlinuxarm.org/aarch64/extra/directx-shader-compiler-1.10.2605.24-1-aarch64.pkg.tar.xz \
				directx-shader-compiler.pkg.tar.xz \
				16e2160d190c9893df53662fe7f85f795df60c1f92e080b95ef562186afa90b2
			mkdir rootfs bin
			for file in {glibc,libgcc,libstdc++,directx-shader-compiler}.pkg.tar.xz; do
				tar -xf "$file" -C "${TERMUX_PKG_CACHEDIR}/rootfs"
			done
			cat >bin/run-glibc <<-EOF
			#!${TERMUX__PREFIX__BIN_DIR}/sh
			env -u LD_PRELOAD proot -b /lib:"${TERMUX_PKG_CACHEDIR}/rootfs/usr/lib" -b /usr:"${TERMUX_PKG_CACHEDIR}/rootfs/usr" /lib/ld-linux-aarch64.so.1 "$@"
			EOF
		)
	fi
}

# inspired by ./packages/aosp-libs/build.sh
_termux_step_post_get_source() {
	local repo=$TERMUX_PKG_CACHEDIR/repo
	[ -f "$repo" ] || termux_download https://storage.googleapis.com/git-repo-downloads/repo "$repo" SKIP_CHECKSUM
	[ -x "$repo" ] || chmod a+rx "$repo"

	if [[ ! -f $TMP_CHECKOUT_VERSION || $TERMUX_PKG_VERSION != "$(<"$TMP_CHECKOUT_VERSION")" ]]; then
		echo "Downloading git-repo source with branch $TERMUX_PKG_GIT_BRANCH from $termux_pkg_srcurl"

		git config get user.name >/dev/null || git config set --global user.name "Termux Github Actions"
		git config get user.email >/dev/null || git config set --global user.email "contact@termux.dev"

		mkdir -p "$TMP_CHECKOUT"
		pushd "$TMP_CHECKOUT"

		$repo init \
			-u "$termux_pkg_srcurl" \
			-b "$TERMUX_PKG_GIT_BRANCH"
		$repo sync -c

		popd

		echo "$TERMUX_PKG_VERSION" >"$TMP_CHECKOUT_VERSION"
	else
		echo "Skipped downloading of git-repo source from '$termux_pkg_srcurl'"
	fi

	rm -rf "$TERMUX_PKG_SRCDIR"
	cp -Rf "$TMP_CHECKOUT" "$TERMUX_PKG_SRCDIR"
}
