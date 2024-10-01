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

rm -r ${UNIVERSAL} || true
mkdir -p ${UNIVERSAL}


xcodebuild -create-xcframework \
    -framework ${FRAMEWORK}/ios-arm64/gslcblas.framework \
    -framework ${FRAMEWORK}/ios-arm64-simulator/gslcblas.framework \
    -framework ${FRAMEWORK}/macos-x86_64-arm64/gslcblas.framework \
    -output ${UNIVERSAL}/gslcblas.xcframework;

xcodebuild -create-xcframework \
    -framework ${FRAMEWORK}/ios-arm64/gsl.framework \
    -framework ${FRAMEWORK}/ios-arm64-simulator/gsl.framework \
    -framework ${FRAMEWORK}/macos-x86_64-arm64/gsl.framework \
    -output ${UNIVERSAL}/gsl.xcframework;

rm -r ${POD} || true
mkdir -p ${POD}/Headers
cp -r ${PREFIX}/include/gsl ${POD}/Headers
cp ../LICENSE ${POD}
cp -r ${UNIVERSAL}/gsl.xcframework ${POD}
cp -r ${UNIVERSAL}/gslcblas.xcframework ${POD}

cd ${POD}
zip -r pod-libgsl.zip ./*
