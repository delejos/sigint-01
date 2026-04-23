# SIGINT-01 // Sway Laptop

> **Branch:** `sway-laptop` — Lenovo ThinkPad x280 / Intel UHD 620 variant
> **Desktop build (Hyprland):** see [`master`](https://github.com/delejos/sigint-01/tree/master)

A dark, minimal Sway setup for Intel laptop hardware. Same aesthetic, same workspace layout, same keybind philosophy as the master branch — built for Sway because it has rock-solid Intel iGPU support, runs cooler, and is more stable on ThinkPad hardware than Hyprland.

---

## Why Sway over Hyprland for this build

- Hyprland can be unstable on Intel iGPU (UHD 620 / Iris Xe)
- Sway (wlroots-based) has native, well-tested Intel Wayland support
- Nearly identical keybind system — switching between branches feels the same
- Lower CPU overhead — runs cooler on a ThinkPad, better battery life
- `swaylock` replaces `hyprlock`, `swaybg` replaces `hyprpaper`

---

## Target hardware

| Field | Spec |
|-------|------|
| Machine | Lenovo ThinkPad x280 |
| GPU | Intel UHD 620 |
| Form factor | Laptop |
| Display | eDP-1 (internal) |

---

## What changed from master

| Component | Master (Hyprland) | This branch (Sway) |
|-----------|-------------------|---------------------|
| Window manager | `hyprland` | `sway` |
| Lock screen | `hyprlock` | `swaylock` |
| Wallpaper | `hyprpaper` | `swaybg` |
| Portal | `xdg-desktop-portal-hyprland` | `xdg-desktop-portal-wlr` |
| Backlight | — | `brightnessctl` |
| Idle | — | `swayidle` |
| Waybar modules | `hyprland/workspaces` | `sway/workspaces` |
| Config location | `.config/hypr/` | `.config/sway/` |

## What stays identical

- Color palette (`#131317`, `#4AB8C9`, `#2A6080`)
- Workspace names: ALPHA, MIKE, DELTA, ECHO
- Kitty, Fish + Starship, Rofi, Neovim, Btop, Dunst, Fastfetch
- Wallpaper generator (Python + Pillow)
- greetd + tuigreet login manager
- SSH hardening in `system/`
- All keybinds (Super-based, keyboard-first)

---

## Workspaces

| # | Name | Intended use |
|---|------|--------------|
| 1 | ALPHA | Primary terminal, system administration |
| 2 | MIKE | Media management and analysis |
| 3 | DELTA | Development, code editors, VMs |
| 4 | ECHO | Browser, comms, research |

Each workspace has its own wallpaper. Switching workspaces swaps the wallpaper automatically via `swaybg`.

---

## Stack

| Component | Package |
|-----------|---------|
| Window manager | `sway` |
| Status bar | `waybar` |
| Lock screen | `swaylock` |
| Wallpaper | `swaybg` |
| Idle manager | `swayidle` |
| Display manager | `greetd` + `tuigreet` |
| Terminal | `kitty` |
| Shell | `fish` + `starship` |
| App launcher | `rofi-wayland` |
| System fetch | `fastfetch` |
| Resource monitor | `btop` |
| Editor | `neovim` |
| Screenshots | `flameshot` |
| Backlight | `brightnessctl` |
| Notifications | `dunst` |
| Wallpapers | custom-generated via Python + Pillow |

---

## Requirements

- **GPU** — Intel iGPU (UHD 620 or similar). AMD also works. NVIDIA is not supported on this branch.
- **Font** — `JetBrains Mono Nerd Font` is required. Without it, Waybar icons, Starship prompt, and Fastfetch will render broken. The install script handles this via `ttf-jetbrains-mono-nerd`.
- **Wayland session** — this build does not support X11.

---

## Install

```bash
git clone -b sway-laptop https://github.com/delejos/sigint-01.git ~/sigint-01
cd ~/sigint-01
chmod +x install.sh
./install.sh
```

The script handles everything:
1. Installs all packages via `pacman` and `yay`
2. Symlinks configs into `~/.config/`
3. Generates wallpapers into `~/Wallpapers/`
4. Installs `/etc/greetd/config.toml`
5. Enables `greetd`, `sshd`, and pipewire services
6. Sets `fish` as your default shell

### Applying the hardened sshd_config

```bash
INSTALL_SSHD_CONFIG=1 ./install.sh
```

---

## Post-install

- **btop theme** — open btop → `ESC` → Preferences → Color theme → select `sigint-01`
- **Neovim plugins** — run `nvim` on first launch and let lazy.nvim sync
- **Reboot** — greetd takes over as the display manager; reboot to activate it
- **Backlight on first boot** — if brightness keys don't work, add yourself to the `video` group: `sudo usermod -aG video $USER`

---

## Keybinds

| Keys | Action |
|------|--------|
| `Super + Return` | Terminal (kitty) |
| `Super + R` | App launcher (rofi) |
| `Super + E` | File manager (thunar) |
| `Super + L` | Lock screen (swaylock) |
| `Super + Q` | Close window |
| `Super + F` | Fullscreen |
| `Super + V` | Toggle floating |
| `Super + 1–4` | Switch workspace |
| `Super + Shift + 1–4` | Move window to workspace |
| `Super + Arrow keys` | Move focus |
| `Print` | Screenshot (flameshot) |
| `XF86MonBrightnessUp/Down` | Backlight ±5% |
| `XF86AudioRaise/Lower/Mute` | Volume |

---

## Laptop-specific behavior

- **Touchpad** — tap-to-click, natural scroll, disable-while-typing enabled
- **Lid close** — triggers `swaylock` automatically
- **Backlight** — scroll on Waybar backlight module also adjusts brightness
- **Battery** — displayed in Waybar with charging/full/critical states

---

## Structure

```
.
├── .config/
│   ├── sway/           # config, wallpaper.sh
│   ├── swaylock/       # config (matches color palette)
│   ├── waybar/         # config.jsonc (sway modules + battery + backlight),
│   │                   # style.css
│   ├── kitty/          # kitty.conf
│   ├── fish/           # config.fish
│   ├── fastfetch/      # config.jsonc
│   ├── btop/themes/    # sigint-01.theme
│   ├── nvim/           # colorscheme + plugins
│   ├── flameshot/      # flameshot.ini
│   └── starship.toml
├── wallpapers/         # SVG source files
├── scripts/            # generate_wallpapers.py
├── system/
│   ├── greetd/         # /etc/greetd/config.toml
│   └── ssh/            # /etc/ssh/sshd_config
└── install.sh
```

---

## Color palette

| Role | Hex |
|------|-----|
| Background | `#070C12` |
| Active border | `#2A6080` |
| Accent | `#7EB8C9` |
| Text | `#8BAFC4` |
| Subtext | `#4A7A90` |

---

## Credits

Built from scratch. Color scheme generated with [matugen](https://github.com/InioX/matugen). Inspired by the broader Sway/wlroots and r/unixporn community.
