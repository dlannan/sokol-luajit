#!/bin/bash
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
echo "Running Linux..."
export LD_LIBRARY_PATH=../bin/linux
../bin/linux/luajit ./samples/$1.lua
elif [[ "$OSTYPE" == "darwin"* ]]; then
echo "Running MaxOS..."
export DYLD_LIBRARY_PATH=../bin/macos
../bin/macos/luajit ./samples/$1.lua
elif [[ "$OSTYPE" == "win32" ]]; then
echo "Running Windows..."
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../bin/linux
../bin/win64/luajit ./samples/$1.lua
else
echo "OS Type not found."
fi


