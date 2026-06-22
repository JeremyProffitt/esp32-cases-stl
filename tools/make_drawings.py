#!/usr/bin/env python3
"""Generate engineering drawing sheets for the TTGO case components.

Self-contained: renders the orthographic line-art views + a shaded isometric
via OpenSCAD, then composes a dimensioned multi-view sheet per component.

Outputs <build>/<part>_drawing.png  (default build dir: ../build).

Requires: OpenSCAD on PATH (or $OPENSCAD), Python + Pillow.
Run from anywhere:  python tools/make_drawings.py
"""
import os, sys, math, shutil, subprocess
from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TOOLS = os.path.join(ROOT, "tools")
BUILD = os.environ.get("BUILD_DIR", os.path.join(ROOT, "build"))
TMP = os.path.join(BUILD, "_diag")

BG = (248, 248, 248); INK = (30, 30, 30); DIM = (180, 30, 30)


# ----------------------------------------------------------------------------- specs
# Per-view geometry uses model mm with origin at the part's min-corner:
#   u = horizontal mm (left->right), v = vertical mm (bottom->top).
SPECS = {
    "ttgo_body": {
        "part_key": "body",
        "title": "TTGO-TM ESP32 (TMusic) - FRONT BEZEL",
        "project": "esp32-cases-stl", "part": "ttgo_body (parametric)",
        "material": "PLA / PETG", "date": "2026-06-22",
        "views": {
            "FRONT": {"w_mm": 76.2, "h_mm": 15.0, "wlbl": "WIDTH X",
                      "dims": [{"axis": "h", "a": 8.5, "b": 19.5, "at": 9.5, "text": "11"},
                               {"axis": "v", "a": 2, "b": 8, "at": 24, "text": "6"}]},
            "TOP": {"w_mm": 76.2, "h_mm": 49.5, "wlbl": "WIDTH X",
                    "dims": [{"axis": "h", "a": 4, "b": 48, "at": 47.5, "text": "44"},
                             {"axis": "v", "a": 4, "b": 45.5, "at": 51, "text": "41.5"}],
                    "circles": [{"u": 67, "v": 14, "text": "button " + chr(0xD8) + "5"}]},
            "RIGHT": {"w_mm": 49.5, "h_mm": 15.0, "wlbl": "DEPTH Y"},
        },
        "details": [("Overall (W x D x H)", "76.2 x 49.5 x 15"), ("Top face plate", "3"),
                    ("Wall thickness", "2.5"), ("Display window", "44 x 41.5"),
                    ("Finger/speaker slots", "5x  2.4 x 9  @ 4.6"), ("Button hole", chr(0xD8) + " 5"),
                    ("Side ports", "2x  11 x 6"), ("Outer corner radius", "R 3")],
        "notes": ["Line-art = OpenSCAD projection outlines (true scale).",
                  "Parametric APPROXIMATION; exact mesh in ttgo_body_mesh.scad."],
    },
    "ttgo_cap": {
        "part_key": "cap",
        "title": "TTGO-TM ESP32 (TMusic) - BASE TRAY",
        "project": "esp32-cases-stl", "part": "ttgo_cap (parametric)",
        "material": "PLA / PETG", "date": "2026-06-22",
        "views": {
            "FRONT": {"w_mm": 76.2, "h_mm": 22.15, "wlbl": "WIDTH X"},
            "TOP": {"w_mm": 76.2, "h_mm": 49.5, "wlbl": "WIDTH X"},
            "RIGHT": {"w_mm": 49.5, "h_mm": 22.15, "wlbl": "DEPTH Y"},
        },
        "details": [("Overall (W x D x H)", "76.2 x 49.5 x 22.15"), ("Wall thickness", "2.5"),
                    ("Floor thickness", "2.5"), ("Rim rabbet (step x h)", "1.5 x 5"),
                    ("PCB rails", "2x  30 x 1.5 x 1.5"), ("Corner notch", "6 wide x 5 deep"),
                    ("Outer corner radius", "R 3")],
        "notes": ["Deep base tray; bezel skirt seats into the rim rabbet.",
                  "Parametric APPROXIMATION; exact mesh in ttgo_cap_mesh.scad."],
    },
}


# ----------------------------------------------------------------------------- openscad
def find_openscad():
    cand = os.environ.get("OPENSCAD") or shutil.which("openscad")
    if cand and (os.path.isfile(cand) or shutil.which(cand)):
        return cand
    for p in [r"C:\Program Files\OpenSCAD\openscad.exe",
              r"C:\Program Files (x86)\OpenSCAD\openscad.exe",
              "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"]:
        if os.path.isfile(p):
            return p
    return "openscad"


OSCAD = find_openscad()


def render(scad, out, camera, defines, size=(560, 470)):
    cmd = [OSCAD, "-o", out, "--projection=o", "--camera=" + camera,
           "--viewall", "--autocenter", f"--imgsize={size[0]},{size[1]}",
           "--colorscheme=Tomorrow"]
    for k, v in defines.items():
        cmd += ["-D", f'{k}={v}']
    cmd.append(scad)
    subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


