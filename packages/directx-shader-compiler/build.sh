TERMUX_PKG_HOMEPAGE=https://devblogs.microsoft.com/directx/landing-page/
TERMUX_PKG_DESCRIPTION="Compiler for HLSL to DXIL (DirectX Intermediate Language)"
TERMUX_PKG_LICENSE="Apache-2.0, NCSA"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.2607
TERMUX_PKG_SRCURL="https://github.com/microsoft/DirectXShaderCompiler/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=4ed223c7b4c61effa86aeb550e91f51451f479c5bd8820926fed9af452b3dbd5

TERMUX_PKG_BUILD_DEPENDS="spirv-tools, directx-headers"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DSPIRV-Headers_SOURCE_DIR=${TERMUX__PREFIX}
-DDIRECTX_HEADER_INCLUDE_DIR=${TERMUX__PREFIX__INCLUDE_DIR}
"

termux_step_post_configure() {
	false
}