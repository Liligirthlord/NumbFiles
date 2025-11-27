#!/bin/bash

# -----------------------------
# Paths
# -----------------------------
DOTFILES="$HOME/.local/share/numbie"
THEMES_DIR="$DOTFILES/themes"
CURRENT_THEME="$DOTFILES/current/theme"
CURRENT_BACKGROUND="$DOTFILES/current/background"

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
# Reload Waybar + Hyprland
# -----------------------------
reload_env() {
    log "Reloading Waybar..."
    killall waybar 2>/dev/null
    waybar & disown

    log "Reloading Hyprland..."
    hyprctl reload

    log_success "Environment reloaded"
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

    # generate colors
    if command -v tinte >/dev/null 2>&1; then
        tinte apply "$CURRENT_BACKGROUND"
        log_success "Colors generated with Tinte"
    fi
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

    ln -nsf "$theme_path" "$CURRENT_THEME"
    log_success "Theme switched to: $theme"

    # set wallpaper
    local wallpaper=$(find "$theme_path/backgrounds" -type f | head -n 1)
    if [[ -n "$wallpaper" ]]; then
        set_wallpaper "$wallpaper"
    else
        log "[!] No wallpapers found in $theme_path/backgrounds"
    fi

    # reload Hyprland + Waybar *after* everything
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

