#!/usr/bin/env bash
# ============================================================
# SIGINT-01 // lock.sh — terminal lock screen
# Mimics tuigreet aesthetic: dark bg, centered box, asterisks
# Launched by kitty (fullscreen, class=sigint-lock) from sway
#
# NOTE: This is a terminal lock screen, not a Wayland protocol
# lock surface. It does not block TTY switching (Ctrl+Alt+F2).
# It is designed for aesthetic consistency with tuigreet on
# trusted single-user hardware. For multi-user or high-security
# environments use swaylock instead.
# ============================================================

# ── Signal trapping — prevent Ctrl+C / Ctrl+\ from escaping ──
trap '' INT TERM QUIT HUP

# ── ANSI colors ───────────────────────────────────────────────
CYN='\033[38;2;74;184;201m'       # #4AB8C9 — accent / border
WHT='\033[38;2;229;225;231m'      # #E5E1E7 — warning text
DIM='\033[38;2;139;175;196m'      # #8BAFC4 — subtext
RED='\033[38;2;201;74;74m'        # #C94A4A — error
AMB='\033[38;2;201;168;74m'       # #C9A84A — caps lock warning
RST='\033[0m'
BOLD='\033[1m'

# ── Box layout ────────────────────────────────────────────────
BOX_W=74        # total box width including border chars
INNER_W=68      # content width: BOX_W - 4 (│ + 2sp + content + 2sp + │ → actually │ + sp + content + sp + │)
                # we use: "│  content  │" = 2 + INNER_W + 0 = BOX_W-2, so INNER_W = BOX_W-4

USER_NAME="$(whoami)"

# ── Helpers ───────────────────────────────────────────────────

# Print a horizontal rule char repeated N times
hrule() {
    local n="$1" char="${2:-─}"
    printf "%${n}s" | tr ' ' "$char"
}

# Print the box with optional status/error line
draw_box() {
    local status_line="${1:-}"

    clear

    local cols rows
    cols=$(tput cols 2>/dev/null || echo 80)
    rows=$(tput lines 2>/dev/null || echo 24)

    # Box content line count:
    # top border, 4 warning lines, separator, user line, status line, password line, bottom border = 10
    local box_lines=10
    local vpad=$(( (rows - box_lines) / 2 ))
    local hpad=$(( (cols - BOX_W) / 2 ))
    [[ $hpad -lt 0 ]] && hpad=0
    [[ $vpad -lt 0 ]] && vpad=0

    local H
    H=$(printf "%${hpad}s" '')

    # Vertical padding
    local i
    for ((i = 0; i < vpad; i++)); do printf '\n'; done

    # ── Top border ────────────────────────────────────────────
    printf "%s${CYN}┌$(hrule $((BOX_W - 2)))┐${RST}\n" "$H"

    # ── Warning block ─────────────────────────────────────────
    _row "$H" "${WHT}SIGINT-01 // WARNING: This system is actively monitored.    ${RST}"
    _row "$H" "${WHT}Authorized use only. Unauthorized access or use is          ${RST}"
    _row "$H" "${WHT}prohibited and will be prosecuted to the full extent of     ${RST}"
    _row "$H" "${WHT}applicable law.                                             ${RST}"

    # ── Separator ─────────────────────────────────────────────
    printf "%s${CYN}├$(hrule $((BOX_W - 2)))┤${RST}\n" "$H"

    # ── User line ─────────────────────────────────────────────
    _row "$H" "${DIM}Authenticate into ${CYN}${USER_NAME}${RST}"

    # ── Status / error line ───────────────────────────────────
    if [[ -n "$status_line" ]]; then
        _row "$H" "${RED}${status_line}${RST}"
    else
        _row "$H" ""
    fi

    # ── Password prompt row — print without newline so read lands here
    printf "%s${CYN}│${RST}  ${DIM}Password: ${RST}" "$H"
}

# Print a full-width padded box row
_row() {
    local h="$1" content="$2"
    # We print content between borders; strip ANSI to measure visible length,
    # then pad with spaces so the right border lines up.
    local visible
    visible=$(printf '%b' "$content" | sed 's/\x1b\[[0-9;]*m//g')
    local pad=$(( INNER_W - ${#visible} ))
    [[ $pad -lt 0 ]] && pad=0
    printf "%s${CYN}│${RST}  %b%${pad}s  ${CYN}│${RST}\n" "$h" "$content" ''
}

# ── Password reader — echoes asterisks per keystroke ──────────
read_password() {
    local pw=''
    local char
    # Disable echo for the duration
    stty -echo 2>/dev/null
    while IFS= read -r -s -n1 char; do
        case "$char" in
            # Enter / null — done
            '' | $'\n' | $'\r')
                break
                ;;
            # Backspace / DEL
            $'\177' | $'\b')
                if [[ -n "$pw" ]]; then
                    pw="${pw%?}"
                    printf '\b \b'
                fi
                ;;
            # Ctrl+C / Ctrl+\ — swallow, re-draw
            $'\003' | $'\034')
                ;;
            *)
                pw+="$char"
                printf '*'
                ;;
        esac
    done
    stty echo 2>/dev/null
    printf '\n'
    # Return value via stdout capture — caller uses $()
    printf '%s' "$pw"
}

# ── PAM authentication ────────────────────────────────────────
check_password() {
    local pw="$1"
    # pamtester reads one password from stdin, exits 0 on success
    printf '%s\n' "$pw" | pamtester login "$USER_NAME" authenticate 2>/dev/null
}

# ── Bottom border — drawn after password entry ─────────────────
close_box() {
    local cols
    cols=$(tput cols 2>/dev/null || echo 80)
    local hpad=$(( (cols - BOX_W) / 2 ))
    [[ $hpad -lt 0 ]] && hpad=0
    local H
    H=$(printf "%${hpad}s" '')
    printf "%s${CYN}└$(hrule $((BOX_W - 2)))┘${RST}\n" "$H"
}

# ── Main auth loop ────────────────────────────────────────────
STATUS=""

while true; do
    draw_box "$STATUS"

    # Caps lock warning (non-blocking check via xset — skip gracefully if unavailable)
    if xset q 2>/dev/null | grep -q "Caps Lock:.*on"; then
        printf " ${AMB}[CAPS LOCK ON]${RST}"
    fi

    PW="$(read_password)"
    close_box

    if [[ -z "$PW" ]]; then
        STATUS="No password entered."
        continue
    fi

    printf "\n"

    if check_password "$PW"; then
        clear
        exit 0
    else
        STATUS="ACCESS DENIED // Incorrect password. Try again."
    fi
done
