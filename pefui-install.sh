#!/usr/bin/env bash
# install_pefui.sh - Installs pefui.sh in the same directory as this installer

INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_FILE="$INSTALL_DIR/pefui.sh"
DESKTOP_FILE="$HOME/.local/share/applications/pefui.desktop"

mkdir -p "$(dirname "$DESKTOP_FILE")"

cat > "$SCRIPT_FILE" << 'EOF'
#!/usr/bin/env bash
# pefui.sh - peysh's enhanced figlet user interface (PEFUI)
# Fully portable, desktop-ready Figlet GUI using Yad or Zenity
# Streams output live as fonts are generated.

# --- Check dependencies ---
if ! command -v figlet &>/dev/null; then
    echo "figlet is not installed. Please install figlet to use pefui."
    exit 1
fi

# --- Detect GUI tool ---
if command -v yad &>/dev/null; then
    GUI_TOOL="yad"
elif command -v zenity &>/dev/null; then
    GUI_TOOL="zenity"
else
    echo "No GUI dialog tool found. Please install yad or zenity."
    exit 1
fi

# --- GUI helper functions ---
gui_entry() {
    local prompt="$1"
    case "$GUI_TOOL" in
        yad)    yad --entry --title="pefui" --text="$prompt" --width=400 ;;
        zenity) zenity --entry --title="pefui" --text="$prompt" --width=400 ;;
    esac
}

gui_textinfo_live() {
    local fifo="$1"
    case "$GUI_TOOL" in
        yad)    yad --text-info --title="pefui - Figlet Output" --width=800 --height=600 --fontname="Monospace 10" --wrap < <(tail -f "$fifo") ;;
        zenity) zenity --text-info --title="pefui - Figlet Output" --width=800 --height=600 --font="Monospace 10" < <(tail -f "$fifo") ;;
    esac
}

# --- Get input text ---
INPUT="${1:-}"
if [ -z "$INPUT" ]; then
    INPUT=$(gui_entry "Welcome to pefui\n(Peysh's enhanced figlet user interface)\n=~=~=\nEnter text to display:")
fi
[ -z "$INPUT" ] && exit

# --- Determine fonts directory ---
FONT_DIR=$(figlet -I2)
[ ! -d "$FONT_DIR" ] && FONT_DIR="/usr/share/figlet"  # fallback

# --- Optional font search ---
SEARCH=$(gui_entry "Enter a keyword to filter fonts (leave empty to show all):")
SEARCH=$(echo "$SEARCH" | tr '[:upper:]' '[:lower:]')

# --- Create FIFO for live output ---
TMPFIFO=$(mktemp)
trap 'rm -f "$TMPFIFO"' EXIT

# --- Generate Figlet output in the background ---
(
    MATCH_COUNT=0
    for font in "$FONT_DIR"/*.flf; do
        FONT_NAME=$(basename "$font" .flf)
        FONT_NAME_LOWER=$(echo "$FONT_NAME" | tr '[:upper:]' '[:lower:]')
        if [[ -z "$SEARCH" || "$FONT_NAME_LOWER" == *"$SEARCH"* ]]; then
            ((MATCH_COUNT++))
            echo -e "\n=== $FONT_NAME ===\n" >> "$TMPFIFO"
            figlet -f "$font" "$INPUT" 2>/dev/null >> "$TMPFIFO"
            echo >> "$TMPFIFO"
            sleep 0.05
        fi
    done

    if [ "$MATCH_COUNT" -eq 0 ]; then
        echo -e "\nNo fonts found matching: \"$SEARCH\"\nTry again with a different filter." >> "$TMPFIFO"
    fi
) &

# --- Display output live ---
gui_textinfo_live "$TMPFIFO"
EOF

chmod +x "$SCRIPT_FILE"

cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Name=pefui
Comment=peysh's enhanced figlet user interface
Exec=$SCRIPT_FILE
Icon=utilities-terminal
Terminal=false
Type=Application
Categories=Utility;
EOF

echo "Installation complete."
echo "• pefui.sh is located in: $INSTALL_DIR"
echo "• You can launch it from your applications menu or run: $SCRIPT_FILE [text]"
