#!/bin/bash
echo "welcome to pefs, peysh's enhanced figlet script"
sleep 1
INPUT="$1"
FONT_DIR=$(figlet -I2)

for font in "$FONT_DIR"/*.flf; do
    echo "=== $(basename "$font" .flf) ==="
    figlet -f "$font" "$INPUT"
done
