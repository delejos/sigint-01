# SIGINT-01

A clean, dark Arch Linux + Hyprland setup built for people who live in the terminal. Designed to stay out of your way — no visual noise, no distractions, everything where you expect it.

Built with IT work, pentesting, and VM-heavy workflows in mind. Four dedicated workspaces keep your environment organized without the clutter of a traditional desktop.

---

## Why this build

Most desktop setups are either too minimal to be useful or too bloated to be fast. This one sits in between:

- **Dark everywhere** — deep steel blue base, easy on the eyes during long sessions
- **Keyboard-first** — rofi launcher, workspace switching, window management all on keybinds
- **Low overhead** — Hyprland is a Wayland compositor that uses almost no resources idle
- **Purpose-built workspaces** — one workspace per context so nothing bleeds into anything else
- **Consistent look** — the same color palette flows through every component: terminal, bar, lock screen, fetch, monitor, wallpapers

---

## Workspaces

| # | Name | Intended use |
|---|------|--------------|
| 1 | ALPHA | Primary terminal, system administration |
| 2 | MIKE | General purpose, file management |
| 3 | DELTA | Development, code editors, VMs |
| 4 | ECHO | Browser, comms, research |

Each workspace has its own wallpaper. Switching workspaces swaps the wallpaper automatically.

---

## Stack

| Component | Package |
|-----------|---------|
| Window manager | `hyprland` |
| Status bar | `waybar` |
| Lock screen | `hyprlock` |
| Display manager | `greetd` + `tuigreet` |
| Terminal | `kitty` |
| Shell | `fish` + `starship` |
| App launcher | `rofi-wayland` |
| System fetch | `fastfetch` |
| Resource monitor | `btop` |
| Editor | `neovim` |
| Screenshots | `flameshot` |
| Notifications | `dunst` |
| Wallpapers | custom-generated via Python + Pillow |

---

## Install

> Requires a base Arch Linux install with an internet connection. Run as your regular user — `sudo` access is needed for package installation and system config files.

```bash
git clone https://github.com/delejos/sigint-01.git ~/sigint-01
cd ~/sigint-01
chmod +x install.sh
./install.sh
```

The script handles everything:
1. Installs all packages via `pacman` and `yay` (AUR helper installed automatically if missing)
2. Symlinks configs from the repo into `~/.config/`
3. Generates wallpapers into `~/Wallpapers/`
4. Installs system configs (`/etc/greetd/config.toml`)
5. Enables `greetd`, `sshd`, and pipewire services
6. Sets `fish` as your default shell

### Applying the hardened sshd_config

The repo includes a minimal `sshd_config` with `PermitRootLogin no` and Protocol 2. It is skipped by default so you can review it first. To apply it:

```bash
INSTALL_SSHD_CONFIG=1 ./install.sh
```

---

## Post-install

- **btop theme** — open btop → `ESC` → Preferences → Color theme → select `sigint-01`
- **Neovim plugins** — run `nvim` on first launch and let lazy.nvim sync
- **Reboot** — greetd takes over as the display manager; reboot to activate it

---

## Keybinds

| Keys | Action |
|------|--------|
| `Super + Return` | Terminal (kitty) |
| `Super + R` | App launcher (rofi) |
| `Super + E` | File manager (thunar) |
| `Super + L` | Lock screen |
| `Super + Q` | Close window |
| `Super + F` | Fullscreen |
| `Super + V` | Toggle floating |
| `Super + 1–4` | Switch workspace |
| `Super + Shift + 1–4` | Move window to workspace |
| `Super + Arrow keys` | Move focus |
| `Print` | Screenshot (flameshot) |

---

## Structure

```
.
├── .config/
│   ├── hypr/           # hyprland.conf, hyprlock.conf, wallpaper.sh,
│   │   └── scheme/     # workspace-watcher.sh, color scheme
│   ├── waybar/         # config.jsonc, style.css
│   ├── kitty/          # kitty.conf
│   ├── fish/           # config.fish
│   ├── fastfetch/      # config.jsonc
│   ├── btop/themes/    # sigint-01.theme, caelestia.theme
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

Dark steel blue base with cyan accents. Consistent across every component.

| Role | Hex |
|------|-----|
| Background | `#131317` |
| Active border | `#2A6080` |
| Accent | `#4AB8C9` |
| Text | `#E5E1E7` |
| Subtext | `#918F9A` |
