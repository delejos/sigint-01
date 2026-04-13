from PIL import Image, ImageDraw, ImageFont
import os

W, H = 1920, 1080
OUT = os.path.expanduser("~/Wallpapers")
os.makedirs(OUT, exist_ok=True)

BG      = (7, 12, 18)
GRID    = (28, 51, 71)
BORDER  = (42, 96, 128)
DIM     = (13, 30, 46)
FAINT   = (15, 32, 48)
ACCENT  = (78, 184, 201)
TEXT    = (74, 122, 144)

def base_image():
    img = Image.new("RGB", (W, H), BG)
    d = ImageDraw.Draw(img)
    for x in range(0, W, 60):
        d.line([(x, 0), (x, H)], fill=GRID, width=1)
    for y in range(0, H, 60):
        d.line([(0, y), (W, y)], fill=GRID, width=1)
    corners = [(30,30),(W-38,30),(30,H-38),(W-38,H-38)]
    for cx, cy in corners:
        d.rectangle([cx, cy, cx+8, cy+8], outline=BORDER, width=1)
    return img, d

def footer(d, left_lines, right_lines):
    try:
        font = ImageFont.truetype("/usr/share/fonts/TTF/JetBrainsMono-Regular.ttf", 18)
    except:
        font = ImageFont.load_default()
    y = H - 80
    for line in left_lines:
        d.text((40, y), line, fill=DIM, font=font)
        y += 22
    y = H - 80
    for line in right_lines:
        bbox = d.textbbox((0, 0), line, font=font)
        tw = bbox[2] - bbox[0]
        d.text((W - 40 - tw, y), line, fill=DIM, font=font)
        y += 22

def top_left(d, lines):
    try:
        font = ImageFont.truetype("/usr/share/fonts/TTF/JetBrainsMono-Regular.ttf", 18)
    except:
        font = ImageFont.load_default()
    y = 40
    for line in lines:
        d.text((40, y), line, fill=DIM, font=font)
        y += 22

def icon_box(d, x, y, label):
    d.rectangle([x, y, x+90, y+90], fill=(5, 10, 15), outline=BORDER, width=2)
    try:
        font_sm = ImageFont.truetype("/usr/share/fonts/TTF/JetBrainsMono-Regular.ttf", 14)
    except:
        font_sm = ImageFont.load_default()
    d.text((x+10, y+72), f"[{label}]", fill=TEXT, font=font_sm)