# ----------------------------------------------------------------------------- drawing helpers
def font(sz, bold=False):
    for n in ((["arialbd.ttf"] if bold else ["arial.ttf"]) +
              (["DejaVuSans-Bold.ttf"] if bold else ["DejaVuSans.ttf"])):
        try:
            return ImageFont.truetype(n, sz)
        except Exception:
            pass
    return ImageFont.load_default()


def part_bbox(im, pad=1):
    px = im.convert("RGB").load(); W, H = im.size
    minx, miny, maxx, maxy = W, H, 0, 0
    for y in range(H):
        for x in range(W):
            r, g, b = px[x, y]
            if abs(r - BG[0]) + abs(g - BG[1]) + abs(b - BG[2]) > 30:
                minx = min(minx, x); maxx = max(maxx, x)
                miny = min(miny, y); maxy = max(maxy, y)
    if minx > maxx:
        return (0, 0, W, H)
    return (max(0, minx - pad), max(0, miny - pad), min(W, maxx + pad), min(H, maxy + pad))


def arrow(d, p0, p1, head=6, width=2):
    d.line([p0, p1], fill=DIM, width=width)
    for p, q in ((p0, p1), (p1, p0)):
        a = math.atan2(q[1] - p[1], q[0] - p[0])
        for s in (-0.5, 0.5):
            d.line([p, (p[0] + head * math.cos(a + s), p[1] + head * math.sin(a + s))], fill=DIM, width=width)


def htext(d, cx, cy, txt, fnt):
    tw = d.textlength(txt, font=fnt)
    d.rectangle([cx - tw / 2 - 3, cy - 9, cx + tw / 2 + 3, cy + 10], fill=BG)
    d.text((cx - tw / 2, cy - 8), txt, fill=DIM, font=fnt)


class VB:
    def __init__(s, bx0, by0, bx1, by1, w, h):
        s.bx0, s.by0, s.bx1, s.by1, s.w, s.h = bx0, by0, bx1, by1, w, h

    def x(s, u): return s.bx0 + (u / s.w) * (s.bx1 - s.bx0)
    def y(s, v): return s.by1 - (v / s.h) * (s.by1 - s.by0)


