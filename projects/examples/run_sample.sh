#!/bin/bash

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
PROJECT_PATH="$(dirname $(dirname "$SCRIPT_PATH"))"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
echo "Running Linux..."
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$PROJECT_PATH/bin/linux"
$PROJECT_PATH/bin/linux/luajit $SCRIPT_PATH/samples/$1.lua
elif [[ "$OSTYPE" == "darwin"* ]]; then
echo "Running MacOS..."
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$PROJECT_PATH/bin/macos"
export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:$PROJECT_PATH/bin/macos"
$PROJECT_PATH/bin/macos/luajit $SCRIPT_PATH/samples/$1.lua
elif [[ "$OSTYPE" == "win32" ]]; then
echo "Running Windows..."
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PROJECT_PATH/bin/linux
$PROJECT_PATH/bin/win64/luajit $SCRIPT_PATH/samples/$1.lua
else
echo "OS Type not found."
fi


