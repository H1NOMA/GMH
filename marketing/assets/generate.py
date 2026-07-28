#!/usr/bin/env python3
"""Generates the store-page asset set for Game Master's Hub (itch.io).

Design language: calm near-minimalism on deep ink, one muted amber accent,
a thin "world-web" mark (hexagon + linked nodes — the app's relationship
graph distilled), generous spacing, Roboto. No gloss, no ornament.

Run from the repo root:  python3 marketing/assets/generate.py
"""

import math
import random
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parents[2]
OUT = Path(__file__).resolve().parent
FONTS = ROOT / 'assets' / 'fonts'

INK = (16, 14, 10)
INK_TOP = (24, 21, 15)
PARCHMENT = (233, 223, 203)
DIM = (150, 138, 116)
ACCENT = (192, 138, 62)
ACCENT_SOFT = (192, 138, 62, 90)


def font(name: str, size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(str(FONTS / name), size)


def background(w: int, h: int, *, web_nodes: int = 26, seed: int = 7) -> Image.Image:
    """Ink canvas with a vertical gradient and a faint constellation web."""
    img = Image.new('RGB', (w, h), INK)
    draw = ImageDraw.Draw(img, 'RGBA')
    for y in range(h):
        t = y / h
        c = tuple(int(INK_TOP[i] + (INK[i] - INK_TOP[i]) * t) for i in range(3))
        draw.line([(0, y), (w, y)], fill=c)

    rnd = random.Random(seed)
    pts = [(rnd.uniform(0.04, 0.96) * w, rnd.uniform(0.06, 0.94) * h)
           for _ in range(web_nodes)]
    for i, (x1, y1) in enumerate(pts):
        near = sorted(pts, key=lambda p: (p[0] - x1) ** 2 + (p[1] - y1) ** 2)[1:3]
        for x2, y2 in near:
            draw.line([(x1, y1), (x2, y2)], fill=(233, 223, 203, 10), width=1)
    for x, y in pts:
        r = rnd.uniform(1.2, 2.6)
        draw.ellipse([x - r, y - r, x + r, y + r], fill=(233, 223, 203, 26))

    # Soft vignette so edges recede.
    vign = Image.new('L', (w, h), 0)
    vd = ImageDraw.Draw(vign)
    vd.ellipse([-w * 0.25, -h * 0.25, w * 1.25, h * 1.25], fill=70)
    vign = vign.filter(ImageFilter.GaussianBlur(min(w, h) // 6))
    img = Image.composite(img, Image.new('RGB', (w, h), (10, 9, 6)),
                          vign.point(lambda v: 255 - v))
    return img


def mark(size: int, *, stroke: float = None, on_alpha: bool = True) -> Image.Image:
    """The world-web mark: a thin hexagon with four linked nodes inside."""
    s = size * 4  # draw at 4x, downscale for clean thin lines
    stroke = stroke or max(2, s // 56)
    img = Image.new('RGBA', (s, s), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    cx = cy = s / 2
    R = s * 0.42

    hexpts = [(cx + R * math.cos(a), cy + R * math.sin(a))
              for a in [math.radians(60 * i - 90) for i in range(6)]]
    d.polygon(hexpts, outline=PARCHMENT + (255,), width=int(stroke))

    # Inner constellation: four nodes, five thin edges, one accent node.
    n = {
        'a': (cx - R * 0.42, cy - R * 0.18),
        'b': (cx + R * 0.38, cy - R * 0.38),
        'c': (cx + R * 0.30, cy + R * 0.40),
        'd': (cx - R * 0.16, cy + R * 0.14),
    }
    edges = [('a', 'b'), ('b', 'c'), ('a', 'd'), ('d', 'c'), ('d', 'b')]
    for p, q in edges:
        d.line([n[p], n[q]], fill=PARCHMENT + (150,), width=max(2, int(stroke * 0.55)))
    for key, (x, y) in n.items():
        r = s * (0.045 if key == 'd' else 0.03)
        color = ACCENT + (255,) if key == 'd' else PARCHMENT + (255,)
        d.ellipse([x - r, y - r, x + r, y + r], fill=color)

    img = img.resize((size, size), Image.LANCZOS)
    if on_alpha:
        return img
    base = Image.new('RGBA', (size, size), INK + (255,))
    base.alpha_composite(img)
    return base


def text_size(d: ImageDraw.ImageDraw, s: str, f) -> tuple:
    box = d.textbbox((0, 0), s, font=f)
    return box[2] - box[0], box[3] - box[1]


def spaced(s: str, sep: str = '  ') -> str:
    return (sep.join(list(s))).upper()


def wordmark(draw, cx, y, *, title_px, sub_px=None, tracking_title=None):
    """Centered wordmark: GAME MASTER'S HUB (+ optional tagline)."""
    ft = font('Roboto-Medium.ttf', title_px)
    title = "GAME MASTER'S HUB"
    # letterspacing: draw per character
    track = tracking_title if tracking_title is not None else title_px * 0.32
    widths = [draw.textlength(ch, font=ft) for ch in title]
    total = sum(widths) + track * (len(title) - 1)
    x = cx - total / 2
    for ch, wch in zip(title, widths):
        draw.text((x, y), ch, font=ft, fill=PARCHMENT)
        x += wch + track
    out_h = title_px
    if sub_px:
        fs = font('Roboto-Regular.ttf', sub_px)
        sub = 'WORLDBUILDING  &  CAMPAIGN  MANAGER'
        sw = draw.textlength(sub, font=fs)
        draw.text((cx - sw / 2, y + title_px * 1.9), sub, font=fs, fill=DIM)
        # accent rule between title and tagline
        rule_w = total * 0.28
        ry = y + title_px * 1.55
        draw.line([(cx - rule_w / 2, ry), (cx + rule_w / 2, ry)],
                  fill=ACCENT, width=max(2, title_px // 18))
        out_h = title_px * 2.4 + sub_px
    return out_h


def capsule(w, h, name, *, mark_ratio=0.42, title_px=None, sub=False,
            seed=7, layout='center'):
    img = background(w, h, seed=seed, web_nodes=max(16, (w * h) // 60000))
    d = ImageDraw.Draw(img, 'RGBA')
    m_size = int(h * mark_ratio)
    m = mark(m_size)
    title_px = title_px or max(18, h // 12)

    if layout == 'center':
        mx = (w - m_size) // 2
        my = int(h * 0.16)
        img.paste(m, (mx, my), m)
        wordmark(d, w / 2, my + m_size + h * 0.07,
                 title_px=title_px, sub_px=int(title_px * 0.38) if sub else None)
    elif layout == 'left':
        mx = int(h * 0.18)
        my = (h - m_size) // 2
        img.paste(m, (mx, my), m)
        ft_x = mx + m_size + int(h * 0.14)
        ft = font('Roboto-Medium.ttf', title_px)
        d.text((ft_x, h / 2 - title_px * (1.25 if sub else 0.62)),
               "GAME MASTER'S HUB", font=ft, fill=PARCHMENT)
        if sub:
            fs = font('Roboto-Regular.ttf', int(title_px * 0.5))
            d.text((ft_x, h / 2 + title_px * 0.25),
                   'Worldbuilding & Campaign Manager', font=fs, fill=DIM)
            d.line([(ft_x, h / 2 - title_px * 0.05),
                    (ft_x + title_px * 4.2, h / 2 - title_px * 0.05)],
                   fill=ACCENT, width=max(2, title_px // 14))
    img.save(OUT / name)
    print(name, f'{w}x{h}')


def main():
    OUT.mkdir(exist_ok=True)

    # App icon / community avatar (square, mark only).
    for size, name in [(512, 'icon_512.png'), (184, 'avatar_184.png')]:
        img = background(size, size, seed=11, web_nodes=10)
        m = mark(int(size * 0.72))
        img.paste(m, ((size - m.width) // 2, (size - m.height) // 2), m)
        img.save(OUT / name)
        print(name, f'{size}x{size}')

    # Transparent logo (store + library logo slot).
    w, h = 1280, 720
    img = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    m_size = 300
    m = mark(m_size)
    img.paste(m, ((w - m_size) // 2, 90), m)
    wordmark(d, w / 2, 90 + m_size + 60, title_px=64, sub_px=24)
    img.save(OUT / 'logo_1280x720.png')
    print('logo_1280x720.png (transparent)')

    # Store-page art. itch.io sizes: cover 630x500 (game card),
    # banner up to 960x400 on the page header; the rest are generic
    # marketing crops (social preview, wide header, tall poster).
    capsule(630, 500, 'cover_630x500.png',
            layout='center', mark_ratio=0.38, title_px=44, sub=True, seed=8)
    capsule(960, 400, 'banner_960x400.png',
            layout='left', mark_ratio=0.52, title_px=52, sub=True, seed=3)
    capsule(1280, 720, 'social_1280x720.png',
            layout='center', mark_ratio=0.40, title_px=64, sub=True, seed=8)
    capsule(920, 430, 'header_920x430.png',
            layout='left', mark_ratio=0.52, title_px=54, sub=True, seed=3)
    capsule(600, 900, 'poster_600x900.png',
            layout='center', mark_ratio=0.34, title_px=36, sub=True, seed=10)


if __name__ == '__main__':
    main()
