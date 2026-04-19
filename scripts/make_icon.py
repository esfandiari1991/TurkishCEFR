#!/usr/bin/env python3
"""
Generate the TurkishCEFR macOS app icon.

Design brief
------------
A macOS-squircle tile in a rich Turkish-crimson → orchid → violet
gradient. A single hero glyph — the Turkish letter "Ş" — is set in a
refined serif, bright and slightly weighted, with a matching crescent
arc tucked into the negative space on the upper right. The whole tile
carries a soft glossy highlight and a quiet inner stroke for depth.

No text clutter. Premium, iconic, recognisable at 32px.

Usage (from repo root):
    python3 scripts/make_icon.py
"""
from __future__ import annotations

from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter, ImageFont

REPO_ROOT = Path(__file__).resolve().parent.parent
ASSETS_DIR = REPO_ROOT / "TurkishCEFR" / "Assets.xcassets"
APPICON_DIR = ASSETS_DIR / "AppIcon.appiconset"
APPICON_DIR.mkdir(parents=True, exist_ok=True)

MASTER = 1024

SIZES = [
    (16, 1, 16),  (16, 2, 32),
    (32, 1, 32),  (32, 2, 64),
    (128, 1, 128), (128, 2, 256),
    (256, 1, 256), (256, 2, 512),
    (512, 1, 512), (512, 2, 1024),
]

FONT_CANDIDATES = [
    "/usr/share/fonts/truetype/dejavu/DejaVuSerif-Bold.ttf",
    "/usr/share/fonts/truetype/liberation/LiberationSerif-Bold.ttf",
    "/usr/share/fonts/truetype/noto/NotoSerif-Bold.ttf",
    "/System/Library/Fonts/NewYork.ttf",
    "/Library/Fonts/Georgia.ttf",
]


def find_font(size: int) -> ImageFont.ImageFont:
    for path in FONT_CANDIDATES:
        try:
            return ImageFont.truetype(path, size)
        except OSError:
            continue
    return ImageFont.load_default()


def squircle_mask(size: int, radius_frac: float = 0.2237) -> Image.Image:
    mask = Image.new("L", (size, size), 0)
    d = ImageDraw.Draw(mask)
    r = int(size * radius_frac)
    d.rounded_rectangle((0, 0, size - 1, size - 1), radius=r, fill=255)
    return mask


def lerp(a, b, t):
    return tuple(int(a[i] * (1 - t) + b[i] * t) for i in range(3))


def diagonal_gradient(size: int, stops: list[tuple[float, tuple[int, int, int]]]) -> Image.Image:
    """
    Multi-stop diagonal gradient (top-left → bottom-right).
    `stops` is a list of (t, (r,g,b)) sorted by t in [0, 1].
    """
    img = Image.new("RGB", (size, size))
    px = img.load()
    stops = sorted(stops, key=lambda s: s[0])
    for y in range(size):
        for x in range(size):
            t = ((x + y) / (2 * (size - 1)))
            # find surrounding stops
            lo = stops[0]
            hi = stops[-1]
            for i in range(len(stops) - 1):
                if stops[i][0] <= t <= stops[i + 1][0]:
                    lo, hi = stops[i], stops[i + 1]
                    break
            if hi[0] == lo[0]:
                color = lo[1]
            else:
                local = (t - lo[0]) / (hi[0] - lo[0])
                local = local * local * (3 - 2 * local)  # smoothstep
                color = lerp(lo[1], hi[1], local)
            px[x, y] = color
    return img


def glow_circle(size: int, center: tuple[float, float],
                radius: int, color: tuple[int, int, int, int]) -> Image.Image:
    layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    cx, cy = center
    d.ellipse((cx - radius, cy - radius, cx + radius, cy + radius), fill=color)
    layer = layer.filter(ImageFilter.GaussianBlur(radius=radius * 0.6))
    return layer


