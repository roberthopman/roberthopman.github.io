import os

GREEN="#4f8a6b"; ORANGE="#e08a3c"; GREY="#777"; LABEL="#555"; LINE="#c9c9c9"; FRAME="#9aa8b5"
W=1000; TOP=88; STEP=44; SELF_W=76; SELF_H=26; GUTTER=128
FRAME_PAD_TOP=40; FRAME_PAD_BOT=16; FRAME_X=46

actors=["You","Loop","Code","Probe"]
X={a: GUTTER+92+i*224 for i,a in enumerate(actors)}

FRAMES={
 "A":"loop [until it is fast and deterministic]",
 "B":"loop [until every element is load bearing]",
 "C":"loop [for each ranked cause, until one is confirmed]",
}

# (phase, frame, from, to, label, colour, dashed)
MSGS=[
 ("1. Build the loop", None,"You","Loop","write one command that can go red",      GREY,  False),
 ("1. Build the loop", "A", "Loop","Loop","tighten: faster, sharper, repeatable",  GREY,  False),
 ("2. Reproduce",      None,"Loop","Code","run it",                                GREY,  False),
 ("2. Reproduce",      None,"Code","Loop","wrong result",                          ORANGE,True),
 ("2. Reproduce",      None,"Loop","You","RED, and it is the reported symptom",     ORANGE,True),
 ("2. Reproduce",      "B", "You","Loop","cut one element, run it again",          GREY,  False),
 ("2. Reproduce",      "B", "Loop","You","still RED, so keep the cut",             GREY,  True),
 ("3. Hypothesise",    None,"You","You","rank 3 to 5 falsifiable causes",          GREY,  False),
 ("4. Instrument",     "C", "You","Probe","set one probe on the top cause",     GREY,  False),
 ("4. Instrument",     "C", "Probe","Code","observe one value"      ,              GREY,  False),
 ("4. Instrument",     "C", "Code","Probe","the actual value"          ,       GREY,  True),
 ("4. Instrument",     "C", "Probe","You","rejected, take the next cause",      ORANGE,True),
 ("4. Instrument",     None,"Probe","You","cause 2 is confirmed",               GREEN, True),
 ("5. Fix",            None,"You","Code","add the regression test, then fix",      GREEN, False),
 ("5. Fix",            None,"You","Loop","run the loop again",                     GREY,  False),
 ("5. Fix",            None,"Loop","You","GREEN",                                  GREEN, True),
 ("6. Clean up",       None,"You","Code","remove every probe",                     GREY,  False),
]

# layout: assign a y to every message, a band to every phase, a box to every frame
rows=[]; bands=[]; boxes={}; y=TOP+34; prev_frame=None
for phase,fr,a,b,text,col,dash in MSGS:
    if fr!=prev_frame:
        if prev_frame: boxes[prev_frame][2]=y-STEP+FRAME_PAD_BOT
        if fr: y+=FRAME_PAD_TOP; boxes[fr]=[fr,y-FRAME_PAD_TOP+6,0,set()]
        prev_frame=fr
    if not bands or bands[-1][0]!=phase: bands.append([phase,y-STEP//2,0])
    if fr:
        boxes[fr][3] |= {X[a], X[b]}
        if a==b: boxes[fr][3].add(X[a]+SELF_W+10)
    rows.append((a,b,text,col,dash,y))
    y += STEP+SELF_H if a==b else STEP
    bands[-1][2]=y-STEP//2
if prev_frame: boxes[prev_frame][2]=y-STEP+FRAME_PAD_BOT
H=y-6

def esc(s): return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")

s=[f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" font-family="Helvetica,Arial,sans-serif">']
s.append('<defs>')
for n,c in (("g",GREEN),("o",ORANGE),("y",GREY)):
    s.append(f'<marker id="a{n}" markerUnits="userSpaceOnUse" markerWidth="11" markerHeight="11" '
             f'refX="9" refY="4" orient="auto"><path d="M0,0 L9,4 L0,8 Z" fill="{c}"/></marker>')
s.append('</defs>')

for i,(phase,y0,y1) in enumerate(bands):
    if i%2==0: s.append(f'<rect x="0" y="{y0}" width="{W}" height="{y1-y0}" fill="#f7f7f5"/>')
    s.append(f'<text x="14" y="{y0+20}" font-size="12" fill="{LABEL}" font-weight="bold">{esc(phase)}</text>')

for a in actors:
    x=X[a]
    s.append(f'<line x1="{x}" y1="{TOP}" x2="{x}" y2="{H-10}" stroke="{LINE}" stroke-width="1.2" stroke-dasharray="4,5"/>')
    s.append(f'<rect x="{x-62}" y="{TOP-38}" width="124" height="32" rx="4" fill="#fff" stroke="{GREY}" stroke-width="1.2"/>')
    s.append(f'<text x="{x}" y="{TOP-17}" font-size="13" fill="#333" text-anchor="middle">{esc(a)}</text>')

# loop frames, drawn behind the messages they contain
for key,y0,y1,parts in boxes.values():
    x0=min(parts)-FRAME_X; x1=max(parts)+FRAME_X
    text=FRAMES[key]; tw=len(text)*5.9+16
    x1=max(x1, x0+tw+10)
    s.append(f'<rect x="{x0}" y="{y0}" width="{x1-x0}" height="{y1-y0}" fill="none" stroke="{FRAME}" '
             f'stroke-width="1.2" stroke-dasharray="5,4"/>')
    s.append(f'<rect x="{x0}" y="{y0}" width="{tw:.0f}" height="18" fill="#fff" stroke="{FRAME}" stroke-width="1.2"/>')
    s.append(f'<text x="{x0+8}" y="{y0+13}" font-size="10.5" fill="{FRAME}">{esc(text)}</text>')

for a,b,text,col,dash,y in rows:
    da=' stroke-dasharray="6,4"' if dash else ''
    mk={GREEN:"ag",ORANGE:"ao",GREY:"ay"}[col]
    if a==b:
        x=X[a]
        s.append(f'<path d="M{x},{y} L{x+SELF_W},{y} L{x+SELF_W},{y+SELF_H} L{x+9},{y+SELF_H}" fill="none" '
                 f'stroke="{col}" stroke-width="1.6"{da} marker-end="url(#{mk})"/>')
        s.append(f'<text x="{x+SELF_W+10}" y="{y+SELF_H-4}" font-size="12" fill="{LABEL}">{esc(text)}</text>')
    else:
        x1,x2=X[a],X[b]; d=1 if x2>x1 else -1
        s.append(f'<line x1="{x1}" y1="{y}" x2="{x2-9*d}" y2="{y}" stroke="{col}" stroke-width="1.6"{da} '
                 f'marker-end="url(#{mk})"/>')
        s.append(f'<text x="{(x1+x2)/2}" y="{y-7}" font-size="12" fill="{LABEL}" text-anchor="middle">{esc(text)}</text>')

s.append('</svg>')
out=os.path.join(os.path.dirname(__file__), "diagnose-a-bug-sequence.svg")
open(out,"w").write("\n".join(s))
print(f"wrote {out} ({W}x{H})")
