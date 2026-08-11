TERMUX_PKG_HOMEPAGE=https://github.com/sylirre/fake-chroot-ng
TERMUX_PKG_DESCRIPTION='ptrace-free chroot/bind emulation for rootless Android (AArch64)'
TERMUX_PKG_LICENSE=Apache-2.0
TERMUX_PKG_MAINTAINER=@termux
TERMUX_PKG_VERSION=1.6.0
TERMUX_PKG_SRCURL=https://github.com/sylirre/fake-chroot-ng/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b84f2718dffabd1ad944ecfa1091edc18589297744a60b6698206bf0a760e08a
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES='arm, i686, x86_64'  # only AArch64 is supported

termux_step_make_install() {
	install -Dm700 "${TERMUX_PKG_SRCDIR}"/build/chroot-ng "${TERMUX__PREFIX__BIN_DIR}"/chroot-ng
}
