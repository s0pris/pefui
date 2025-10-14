#!/usr/bin/env bash
# install_pefui.sh - Installs pefui.sh in the same directory as this installer

# --- Step 0: Determine install directory (same as this script) ---
INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_FILE="$INSTALL_DIR/pefui.sh"
DESKTOP_FILE="$HOME/.local/share/applications/pefui.desktop"

# Create applications directory if it doesn't exist
mkdir -p "$(dirname "$DESKTOP_FILE")"

# --- Step 1: Write the pefui.sh script ---
cat > "$SCRIPT_FILE" << 'EOF'
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
EOF

# Make pefui.sh executable
chmod +x "$SCRIPT_FILE"

# --- Step 2: Create desktop launcher ---
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

echo "pefui installed successfully!"
echo "pefui.sh is located in: $INSTALL_DIR"
echo "You can launch it from your applications menu or run: $SCRIPT_FILE [text]"
