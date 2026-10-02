TERMUX_SUBPKG_DESCRIPTION="Mesa's Radeon Vulkan ICD"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="libandroid-shmem, libc++, libdrm, libx11, libxcb, libxshmfence, libwayland, vulkan-loader-generic, zlib, zstd"
TERMUX_SUBPKG_EXCLUDED_ARCHES="arm"
TERMUX_SUBPKG_INCLUDE="
lib/libvulkan_radeon.so
share/vulkan/icd.d/radeon_icd.*.json
"
