#!/usr/bin/env bash
# pefui.sh - peysh's enhanced figlet user interface (PEFUI)
# Fully portable, desktop-ready Figlet GUI using yad

# --- Check dependencies ---
if ! command -v figlet &> /dev/null; then
    yad --error --title="pefui error" --text="figlet is not installed.\nPlease install figlet to use pefui."
    exit 1
fi

if ! command -v yad &> /dev/null; then
    echo "pefui requires yad. Please install yad to run this script."
    exit 1
fi

# --- Get input text ---
INPUT="${1:-}"
if [ -z "$INPUT" ]; then
    INPUT=$(yad --entry \
                --title="pefui" \
                --text="Welcome to pefui\n(Peysh's enhanced figlet user interface)\n=~=~=\nEnter text to display:" \
                --width=400)
fi
[ -z "$INPUT" ] && exit

# --- Determine fonts directory ---
FONT_DIR=$(figlet -I2)
if [ ! -d "$FONT_DIR" ]; then
    FONT_DIR="/usr/share/figlet"  # fallback
fi

# --- Generate Figlet output ---
OUTPUT=""
for font in "$FONT_DIR"/*.flf; do
    FONT_NAME=$(basename "$font" .flf)
    FIG=$(figlet -f "$font" "$INPUT" 2>/dev/null)
    OUTPUT+="=== $FONT_NAME ===\n$FIG\n\n"
done

# --- Display in scrollable window ---
echo -e "$OUTPUT" | yad --text-info \
                         --title="pefui - Figlet Output" \
                         --width=800 \
                         --height=600 \
                         --fontname="Monospace 10" \
                         --wrap
