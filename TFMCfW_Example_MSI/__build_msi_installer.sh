#!/bin/sh



mkdir -p build2
cd build2

cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release ..

ninja Installer_TFMCfW
ninja test_UnRAR0

cd ..
