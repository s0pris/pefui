#!/usr/bin/env bash
# pefui.sh - peysh's enhanced figlet user interface (PEFUI)

if ! command -v figlet &>/dev/null; then
    echo "figlet is not installed. Please install figlet to use pefui."
    exit 1
fi

if command -v yad &>/dev/null; then
    GUI_TOOL="yad"
elif command -v zenity &>/dev/null; then
    GUI_TOOL="zenity"
else
    echo "No GUI dialog tool found. Please install yad or zenity."
    exit 1
fi

gui_entry() {
    local prompt="$1"
    case "$GUI_TOOL" in
        yad)    yad --entry --title="pefui" --text="$prompt" --width=400 ;;
        zenity) zenity --entry --title="pefui" --text="$prompt" --width=400 ;;
    esac
}

gui_textinfo() {
    local content="$1"
    case "$GUI_TOOL" in
        yad)    echo -e "$content" | yad --text-info --title="pefui - Figlet Output" --width=800 --height=600 --fontname="Monospace 10" --wrap ;;
        zenity) echo -e "$content" | zenity --text-info --title="pefui - Figlet Output" --width=800 --height=600 --font="Monospace 10" ;;
    esac
}

gui_error() {
    local msg="$1"
    case "$GUI_TOOL" in
        yad)    yad --error --title="pefui error" --text="$msg" ;;
        zenity) zenity --error --title="pefui error" --text="$msg" ;;
    esac
}

INPUT="${1:-}"
if [ -z "$INPUT" ]; then
    INPUT=$(gui_entry "Welcome to pefui\n(Peysh's enhanced figlet user interface)\n=~=~=\nEnter text to display:")
fi
[ -z "$INPUT" ] && exit

FONT_DIR=$(figlet -I2)
[ ! -d "$FONT_DIR" ] && FONT_DIR="/usr/share/figlet"  

OUTPUT=""
for font in "$FONT_DIR"/*.flf; do
    FONT_NAME=$(basename "$font" .flf)
    FIG=$(figlet -f "$font" "$INPUT" 2>/dev/null)
    OUTPUT+="=== $FONT_NAME ===\n$FIG\n\n"
done

gui_textinfo "$OUTPUT"
