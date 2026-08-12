#!/usr/bin/env python3
"""Recap diagram for "How to balance maintenance and development?".

A single storyline line chart: while you only ship new features, the average
time to repair bugs stays flat and low ("so far no problems"), then crosses a
tipping point and spikes ("now you have a problem"). Pure Python: every
coordinate is computed here and written out as SVG (no Graphviz, no runtime
dependency). Matches the site palette used by the other recap diagrams.

Generate (writes the SVG next to this script):
    python3 assets/images/how-to-balance-maintenance-and-development-recap.py

Preview as PNG:
    rsvg-convert -w 950 -o /tmp/maintenance-recap.png \
        assets/images/how-to-balance-maintenance-and-development-recap.svg
"""
from pathlib import Path

GREEN = "#4f8a6b"
ORANGE = "#e08a3c"
INK = "#333333"
MUTED = "#888888"

WIDTH = 780
HEIGHT = 430

# Plot area
X0 = 78          # left axis
X1 = 752         # right edge of plot
Y_TOP = 48       # top of plot
Y_BASE = 360     # x axis (baseline)

# Storyline points
FLAT = [(98, 304), (210, 300), (330, 296), (468, 288)]   # slow, invisible creep
TIP = (468, 288)                                          # the tipping point
# hockey-stick spike, as a cubic from the tipping point
SPIKE_C1 = (560, 282)
SPIKE_C2 = (628, 176)
SPIKE_END = (706, 74)


def esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


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

    # --- axes ---
    p.append(
        f'<line x1="{X0}" y1="{Y_BASE}" x2="{X1}" y2="{Y_BASE}" stroke="{INK}" '
        f'stroke-width="1.6" marker-end="url(#axis)"/>'
    )
    p.append(
        f'<line x1="{X0}" y1="{Y_BASE}" x2="{X0}" y2="{Y_TOP - 4}" stroke="{INK}" '
        f'stroke-width="1.6" marker-end="url(#axis)"/>'
    )

    # y axis label (rotated)
    p.append(
        f'<text x="26" y="{(Y_TOP + Y_BASE) / 2}" fill="{INK}" font-size="14" '
        f'font-weight="bold" text-anchor="middle" '
        f'transform="rotate(-90 26 {(Y_TOP + Y_BASE) / 2})">'
        f'average time to repair</text>'
    )
    # x axis label
    p.append(
        f'<text x="{X0}" y="{Y_BASE + 30}" fill="{INK}" font-size="14" '
        f'font-weight="bold">time, shipping only new features &#8594;</text>'
    )
    p.append(
        f'<text x="{X0}" y="{Y_BASE + 50}" fill="{MUTED}" font-size="12.5">'
        f'maintenance debt builds up, unnoticed</text>'
    )

    # --- the flat "no problems" stretch (green) ---
    flat_d = "M" + " L".join(f"{x},{y}" for x, y in FLAT)
    p.append(
        f'<path d="{flat_d}" fill="none" stroke="{GREEN}" stroke-width="3" '
        f'stroke-linecap="round" stroke-linejoin="round"/>'
    )
    # --- the spike "now a problem" stretch (orange) ---
    spike_d = (
        f'M{TIP[0]},{TIP[1]} C{SPIKE_C1[0]},{SPIKE_C1[1]} '
        f'{SPIKE_C2[0]},{SPIKE_C2[1]} {SPIKE_END[0]},{SPIKE_END[1]}'
    )
    p.append(
        f'<path d="{spike_d}" fill="none" stroke="{ORANGE}" stroke-width="3" '
        f'stroke-linecap="round"/>'
    )

    # --- tipping point marker + guide ---
    p.append(
        f'<line x1="{TIP[0]}" y1="{TIP[1] + 6}" x2="{TIP[0]}" y2="{Y_BASE}" '
        f'stroke="{MUTED}" stroke-width="1.2" stroke-dasharray="4 4"/>'
    )
    p.append(
        f'<circle cx="{TIP[0]}" cy="{TIP[1]}" r="5.5" fill="white" '
        f'stroke="{ORANGE}" stroke-width="2.4"/>'
    )
    p.append(
        f'<text x="{TIP[0]}" y="{Y_BASE - 12}" fill="{MUTED}" font-size="12.5" '
        f'font-style="italic" text-anchor="middle">tipping point</text>'
    )

    # --- callouts ---
    p.append(
        f'<text x="200" y="262" fill="{GREEN}" font-size="15" '
        f'font-weight="bold" text-anchor="middle">"so far no problems"</text>'
    )
    p.append(
        f'<text x="700" y="48" fill="{ORANGE}" font-size="15" '
        f'font-weight="bold" text-anchor="end">"now you have'
        f'<tspan x="700" dy="18">a problem"</tspan></text>'
    )

    p.append("</svg>")

    out = Path(__file__).with_suffix(".svg")
    out.write_text("\n".join(p) + "\n")
    print(f"wrote {out} ({WIDTH}x{HEIGHT})")


if __name__ == "__main__":
    main()
