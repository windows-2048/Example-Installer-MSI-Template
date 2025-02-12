#!/bin/sh



mkdir -p build2
cd build2

cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release ..

ninja Installer_{{ CNM }}
ninja test_{{ CUSTOM_DLL_NAME }}

cd ..
