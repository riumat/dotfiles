#!/bin/sh

if command -v nvidia-smi &> /dev/null; then
    used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits)
    total=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits)
    percent=$((used * 100 / total))
    echo "${percent}%"
else
    echo "N/A"
fi