TERMUX_PKG_HOMEPAGE=https://github.com/sylirre/fake-chroot-ng
TERMUX_PKG_DESCRIPTION='ptrace-free chroot/bind emulation for rootless Android (AArch64)'
TERMUX_PKG_LICENSE=Apache-2.0
TERMUX_PKG_MAINTAINER=@termux
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_SRCURL=https://github.com/sylirre/fake-chroot-ng/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=247b8876402e68a807a9499a021f7933a7b48a54b52b0b982ada71d981b91253
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES='arm, i686, x86_64'  # only AArch64 is supported

termux_step_make_install() {
	install -Dm700 "${TERMUX_PKG_SRCDIR}"/build/chroot-ng "${TERMUX__PREFIX__BIN_DIR}"/chroot-ng
}
