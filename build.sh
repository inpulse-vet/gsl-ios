#!/bin/bash
cp build-ios.sh gsl/build-ios.sh
cp build-frameworks.sh gsl/build-frameworks.sh
cp build-pod.sh gsl/build-pod.sh
cd gsl
#./build-ios.sh
./build-frameworks.sh
./build-pod.sh
