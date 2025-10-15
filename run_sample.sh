#!/bin/bash

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
PROJECT_PATH="$(dirname $(dirname "$SCRIPT_PATH"))"

if [[ "$OS" == "Linux"* ]]; then
echo "Running Linux..."
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$PROJECT_PATH/bin/linux"
./bin/linux/luajit $SCRIPT_PATH/projects/examples/samples/$1.lua
elif [[ "$OS" == "Darwin"* ]]; then
echo "Running MacOS..."
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$PROJECT_PATH/bin/macos"
export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:$PROJECT_PATH/bin/macos"
./bin/macos/luajit $SCRIPT_PATH/projects/examples/samples/$1.lua
elif [[ "$OS" == "Windows_NT" ]]; then
echo "Running Windows..."
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PROJECT_PATH/bin/linux
./bin/win64/luajit.exe $SCRIPT_PATH/projects/examples/samples/$1.lua
else
echo "OS Type not found."
fi