def vdim(cell, vb, v0, v1, u_at, txt, fnt):
    d = ImageDraw.Draw(cell); x = vb.x(u_at); y0, y1 = vb.y(v0), vb.y(v1)
    arrow(d, (x, y0), (x, y1))
    th = Image.new("RGBA", (int(d.textlength(txt, font=fnt)) + 6, 22), (0, 0, 0, 0))
    ImageDraw.Draw(th).text((3, 1), txt, fill=DIM, font=fnt)
    th = th.rotate(90, expand=True)
    cell.paste(Image.new("RGB", th.size, BG), (int(x) - th.width // 2 - 1, int((y0 + y1) / 2) - th.height // 2))
    cell.paste(th, (int(x) - th.width // 2, int((y0 + y1) / 2) - th.height // 2), th)


def view_cell(img_path, sv, cw, ch, label):
    cell = Image.new("RGB", (cw, ch), BG); d = ImageDraw.Draw(cell)
    img = Image.open(img_path).convert("RGB").transpose(Image.FLIP_LEFT_RIGHT)  # undo camera X-mirror
    ml, mr, mt, mb = 64, 40, 36, 66
    aw, ah = cw - ml - mr, ch - mt - mb
    img.thumbnail((aw, ah))
    ox, oy = ml + (aw - img.width) // 2, mt + (ah - img.height) // 2
    cell.paste(img, (ox, oy))
    bx0, by0, bx1, by1 = part_bbox(img)
    bx0 += ox; bx1 += ox; by0 += oy; by1 += oy
    w, h = sv["w_mm"], sv["h_mm"]; vb = VB(bx0, by0, bx1, by1, w, h)
    fnt = font(15); fnt_s = font(12)
    d.text((10, 6), label, fill=INK, font=font(16, True))
    # overall width
    yb = by1 + 30
    d.line([(bx0, by1 + 3), (bx0, yb + 5)], fill=DIM, width=1); d.line([(bx1, by1 + 3), (bx1, yb + 5)], fill=DIM, width=1)
    arrow(d, (bx0, yb), (bx1, yb)); htext(d, (bx0 + bx1) / 2, yb, f"{w:g}", fnt)
    d.text(((bx0 + bx1) / 2 - 24, yb + 12), sv.get("wlbl", ""), fill=(120, 120, 120), font=fnt_s)
    # overall height
    xl = bx0 - 26
    d.line([(bx0 - 3, by0), (xl - 5, by0)], fill=DIM, width=1); d.line([(bx0 - 3, by1), (xl - 5, by1)], fill=DIM, width=1)
    vdim(cell, vb, 0, h, (xl - bx0) / (bx1 - bx0) * w if (bx1 - bx0) else 0, f"{h:g}", fnt)
    # detail leaders
    for dd in sv.get("dims", []):
        if dd["axis"] == "h":
            x0, x1, y = vb.x(dd["a"]), vb.x(dd["b"]), vb.y(dd["at"])
            arrow(d, (x0, y), (x1, y)); htext(d, (x0 + x1) / 2, y, dd["text"], fnt)
        else:
            vdim(cell, vb, dd["a"], dd["b"], dd["at"], dd["text"], fnt)
    for c in sv.get("circles", []):
        cx, cy = vb.x(c["u"]), vb.y(c["v"])
        d.line([(cx, cy), (cx + 8, cy)], fill=DIM, width=1)
        d.text((cx + 10, cy - 8), c["text"], fill=DIM, font=fnt)
    return cell


def wrap(t, w):
    words, line, out = t.split(), "", []
    for x in words:
        if len(line) + len(x) + 1 > w:
            out.append(line); line = x
        else:
            line = (line + " " + x).strip()
    if line:
        out.append(line)
    return out or [""]


def compose(name, spec):
    SW, SH = 1600, 1150
    sheet = Image.new("RGB", (SW, SH), "white"); d = ImageDraw.Draw(sheet)
    d.rectangle([12, 12, SW - 13, SH - 13], outline=INK, width=3)
    d.rectangle([20, 20, SW - 21, SH - 21], outline=INK, width=1)
    d.text((34, 30), spec["title"], fill=INK, font=font(30, True))
    d.line([(24, 74), (SW - 24, 74)], fill=INK, width=1)
    cw, ch = 520, 480; x0, y0 = 26, 86
    labels = {"FRONT": "FRONT  (looking +Y)", "TOP": "TOP  (looking -Z)", "RIGHT": "RIGHT SIDE  (looking +X)"}
    for i, k in enumerate(["FRONT", "TOP", "RIGHT"]):
        cell = view_cell(os.path.join(TMP, f"{name}_2d_{k.lower()}.png"), spec["views"][k], cw, ch, labels[k])
        px, py = x0 + i * cw, y0
        sheet.paste(cell, (px, py))
        d.rectangle([px, py, px + cw - 1, py + ch - 1], outline=(170, 170, 170), width=1)
    iso_y = y0 + ch + 8; iso_w, iso_h = cw * 2, SH - iso_y - 30
    ic_im = Image.new("RGB", (iso_w, iso_h), BG); ic = ImageDraw.Draw(ic_im)
    iso = Image.open(os.path.join(TMP, f"{name}_iso.png")).convert("RGB"); iso.thumbnail((iso_w - 60, iso_h - 60))
    ic_im.paste(iso, ((iso_w - iso.width) // 2, 40 + (iso_h - 50 - iso.height) // 2))
    ic.text((12, 8), "ISOMETRIC", fill=INK, font=font(16, True))
    sheet.paste(ic_im, (x0, iso_y))
    d.rectangle([x0, iso_y, x0 + iso_w - 1, iso_y + iso_h - 1], outline=(170, 170, 170), width=1)
    tbx, tby = x0 + 2 * cw, iso_y; tbw, tbh = cw, SH - iso_y - 30
    d.rectangle([tbx, tby, tbx + tbw - 1, tby + tbh - 1], outline=INK, width=2)
    ry = tby + 10
    for lab, val in [("PROJECT", spec.get("project", "")), ("PART", spec["part"]),
                     ("MATERIAL", spec.get("material", "")), ("UNITS", "millimetres"),
                     ("DATE", spec.get("date", ""))]:
        d.text((tbx + 12, ry), lab, fill=(120, 120, 120), font=font(12, True))
        d.text((tbx + 120, ry), str(val), fill=INK, font=font(14)); ry += 23
        d.line([(tbx + 8, ry - 4), (tbx + tbw - 8, ry - 4)], fill=(215, 215, 215), width=1)
    ry += 6
    d.text((tbx + 12, ry), "DETAIL DIMENSIONS  (mm)", fill=INK, font=font(13, True)); ry += 22
    for feat, val in spec.get("details", []):
        d.text((tbx + 14, ry), feat, fill=(90, 90, 90), font=font(13))
        d.text((tbx + 250, ry), val, fill=INK, font=font(13)); ry += 19
    ry += 6
    for n in spec.get("notes", []):
        for ln in wrap(n, 52):
            d.text((tbx + 14, ry), ln, fill=(90, 90, 90), font=font(12)); ry += 16
    out = os.path.join(BUILD, f"{name}_drawing.png")
    sheet.save(out); print("wrote", os.path.relpath(out, ROOT))


def main():
    os.makedirs(TMP, exist_ok=True)
    draw2d = os.path.join(TOOLS, "draw2d.scad"); view3d = os.path.join(TOOLS, "view3d.scad")
    for name, spec in SPECS.items():
        pk = spec["part_key"]
        for v in ("top", "front", "right"):
            render(draw2d, os.path.join(TMP, f"{name}_2d_{v}.png"),
                   "0,0,0,0,0,0", {"part": f'"{pk}"', "view": f'"{v}"'})
        render(view3d, os.path.join(TMP, f"{name}_iso.png"),
               "0,0,0,55,0,25", {"part": f'"{pk}"'})
        compose(name, spec)


if __name__ == "__main__":
    main()
