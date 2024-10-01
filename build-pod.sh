#! /bin/bash
set -e

ScriptDir="$( cd "$( dirname "$0" )" && pwd )"
PREFIX="${ScriptDir}"/_build
PLATFORMS="${PREFIX}"/platforms
UNIVERSAL="${PREFIX}"/universal
POD="${PREFIX}"/pod
FRAMEWORK="${PREFIX}"/framework

rm -r ${POD} || true
mkdir -p ${POD}/Headers
cp -r ${PREFIX}/include/gsl ${POD}/Headers
cp ../LICENSE ${POD}
cp -r ${UNIVERSAL}/gsl.xcframework ${POD}
cp -r ${UNIVERSAL}/gslcblas.xcframework ${POD}

cd ${POD}
zip -r pod-libgsl.zip ./*
