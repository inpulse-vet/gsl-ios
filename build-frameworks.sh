#! /bin/bash
set -e

MakeFramework() {
    rm -r ${FRAMEWORK}/${PLATFORM}/${LIB}.framework || true
    mkdir -p ${FRAMEWORK}/${PLATFORM}/${LIB}.framework
    FRAMEWORK_PATH=${FRAMEWORK}/${PLATFORM}/${LIB}.framework
    mkdir -p ${FRAMEWORK_PATH}/Headers
    cp -r ${PREFIX}/${LIB}include/gsl ${FRAMEWORK_PATH}/Headers
    cp ${PLATFORMS}/${PLATFORM}/lib/lib${LIB}.a ${FRAMEWORK_PATH}/${LIB}
    cp ../${LIB}.Info.plist ${FRAMEWORK_PATH}/Info.plist
}

ScriptDir="$( cd "$( dirname "$0" )" && pwd )"
PREFIX="${ScriptDir}"/_build
PLATFORMS="${PREFIX}"/platforms
UNIVERSAL="${PREFIX}"/universal
POD="${PREFIX}"/pod
FRAMEWORK="${PREFIX}"/framework

# # Create universal binary
rm "${PREFIX}/include/gsl/test_source.c" || true
rm -r "${UNIVERSAL}/gsl.xcframework" || true
rm -r "${UNIVERSAL}/gslcblas.xcframework" || true

CBLAS_HEADERS="${PREFIX}/gslcblasinclude"
mkdir -p "${CBLAS_HEADERS}/gsl"
GSL_HEADERS="${PREFIX}/gslinclude"
mkdir -p "${GSL_HEADERS}/gsl"
cp "${PREFIX}/include/gsl/gsl_cblas.h" "${CBLAS_HEADERS}/gsl" || true
cp -r "${PREFIX}/include/gsl" ${GSL_HEADERS}
rm ${GSL_HEADERS}/gsl/gsl_cblas.h || true


PLATFORM=macos-x86_64-arm64
LIB=gslcblas
MakeFramework

PLATFORM=ios-arm64
LIB=gslcblas
MakeFramework

PLATFORM=ios-arm64-simulator
LIB=gslcblas
MakeFramework

PLATFORM=macos-x86_64-arm64
LIB=gsl
MakeFramework

PLATFORM=ios-arm64
LIB=gsl
MakeFramework

PLATFORM=ios-arm64-simulator
LIB=gsl
MakeFramework
