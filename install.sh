#!/usr/bin/env bash
# ============================================================
# SIGINT-01 — Install Script
# Arch Linux + Hyprland military ops center build
# ============================================================

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()    { echo -e "${CYAN}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC}   $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
die()     { echo -e "${RED}[ERR]${NC}  $*"; exit 1; }

# ── 1. Package installation ──────────────────────────────────

PACMAN_PKGS=(
    # Wayland / Hyprland
    sway swaylock swaybg swayidle
    waybar dunst
    polkit-gnome
    wl-clipboard cliphist
    xdg-desktop-portal-wlr

    # Terminal & shell
    kitty fish starship

    # CLI tools
    fastfetch btop neovim
    eza bat brightnessctl

    # Apps
    thunar flameshot firefox

    # Audio
    wireplumber pipewire pipewire-alsa pipewire-pulse

    # Fonts
    ttf-jetbrains-mono-nerd ttf-font-awesome

    # Python (for wallpaper generation)
    python python-pillow

    # System
    greetd openssh

    # Lock screen authentication
    pamtester
)

YAY_PKGS=(
    rofi-wayland
    greetd-tuigreet
)

install_packages() {
    info "Updating pacman..."
    sudo pacman -Syu --noconfirm

    info "Installing pacman packages..."
    sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

    if ! command -v yay &>/dev/null; then
        info "Installing yay (AUR helper)..."
        sudo pacman -S --needed --noconfirm git base-devel
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        (cd /tmp/yay && makepkg -si --noconfirm)
        rm -rf /tmp/yay
    fi

    info "Installing AUR packages..."
    yay -S --needed --noconfirm "${YAY_PKGS[@]}"

    success "Packages installed."
}

# ── 2. Config symlinking ────────────────────────────────────

symlink() {
    local src="$1" dst="$2"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        warn "Backing up existing $dst → $dst.bak"
        mv "$dst" "$dst.bak"
    fi
    ln -sfn "$src" "$dst"
    success "Linked $dst"
}

link_configs() {
    info "Symlinking configs to $CONFIG_DIR..."
    mkdir -p "$CONFIG_DIR"

    # Directories
    for dir in sway swaylock waybar kitty fish fastfetch btop nvim flameshot; do
        symlink "$REPO_DIR/.config/$dir" "$CONFIG_DIR/$dir"
    done

    # Single file
    symlink "$REPO_DIR/.config/starship.toml" "$CONFIG_DIR/starship.toml"

    # Wallpaper generator script
    symlink "$REPO_DIR/scripts/generate_wallpapers.py" "$HOME/generate_wallpapers.py"

    # Lock screen script — installed to ~/.local/bin/sigint-lock (on PATH)
    mkdir -p "$HOME/.local/bin"
    chmod +x "$REPO_DIR/scripts/lock.sh"
    symlink "$REPO_DIR/scripts/lock.sh" "$HOME/.local/bin/sigint-lock"

    success "Configs linked."
}

# ── 3. Wallpaper generation ─────────────────────────────────

generate_wallpapers() {
    info "Generating wallpapers..."
    mkdir -p "$HOME/Wallpapers"

    if ! python "$HOME/generate_wallpapers.py"; then
        die "Wallpaper generation failed. Make sure python-pillow is installed."
    fi

    # Copy SVG sources to ~/Wallpapers/svg/
    mkdir -p "$HOME/Wallpapers/svg"
    cp "$REPO_DIR/wallpapers/"*.svg "$HOME/Wallpapers/svg/"

    success "Wallpapers generated → ~/Wallpapers/"
}

# ── 4. System files (requires sudo) ─────────────────────────

install_system_files() {
    info "Installing system config files (requires sudo)..."

    # greetd
    if [ -f "$REPO_DIR/system/greetd/config.toml" ]; then
        sudo mkdir -p /etc/greetd
        sudo cp "$REPO_DIR/system/greetd/config.toml" /etc/greetd/config.toml
        success "Installed /etc/greetd/config.toml"
    else
        warn "system/greetd/config.toml not found — skipping"
    fi

    # sshd_config — install only if explicitly requested
    if [ "${INSTALL_SSHD_CONFIG:-0}" = "1" ]; then
        if [ -f "$REPO_DIR/system/ssh/sshd_config" ]; then
            sudo cp "$REPO_DIR/system/ssh/sshd_config" /etc/ssh/sshd_config
            success "Installed /etc/ssh/sshd_config"
        fi
    else
        warn "Skipping sshd_config (set INSTALL_SSHD_CONFIG=1 to apply)"
    fi

    # grub — suppress kernel messages bleeding into tuigreet on TTY1
    if [ -f "$REPO_DIR/system/grub/grub" ]; then
        sudo cp "$REPO_DIR/system/grub/grub" /etc/default/grub
        success "Installed /etc/default/grub (quiet loglevel=3)"
        info "Regenerating GRUB config..."
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        success "GRUB config regenerated."
    else
        warn "system/grub/grub not found — skipping GRUB configuration"
    fi
}

# ── 5. Service enablement ────────────────────────────────────

enable_services() {
    info "Enabling systemd services..."

    sudo systemctl enable --now greetd
    sudo systemctl enable --now sshd

    # User services
    systemctl --user enable --now pipewire pipewire-pulse wireplumber

    success "Services enabled."
}

# ── 6. Set fish as default shell ────────────────────────────

set_shell() {
    if [ "$SHELL" != "$(which fish)" ]; then
        info "Setting fish as default shell..."
        chsh -s "$(which fish)"
        success "Default shell set to fish. Re-login to apply."
    fi
}

# ── Main ─────────────────────────────────────────────────────

main() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  SIGINT-01 // SWAY INSTALL  ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════╝${NC}"
    echo ""

    install_packages
    link_configs
    generate_wallpapers
    install_system_files
    enable_services
    set_shell

    echo ""
    success "Installation complete. Log out and back in, or reboot."
}

main "$@"
