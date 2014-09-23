#!/bin/bash

lua-distill -V >/dev/null 2>&1 || { echo "Run 'npm install lua-distiller -g' to install lua-distiller cli first. Aborting." >&2; exit 1; }
lua-distill -i src/app.lua -o build/app.lua -x "AudioEngine, inspect" -j -m
