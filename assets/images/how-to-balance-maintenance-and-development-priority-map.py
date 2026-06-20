#!/usr/bin/env python3
"""Priority map for "How to balance maintenance and development?".

A two-axis map of the three maintenance categories: how soon the work fails
(urgency, x) against how confidently it can be predicted (predictability, y).
Each category sits as a card where the framework places it. Pure Python: every
coordinate is computed here and written out as SVG (no Graphviz, no runtime
dependency). Matches the site palette used by the other recap diagrams.

Generate (writes the SVG next to this script):
    python3 assets/images/how-to-balance-maintenance-and-development-priority-map.py

Preview as PNG:
    rsvg-convert -w 950 -o /tmp/maintenance-map.png \
        assets/images/how-to-balance-maintenance-and-development-priority-map.svg
"""
from pathlib import Path

GREEN = "#4f8a6b"
ORANGE = "#e08a3c"
INK = "#333333"
MUTED = "#888888"

WIDTH = 760
HEIGHT = 470

X0 = 92          # left axis
X1 = 732         # right edge of plot
Y_TOP = 44       # top of plot
Y_BASE = 410     # x axis (baseline)

CARD_W = 188
HEADER_H = 30
LINE_H = 22
CARD_H = HEADER_H + 3 * LINE_H + 12

# (top-left x, top-left y, header color, title, subtitle, meta, action)
CARDS = [
    (110, 60, GREEN, "UPCOMING & EXPECTED", "Predictable-Critical",
     "P > 0.7 · days to weeks", "▶ commit time next week"),
    (496, 60, ORANGE, "NOW", "Immediate-Critical",
     "P ≈ 1.0 · happening now", "▶ stop the bleeding"),
    (110, 278, MUTED, "UPCOMING & UNEXPECTED", "Potential-Critical",
     "P < 0.5 · weeks to months", "▶ reserve a weekly slot"),
]


def esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def card(x, y, header, title, subtitle, meta, action):
    out = []
    # outer card
    out.append(
        f'<rect x="{x}" y="{y}" width="{CARD_W}" height="{CARD_H}" rx="6" '
        f'fill="white" stroke="{header}" stroke-width="1.5"/>'
    )
    # header band (rounded top corners only)
    out.append(
        f'<path d="M{x},{y + HEADER_H} L{x},{y + 6} Q{x},{y} {x + 6},{y} '
        f'L{x + CARD_W - 6},{y} Q{x + CARD_W},{y} {x + CARD_W},{y + 6} '
        f'L{x + CARD_W},{y + HEADER_H} Z" fill="{header}"/>'
    )
    out.append(
        f'<text x="{x + CARD_W / 2}" y="{y + HEADER_H - 9}" text-anchor="middle" '
        f'fill="white" font-weight="bold" font-size="12.5">{esc(title)}</text>'
    )
    ty = y + HEADER_H + 17
    out.append(
        f'<text x="{x + 14}" y="{ty}" fill="{INK}" font-size="12.5" '
        f'font-weight="bold">{esc(subtitle)}</text>'
    )
    out.append(
        f'<text x="{x + 14}" y="{ty + LINE_H}" fill="{ORANGE}" font-size="11.5" '
        f'font-weight="bold">{esc(meta)}</text>'
    )
    out.append(
        f'<text x="{x + 14}" y="{ty + 2 * LINE_H}" fill="{INK}" '
        f'font-size="12.5">{esc(action)}</text>'
    )
    return out


def main():
    p = []
    p.append(
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {WIDTH} {HEIGHT}" '
        f'font-family="Helvetica,Arial,sans-serif">'
    )
    p.append(
        '<defs>'
        f'<marker id="axis" markerUnits="userSpaceOnUse" markerWidth="11" '
        'markerHeight="11" refX="7" refY="4" orient="auto">'
        f'<path d="M0,0 L9,4 L0,8 Z" fill="{INK}"/></marker>'
        '</defs>'
    )

    # axes
    p.append(
        f'<line x1="{X0}" y1="{Y_BASE}" x2="{X1}" y2="{Y_BASE}" stroke="{INK}" '
        f'stroke-width="1.6" marker-end="url(#axis)"/>'
    )
    p.append(
        f'<line x1="{X0}" y1="{Y_BASE}" x2="{X0}" y2="{Y_TOP - 4}" stroke="{INK}" '
        f'stroke-width="1.6" marker-end="url(#axis)"/>'
    )

    # y axis: predictability
    ymid = (Y_TOP + Y_BASE) / 2
    p.append(
        f'<text x="28" y="{ymid}" fill="{INK}" font-size="14" font-weight="bold" '
        f'text-anchor="middle" transform="rotate(-90 28 {ymid})">'
        f'predictability (P)</text>'
    )
    p.append(
        f'<text x="{X0 - 10}" y="{Y_TOP + 10}" fill="{MUTED}" font-size="12" '
        f'text-anchor="end">high</text>'
    )
    p.append(
        f'<text x="{X0 - 10}" y="{Y_BASE - 4}" fill="{MUTED}" font-size="12" '
        f'text-anchor="end">low</text>'
    )

    # x axis: urgency / time to failure
    p.append(
        f'<text x="{(X0 + X1) / 2}" y="{Y_BASE + 34}" fill="{INK}" font-size="14" '
        f'font-weight="bold" text-anchor="middle">'
        f'time to failure (urgency) &#8594;</text>'
    )
    p.append(
        f'<text x="{X0 + 4}" y="{Y_BASE + 20}" fill="{MUTED}" font-size="12">'
        f'months away</text>'
    )
    p.append(
        f'<text x="{X1}" y="{Y_BASE + 20}" fill="{MUTED}" font-size="12" '
        f'text-anchor="end">happening now</text>'
    )

    # cards
    for c in CARDS:
        p.extend(card(*c))

    p.append("</svg>")

    out = Path(__file__).with_suffix(".svg")
    out.write_text("\n".join(p) + "\n")
    print(f"wrote {out} ({WIDTH}x{HEIGHT})")


if __name__ == "__main__":
    main()
