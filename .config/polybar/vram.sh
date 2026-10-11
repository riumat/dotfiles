#!/bin/sh

if command -v nvidia-smi >/dev/null 2>&1; then
    used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits)
    total=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits)
else
    for dev in /sys/class/drm/card[0-9]*/device; do
        [ -r "$dev/mem_info_vram_total" ] || continue
        used=$(cat "$dev/mem_info_vram_used")
        total=$(cat "$dev/mem_info_vram_total")
        break
    done
fi

if [ -n "$total" ] && [ "$total" -gt 0 ]; then
    echo "$((used * 100 / total))%"
else
    echo "N/A"
fi