def big_label(d, text, subtitle):
    try:
        font_big = ImageFont.truetype("/usr/share/fonts/TTF/JetBrainsMono-Bold.ttf", 160)
        font_sub = ImageFont.truetype("/usr/share/fonts/TTF/JetBrainsMono-Regular.ttf", 20)
    except:
        font_big = ImageFont.load_default()
        font_sub = ImageFont.load_default()
    bbox = d.textbbox((0, 0), text, font=font_big)
    tw = bbox[2] - bbox[0]
    d.text((W - 60 - tw, H//2 - 80), text, fill=DIM, font=font_big)
    bbox2 = d.textbbox((0, 0), subtitle, font=font_sub)
    tw2 = bbox2[2] - bbox2[0]
    d.text((W - 60 - tw2, H//2 + 100), subtitle, fill=FAINT, font=font_sub)

def watermark(d, x, y):
    try:
        font = ImageFont.truetype("/usr/share/fonts/TTF/JetBrainsMono-Regular.ttf", 16)
    except:
        font = ImageFont.load_default()
    d.text((x, y), "SIGINT-01", fill=FAINT, font=font)

# ALPHA
img, d = base_image()
icon_box(d, W-100, 30, "ALPHA")
try:
    f = ImageFont.truetype("/usr/share/fonts/TTF/JetBrainsMono-Bold.ttf", 36)
    d.text((W-92, 38), "</>", fill=BORDER, font=f)
except: pass
big_label(d, "ALPHA", "PRIMARY OPERATIONS TERMINAL")
watermark(d, 500, 500)
top_left(d, ["SYS.UPTIME: ACTIVE", "AUTH: LEVEL-5", "ENC: AES-256-GCM"])
footer(d, ["NET: SIGINT-01.LOCAL", "KERNEL: 6.19.11-ARCH1", "STATUS: NOMINAL"],
          ["UNCLASSIFIED", "FOR OFFICIAL USE ONLY", "FOUO // REL TO SI-01"])
img.save(f"{OUT}/wallpaper-alpha.png")
print("ALPHA done")

# MIKE
img, d = base_image()
icon_box(d, W-100, 30, "MIKE")
try:
    f = ImageFont.truetype("/usr/share/fonts/TTF/JetBrainsMono-Bold.ttf", 36)
    d.text((W-92, 38), "|>", fill=BORDER, font=f)
except: pass
big_label(d, "MIKE", "MEDIA // BROWSER // CONTENT")
watermark(d, 500, 500)
top_left(d, ["BROADCAST: ACTIVE", "SIGNAL: STRONG", "STREAM: ENCRYPTED"])
footer(d, ["FIREFOX: READY", "ZEN: READY", "VLC: STANDBY"],
          ["UNCLASSIFIED", "FOR OFFICIAL USE ONLY", "FOUO // REL TO SI-01"])
img.save(f"{OUT}/wallpaper-mike.png")
print("MIKE done")

# DELTA
img, d = base_image()
icon_box(d, W-100, 30, "DELTA")
try:
    f = ImageFont.truetype("/usr/share/fonts/TTF/JetBrainsMono-Bold.ttf", 28)
    d.text((W-96, 36), "GHOST", fill=BORDER, font=f)
except: pass
for r in [200, 140, 80, 40]:
    d.ellipse([W//4-r, H//2-r, W//4+r, H//2+r], outline=GRID, width=1)
d.line([(W//4-250, H//2), (W//4+250, H//2)], fill=GRID, width=1)
d.line([(W//4, H//2-250), (W//4, H//2+250)], fill=GRID, width=1)
big_label(d, "DELTA", "PENTEST // KALI VM // OFFENSIVE")
watermark(d, 400, 480)
top_left(d, ["MODE: OFFENSIVE", "SCOPE: AUTHORIZED", "VM: KALI-LINUX"])
footer(d, ["TOOLS: NMAP BURP ZAP", "FRAMEWORK: METASPLOIT", "STATUS: STANDBY"],
          ["AUTHORIZED TESTING ONLY", "RULES OF ENGAGEMENT APPLY", "FOUO // REL TO SI-01"])
img.save(f"{OUT}/wallpaper-delta.png")
print("DELTA done")

# ECHO
img, d = base_image()
icon_box(d, W-100, 30, "ECHO")
try:
    f = ImageFont.truetype("/usr/share/fonts/TTF/JetBrainsMono-Bold.ttf", 28)
    d.text((W-96, 36), "@MSG", fill=BORDER, font=f)
except: pass
for i in range(4):
    r = 80 + i * 50
    d.arc([W//4-r, H//2-r//2, W//4+r, H//2+r//2], 200, 340, fill=GRID, width=1)
big_label(d, "ECHO", "COMMS // EMAIL // SECURE CHANNEL")
watermark(d, 500, 500)
top_left(d, ["CHANNEL: ENCRYPTED", "PROTOCOL: TLS 1.3", "COMMS: ACTIVE"])
footer(d, ["TELEGRAM: READY", "EMAIL: SECURE", "SIGNAL: MONITORED"],
          ["UNCLASSIFIED", "FOR OFFICIAL USE ONLY", "FOUO // REL TO SI-01"])
img.save(f"{OUT}/wallpaper-echo.png")
print("ECHO done")

print("All wallpapers generated in ~/Wallpapers/")
