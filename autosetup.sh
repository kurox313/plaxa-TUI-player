#!/usr/bin/env bash

set -e

APP_NAME="plaxa"
APP_DIR="$HOME/.local/share/plaxa"
BIN_DIR="$HOME/.local/bin"
PY_FILE="plaxaV1.py"

setup_directories() {
    echo "[+] Creating directories..."
    mkdir -p "$APP_DIR"
    mkdir -p "$BIN_DIR"
}

install_python_script() {
    echo "[+] Installing Python TUI..."
    mv "$PY_FILE" "$APP_DIR/"
}

create_launcher() {
    echo "[+] Creating command launcher..."

    cat > "$BIN_DIR/$APP_NAME" <<EOF
#!/usr/bin/env bash
python3 \$HOME/.local/share/plaxa/$PY_FILE "\$@"
EOF

    chmod +x "$BIN_DIR/$APP_NAME"
}

setup_path() {
    echo "[+] Checking PATH setup..."

    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo "[!] ~/.local/bin is not in PATH."

        if [ -f "$HOME/.bashrc" ]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
            echo "[+] Added PATH to .bashrc"
        fi

        if [ -f "$HOME/.zshrc" ]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
            echo "[+] Added PATH to .zshrc"
        fi

        if command -v fish >/dev/null 2>&1; then
            fish -c "set -U fish_user_paths \$HOME/.local/bin \$fish_user_paths"
            echo "[+] Added PATH to fish"
        fi
    fi
}

main() {
    setup_directories
    install_python_script
    create_launcher
    setup_path

    echo ""
    echo "[✓] Installation complete!"
    echo "Run the app with:"
    echo "    plaxa"
}

main
