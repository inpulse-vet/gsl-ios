#! /bin/bash

#
# Build for iOS 64bit-ARM variants and iOS Simulator
# - Place the script at project root
# - Customize MIN_IOS_VERSION and other flags as needed
# 
# Test Environment
# - macOS 10.14.6
# - iOS 13.1
# - Xcode 11.1
#

set -e

Build() {
    # Ensure -fembed-bitcode builds, as workaround for libtool macOS bug
    export MACOSX_DEPLOYMENT_TARGET="10.4"
    # Get the correct toolchain for target platforms
    export CC=$(xcrun --find --sdk "${SDK}" clang)
    export CXX=$(xcrun --find --sdk "${SDK}" clang++)
    export CPP=$(xcrun --find --sdk "${SDK}" cpp)
    export CFLAGS="-std=gnu11 ${HOST_FLAGS} ${OPT_FLAGS}"
    export CXXFLAGS="${HOST_FLAGS} ${OPT_FLAGS}"
    export LDFLAGS="${HOST_FLAGS}"

    echo $(pwd);

    make maintainer-clean || true

    EXEC_PREFIX="${PLATFORMS}/${PLATFORM}"
    ./configure \
        --host="${CHOST}" \
        --prefix="${PREFIX}" \
        --exec-prefix="${EXEC_PREFIX}" \
        --enable-static \
        --disable-shared  # Avoid Xcode loading dylibs even when staticlibs exist

    mkdir -p "${PLATFORMS}" &> /dev/null
    make V=1 -j"${MAKE_JOBS}"
    make install
}

echo "Check for makefile"

if [ ! -f ./Makefile ]; then
    echo "Run autogen"
    ./autogen.sh
fi

# Locations
ScriptDir="$( cd "$( dirname "$0" )" && pwd )"
PREFIX="${ScriptDir}"/_build
PLATFORMS="${PREFIX}"/platforms
UNIVERSAL="${PREFIX}"/universal

# Compiler options
OPT_FLAGS="-O3 -g3 -fembed-bitcode"
MAKE_JOBS=8
MIN_IOS_VERSION=8.0
MIN_MACOS_VERSION=10.14

# Build for platforms

SDK="macosx"
PLATFORM="macos-x86_64-arm64"
PLATFORM_ARM=${PLATFORM}
ARCH_FLAGS="-arch x86_64 -arch arm64"
HOST_FLAGS="${ARCH_FLAGS} -mmacosx-version-min=${MIN_MACOS_VERSION} -isysroot $(xcrun --sdk ${SDK} --show-sdk-path)"
CHOST="arm64-apple-darwin"
Build

SDK="iphoneos"
PLATFORM="ios-arm64"
PLATFORM_ARM=${PLATFORM}
ARCH_FLAGS="-arch arm64"
HOST_FLAGS="${ARCH_FLAGS} -mios-version-min=${MIN_IOS_VERSION} -isysroot $(xcrun --sdk ${SDK} --show-sdk-path)"
CHOST="arm64-apple-darwin"
Build

SDK="iphonesimulator"
PLATFORM="ios-arm64-simulator"
PLATFORM_ISIM=${PLATFORM}
ARCH_FLAGS="-arch arm64"
HOST_FLAGS="${ARCH_FLAGS} -miphonesimulator-version-min=${MIN_IOS_VERSION} -isysroot $(xcrun --sdk ${SDK} --show-sdk-path)"
CHOST="arm64-apple-darwin"
Build

# Create universal binary
rm "${PREFIX}/include/gsl/test_source.c" || true
rm -r "${UNIVERSAL}/libgsl.xcframework" || true
rm -r "${UNIVERSAL}/libgslcblas.xcframework" || true

CBLAS_HEADERS="${PREFIX}/cblasinclude"
mkdir -p "${CBLAS_HEADERS}/gsl"git@github.com:inpulse-vet/gsl-ios.git
mv "${PREFIX}/include/gsl/gsl_cblas.h" "${CBLAS_HEADERS}/gsl" || true

xcodebuild -create-xcframework \
    -library ${PLATFORMS}/ios-arm64/lib/libgslcblas.a -headers ${CBLAS_HEADERS} \
    -library ${PLATFORMS}/ios-arm64-simulator/lib/libgslcblas.a  -headers ${CBLAS_HEADERS} \
    -library ${PLATFORMS}/macos-x86_64-arm64/lib/libgslcblas.a  -headers ${CBLAS_HEADERS} \
    -output ${UNIVERSAL}/libgslcblas.xcframework;

GSL_HEADERS="${PREFIX}/include"
xcodebuild -create-xcframework \
    -library ${PLATFORMS}/ios-arm64/lib/libgsl.a -headers ${GSL_HEADERS} \
    -library ${PLATFORMS}/ios-arm64-simulator/lib/libgsl.a  -headers ${GSL_HEADERS} \
    -library ${PLATFORMS}/macos-x86_64-arm64/lib/libgsl.a  -headers ${GSL_HEADERS} \
    -output ${UNIVERSAL}/libgsl.xcframework;
