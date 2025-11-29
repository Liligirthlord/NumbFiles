#!/bin/bash

# -----------------------------
# Paths
# -----------------------------
DOTFILES="$HOME/.local/share/numbie"
THEMES_DIR="$DOTFILES/themes"
CURRENT_THEME="$DOTFILES/current/theme"
CURRENT_BACKGROUND="$DOTFILES/current/background"
MANGO_SRC="$CURRENT_THEME/mango.conf"
MANGO_CFG="$HOME/.config/mango/looknfeel.conf"

# -----------------------------
# Ensure necessary directories exist
# -----------------------------
mkdir -p "$THEMES_DIR"
mkdir -p "$DOTFILES/current"

# -----------------------------
# Helper functions
# -----------------------------
log() { echo -e "[*] $1"; }
log_success() { echo -e "[✔] $1"; }
log_error() { echo -e "[✖] $1"; }

# -----------------------------
# Reload Waybar + Hyprland + MangoWC
# -----------------------------
reload_env() {
    log "Reloading Waybar..."
    killall waybar 2>/dev/null
    waybar & disown

    log "Reloading Hyprland..."
    hyprctl reload

    log "Reloading MangoWC..."
    mmsg -d reload_config

    log_success "Environment reloaded"
}

# -----------------------------
# Update MangoWC config
# -----------------------------
update_mango_config() {
    if [[ ! -f "$MANGO_SRC" ]]; then
        log_error "No mango.conf found in theme: $MANGO_SRC"
        return 1
    fi

    log "Updating MangoWC theme…"

    TMP_NEW=$(mktemp)

    # Format: remove comments, strip semicolons + spaces → key=value
    grep "=" "$MANGO_SRC" \
        | sed -E 's/[[:space:]]*=[[:space:]]*/=/; s/;.*//; s/[[:space:]]+$//' \
        > "$TMP_NEW"

    # Inject formatted values into Mango config
    while IFS='=' read -r key value; do
        # Remove ALL '#' characters from the value
        value=${value//#/}

        if grep -q "^$key=" "$MANGO_CFG" 2>/dev/null; then
            sed -i "s|^$key=.*|$key=$value|" "$MANGO_CFG"
        else
            echo "$key=$value" >> "$MANGO_CFG"
        fi
    done < "$TMP_NEW"

    rm -f "$TMP_NEW"

    log_success "MangoWC config updated"
}

# -----------------------------
# Set wallpaper + apply colors
# -----------------------------
set_wallpaper() {
    local wallpaper="$1"
    if [[ ! -f "$wallpaper" ]]; then
        log_error "Wallpaper not found: $wallpaper"
        return 1
    fi

    ln -nsf "$wallpaper" "$CURRENT_BACKGROUND"
    log_success "Wallpaper set: $(basename "$wallpaper")"

    # apply wallpaper
    pkill swaybg 2>/dev/null
    swaybg -m fill -i "$CURRENT_BACKGROUND" & disown

    # generate colors with Tinte
    if command -v tinte >/dev/null 2>&1; then
        tinte apply "$CURRENT_BACKGROUND"
        log_success "Colors generated with Tinte"
    fi

    # update MangoWC config now that Tinte wrote the colors
    update_mango_config
}

# -----------------------------
# Switch theme
# -----------------------------
switch_theme() {
    local theme="$1"
    local theme_path="$THEMES_DIR/$theme"

    if [[ ! -d "$theme_path" ]]; then
        log_error "Theme not found: $theme"
        return 1
    fi

    # Clear current theme folder and copy everything
    rm -rf "$CURRENT_THEME"
    mkdir -p "$CURRENT_THEME"
    cp -r "$theme_path/"* "$CURRENT_THEME/"
    log_success "Theme switched to: $theme"

    # set wallpaper
    local wallpaper=$(find "$CURRENT_THEME/backgrounds" -type f | head -n 1)
    if [[ -n "$wallpaper" ]]; then
        set_wallpaper "$wallpaper"
    else
        log "[!] No wallpapers found in $CURRENT_THEME/backgrounds"
    fi

    # final reload
    reload_env
}

# -----------------------------
# Main
# -----------------------------
if [[ -z "$1" ]]; then
    log "Usage: $0 <theme-name>"
    exit 1
fi

switch_theme "$1"