def crescent(size: int) -> Image.Image:
    """A soft white crescent in the upper-right quadrant."""
    layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)

    cx, cy = int(size * 0.78), int(size * 0.22)
    r = int(size * 0.14)
    d.ellipse((cx - r, cy - r, cx + r, cy + r), fill=(255, 255, 255, 150))

    cut = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    cd = ImageDraw.Draw(cut)
    off = int(r * 0.42)
    cd.ellipse(
        (cx - r + off, cy - r - int(r * 0.05),
         cx + r + off, cy + r - int(r * 0.05)),
        fill=(0, 0, 0, 255),
    )
    # Subtract the cut from the disc using a paste-with-mask dance
    result = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    result.paste(layer, (0, 0))
    # Invert cut into alpha and apply
    alpha = result.split()[3]
    cut_alpha = cut.split()[3]
    new_alpha = Image.eval(cut_alpha, lambda v: 255 - v)
    combined = ImageFilter.GaussianBlur(radius=size * 0.003)
    alpha = Image.merge("L", [alpha]).point(lambda v: v)
    # PIL doesn't have a direct subtract-alpha op, so compose via masks:
    mask_alpha = Image.new("L", (size, size), 0)
    mask_alpha.paste(new_alpha, (0, 0))
    # apply: take original layer RGB, multiply alpha by mask_alpha/255
    orig_alpha = layer.split()[3]
    combined_alpha = Image.eval(orig_alpha, lambda v: v)
    # multiply combined_alpha with (255 - cut_alpha)/255
    final_alpha = Image.new("L", (size, size), 0)
    fa = final_alpha.load()
    oa = orig_alpha.load()
    ca = cut_alpha.load()
    for y in range(size):
        for x in range(size):
            fa[x, y] = int(oa[x, y] * (255 - ca[x, y]) / 255)
    final = Image.merge("RGBA",
                        (layer.split()[0], layer.split()[1], layer.split()[2], final_alpha))
    final = final.filter(ImageFilter.GaussianBlur(radius=size * 0.003))
    return final


def draw_letter(canvas: Image.Image, size: int) -> None:
    font = find_font(int(size * 0.66))
    text = "Ş"

    tmp = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    td = ImageDraw.Draw(tmp)
    bbox = td.textbbox((0, 0), text, font=font)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    # Slight left offset so the optical centre with the crescent feels balanced.
    x = (size - tw) / 2 - bbox[0] - size * 0.01
    y = (size - th) / 2 - bbox[1] - size * 0.02

    # Deep drop-shadow
    shadow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.text((x + size * 0.006, y + size * 0.018), text,
            fill=(30, 0, 20, 210), font=font)
    shadow = shadow.filter(ImageFilter.GaussianBlur(radius=size * 0.022))
    canvas.alpha_composite(shadow)

    # Main letter with a very faint inner gradient (top brighter than bottom)
    letter_layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    ImageDraw.Draw(letter_layer).text(
        (x, y), text, fill=(255, 252, 248, 255), font=font
    )
    # subtle vertical shading
    shade = Image.new("L", (size, size), 0)
    sh = shade.load()
    for yy in range(size):
        t = yy / (size - 1)
        sh[0, yy] = int(0 + 40 * t)
    shade = shade.resize((size, size))
    letter_layer.putalpha(
        Image.eval(letter_layer.split()[3], lambda v: min(255, int(v)))
    )
    canvas.alpha_composite(letter_layer)


def glossy_highlight(canvas: Image.Image, size: int) -> None:
    layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    d.ellipse(
        (int(-size * 0.20), int(-size * 0.62),
         int(size * 1.20), int(size * 0.32)),
        fill=(255, 255, 255, 40),
    )
    layer = layer.filter(ImageFilter.GaussianBlur(radius=size * 0.025))
    canvas.alpha_composite(layer)


def inner_stroke(canvas: Image.Image, size: int) -> None:
    r = int(size * 0.2237)
    stroke = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    sd = ImageDraw.Draw(stroke)
    sd.rounded_rectangle(
        (2, 2, size - 3, size - 3), radius=r,
        outline=(255, 255, 255, 36), width=max(2, size // 320),
    )
    canvas.alpha_composite(stroke)


def make_master(size: int = MASTER) -> Image.Image:
    # Vibrant gradient — coral-crimson → magenta → deep orchid.
    grad = diagonal_gradient(size, [
        (0.00, (255, 108, 104)),   # warm coral (top-left)
        (0.35, (235,  55,  95)),   # crimson
        (0.70, (180,  35, 115)),   # magenta
        (1.00, (105,  30, 120)),   # deep orchid (bottom-right)
    ]).convert("RGBA")

    # Soft glow behind the letter for extra depth.
    grad.alpha_composite(
        glow_circle(size, (size * 0.5, size * 0.55),
                    int(size * 0.42), (255, 190, 170, 90))
    )

    # Crescent
    grad.alpha_composite(crescent(size))

    # Glossy highlight sweep
    glossy_highlight(grad, size)

    # Hero letter
    draw_letter(grad, size)

    # Clip to squircle
    mask = squircle_mask(size)
    out = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    out.paste(grad, (0, 0), mask=mask)

    # Inner stroke for polish
    inner_stroke(out, size)

    return out


def main() -> None:
    master = make_master(MASTER)
    # 1024 master lives *outside* the .appiconset to avoid Xcode's
    # "unassigned child" warning (macOS AppIcon stops at 512@2x).
    source_path = ASSETS_DIR / "icon_1024_source.png"
    master.save(source_path)
    print(f"Wrote {source_path}")
    for pt, scale, px in SIZES:
        name = f"icon_{pt}x{pt}@{scale}x.png"
        master.resize((px, px), Image.LANCZOS).save(APPICON_DIR / name)
        print(f"  {name}")


if __name__ == "__main__":
    main()
