TERMUX_PKG_HOMEPAGE=https://github.com/sylirre/fake-chroot-ng
TERMUX_PKG_DESCRIPTION='ptrace-free chroot/bind emulation for rootless Android (AArch64)'
TERMUX_PKG_LICENSE=Apache-2.0
TERMUX_PKG_MAINTAINER=@termux
TERMUX_PKG_VERSION=0.0.1
TERMUX_PKG_SRCURL=https://github.com/sylirre/fake-chroot-ng/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dda7bbcdb1e79f223f4788456c6f34daa4723cb2a926cdb425efb96d12c118a0
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES='arm, i686, x86_64'  # only AArch64 is supported

termux_step_make_install() {
	install -Dm700 "${TERMUX_PKG_SRCDIR}"/build/chroot-ng "${TERMUX__PREFIX__BIN_DIR}"/chroot-ng
}
