---
layout: post
title:  "Building WEM widgets: custom code in a no-code application (EN)"
---

WEM is a no-code application development platform. Asked to work on widgets for a client, I entered the ecosystem. It meant learning about the the platform first to get a high-level overview. Then at each step closer to the task, I started to see familiar parts. On the first step I observed a GUI to create interaction nodes for a set of DOM elements, databases, logic and information flows. A second step deeper into the platform the nodes had their own custom widget editor, consisting of a script, layout and references to the interaction node.

To work while awaiting feedback from the client, I applied a versioning convetion. Also the WEM platform had their own 'WEMscript' so that was a thing to be figured out on the fly as well. Conditionals in WEMscript that I wrote including CSS:

`<? if (@A > @B) then ?>transform: rotateY(180deg);<? end ?>`

Using MacOS with a Chrome browser, the most unproductive thing I encountered was not being able to confidently cut/copy/paste (these) code snippets inside the WEM V3 widget editor. Which meant all characters had to be typed in manually! Tip: use another browser. 

Overall, not a bad experience as it was mostly plain JavaScript.

References (for future me):
- Video training to build your first application (go to: Training): <https://my.wem.io/>
- Documentation for understanding Widgets: <https://wem.io/documentation/reference/wemscript>
- Examples: <https://widgets.live.wem.io/>
- Forum: <https://my.wem.io/forum?categoryid=15>
