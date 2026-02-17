# Foresight Compendium -- Honest UX Critique

## 1. Information Density / Cognitive Overload Per Tab

### Techniques Tab (line 1858)
The Techniques tab presents 35 technique cards in an auto-fill grid (`minmax(380px, 1fr)` at line 1886). Each collapsed card shows: name, family badge, description, pipeline role chip, leakage risk chip, and 5 complexity dots. That is 6 distinct visual elements per card before the user clicks anything.

When expanded (line 1646, `maxHeight:expanded?2000:0`), a single TechCard explodes to include: Inputs, Outputs, Assumptions, Owns, Time Scales, Best For (each as chip groups), plus Strengths (bullet list), Weaknesses (bullet list), Synergies With (chip group), Conflicts With (chip group), Related To (chip group), CLR Operators (chip group), Appears in Pipelines (chip group), and a Hilbert Space Interpretation block. That is 14 distinct content sections in a single expanded card. This is extreme -- the user has to scroll inside a card that can be 2000px tall. A single expanded ARIMA card could fill an entire laptop screen.

### Composer Tab (line 1897)
Three major sections stacked vertically: the active pipeline with pair checks, a canonical pipeline gallery (12 items in a grid), and a technique palette (35 buttons). Reasonable density when the pipeline is short, but once the pair checks section opens, the page becomes very long.

### Matrix Tab (line 2092)
The 35x35 matrix = 1225 cells in an SVG. The `cellSize` computed at line 2112 drops to 14px at full scale, making individual cells nearly impossible to distinguish or hover on accurately, especially on touch devices. The hover detail panel to the right is well designed, but the matrix itself is a wall of colored squares with no breathing room.

### Principles Tab (line 2213)
12 cards -- manageable. But each expanded card (line 1825, `maxHeight:expanded?500:0`) shows rule, safe examples, and unsafe examples in a 2-column grid. This is one of the better-balanced tabs.

### Condensed Logs Tab (line 2244)
Three heavy sections stacked: CLR Schema (10-row table), Operator Stack (22 operators with formulas, cross-references), and Stream Archetypes (6 expandable cards). The Operator Stack section alone, with all its `Used by:` cross-reference chips (line 2301-2317), creates a wall of tiny colored text. Scrolling through 22 operators is tedious because each one has nearly identical visual weight.

### Observatory Tab (line 2391)
The heaviest tab by far. It stacks: live feeds grid (11 buttons), synthetic generators grid (8 buttons), then a massive analysis section with sparkline, 12 stat cards in a grid, ACF chart, recommended techniques list, and matching pipelines list. When loaded with data, this tab easily exceeds 3000px of vertical scroll. The 12 stat cards at lines 2512-2573 are particularly dense -- they all look identical except for their labels and colors, making scanning difficult.

### Graph Tab (line 2674)
A 1000x620 SVG graph, controls bar, and two side-by-side panels (Discovered Paths + Canonical Pipelines/Percolation). The graph itself is legible, but the bottom panels compete for attention. When percolation is running, both panels are active simultaneously, splitting cognitive load.

### Causal Tab (line 3080)
Two large sections: Hilbert concepts reference (6 expandable cards plus a summary grid) and Causal Detection Lab (experiment controls + results). The results section (lines 3251-3350) shows 3 side-by-side result panels plus an interpretation panel -- 4 panels of dense statistical output. Then below, the full Technique-to-Hilbert mapping (line 3355) renders all 35 techniques in a grid, creating yet another wall of mono text.

**Verdict: The application suffers from "information maximalism." Every tab tries to show everything it can, rather than leading users through a deliberate information hierarchy. The Observatory, Condensed Logs, and Techniques tabs are the worst offenders.**


## 2. Navigation: 8 Tabs Is a Lot

The TabBar (line 1603) renders 8 equal-width tabs with `flex:1`. At the 1200px max-width container (line 3417), each tab gets roughly 145px. The font is 0.72rem monospace (line 1608), which at 11-12px is barely readable. Tab labels like "Condensed Logs" wrap or feel cramped.

**Which tabs are essential vs. could be buried?**

- **Essential (primary navigation):** Techniques, Composer, Observatory
- **Supporting (secondary, accessible via a "More" dropdown):** Matrix, Graph, Principles
- **Specialist (tertiary, deeply niche):** Causal, Condensed Logs

The current flat navigation treats the Causal inference lab (a specialist tool for Hilbert space enthusiasts) as co-equal with the Techniques catalog (the primary use case). This is a navigation hierarchy failure. A new user sees 8 equally-weighted tabs and has no idea where to start.

The tab bar also lacks any visual grouping or separator. "Techniques" and "Composer" are related (browse then build), "Matrix" and "Graph" are related (two visualizations of compatibility), and "Observatory" is standalone. None of these relationships are communicated.


## 3. Visual Hierarchy: Headings, Labels, and Data Compete

The type system uses three families:
- `display: "Georgia, serif"` (line 35) -- for section titles and metric card values
- `body: "system-ui, sans-serif"` (line 36) -- for descriptions
- `mono: "ui-monospace, 'SF Mono', monospace"` (line 34) -- for nearly everything else

The problem is that monospace dominates. Labels (`0.55rem` uppercase mono), data values (`0.72rem` mono), chips (`0.68rem` mono), badges (`0.6rem` mono), card titles (`0.88rem` display), and descriptions (`0.75rem` body) all coexist within a single card. The visual hierarchy collapses because:

1. The mono font is used for both labels AND data. A label reading "STRENGTHS" at 0.55rem mono (line 1689) sits above bullet text at 0.65rem mono (line 1693). The size difference is 1-2px -- imperceptible.

2. Section titles use `fontFamily:T.display, fontWeight:700, fontSize:"0.95rem"` (line 1575), but card titles also use `fontFamily:T.display, fontWeight:700, fontSize:"0.88rem"` (line 1630). The 0.07rem difference is invisible.

3. The MetricCard value is 1.6rem display (line 1561) -- the largest text on screen. These cards sit above the tabs and dominate visual attention, but they display static counts (35, 54, 30...) that never change. The most prominent visual element communicates the least dynamic information.


## 4. Color Usage: Epistemic Color System Creates Noise

The design token system (lines 20-31) defines 9 accent colors: blue, red, purple, green, yellow, orange, teal, silver, crimson. Each has 3 variants (base, dim, mid). That is 27 color values competing for attention.

Then the epistemic level system (lines 39-48) maps 8 levels to 8 of those colors: verified=green, asserted=orange, assumed=yellow, inferred=blue, extrapolated=crimson, aspirational=silver, invariant=purple, used=teal. These are used in the header chips (lines 3428-3435) and the footer (line 3468), but nowhere in the actual tab content. The epistemic color system exists in the chrome but serves no functional purpose within the application.

Meanwhile, the technique family colors (lines 55-65) use a different mapping: Baseline=silver, Statistical=blue, State-Space=purple, ML=orange, Deep Learning=crimson, Probabilistic=teal, Decomposition=green, Point Process=yellow, Ensemble=red. These ALSO compete with the operator category colors (lines 341-348): Level=blue, Dynamic=orange, Structure=purple, Event=crimson, Stability=green, Cross-Stream=teal.

The result: blue means "Statistical family" in one context, "Level operator" in another, and "inferred epistemic level" in a third. The color system actively misleads rather than reinforcing mental models.


## 5. Interaction Feedback

### Hover states
The global `button:hover { opacity:0.85; }` (line 3414) is the only hover feedback across the entire application. This is insufficient. Cards have `cursor:"pointer"` but no background change on hover. The matrix cells have hover via React state (line 2158), which works but has no visual transition.

### Click affordances
Nothing looks clickable except actual `<button>` elements. TechCard headers (line 1627) are `<div onClick>` with `cursor:"pointer"` but no underline, no button appearance, and no color change. The "x" buttons to remove pipeline steps (line 1950) are tiny 16x16 circles that are hard to target. Canonical pipeline buttons (line 2029-2057) are full `<button>` elements but styled to look like cards -- the user must guess they are clickable.

### Loading states
The Observatory tab has a single loading indicator: a StatusDot with text "Fetching data..." (lines 2491-2493). There is no skeleton screen, no progress bar, no animation beyond the StatusDot pulse. For API calls that can take 2-5 seconds, this is inadequate.

### Missing feedback
- No feedback when a technique is added to the pipeline (no flash, no scroll-to-pipeline)
- No feedback when percolation completes (the timer just stops)
- No feedback when clicking the compatibility matrix (it only responds to hover, not click)


## 6. Mobile / Responsive

The viewport meta tag is set (line 5: `width=device-width, initial-scale=1.0`), but the implementation is desktop-first with no breakpoints.

- The container is `maxWidth:1200` with `padding:"24px 32px 48px"` (line 3417). On mobile, 32px left+right padding wastes 64px.
- The tab bar uses `flex:1` per tab (line 1608). At 375px mobile width, 8 tabs get ~37px each -- they will either overflow or the text will be unreadable.
- Grid layouts use `minmax(380px, 1fr)` (line 1886 for techniques, 320px for composers). On mobile, these will produce a single column but individual cards are still 380px-designed with dense internal layouts.
- The Matrix SVG is 700-900px wide (line 2133). It will not fit mobile screens.
- The Graph SVG is 1000x620 (line 2675). It uses `width: "100%"` but at 375px, the 7.5px node labels become 2.8px -- completely illegible.
- Slider inputs in the Causal tab (lines 3216-3227) work on mobile but the adjacent grid layout (`minmax(160px, 1fr)`) will stack awkwardly.

**Verdict: This application is effectively desktop-only. Mobile is broken.**


## 7. Component Density: Chip/Badge Clutter

The Chip component (line 1459) is used pervasively. In the header alone (lines 3428-3435), there are 8 chips. In an expanded TechCard, a technique like ARIMA will render approximately 25-30 chips across its sections (inputs, outputs, assumptions, owns, time scales, best for, synergies, conflicts, related, operators, pipelines). Each chip includes: padding, border, background color, a 6x6 dot indicator, and mono text.

When 10+ chips cluster in a `flexWrap:"wrap"` container, the visual effect is a dense mosaic of tiny colored rectangles. The eye cannot scan this efficiently because every chip has nearly identical size and visual weight. There is no hierarchy within chip groups.

The Badge component (line 1476) is used for counts in Section headers and for numbered lists. It is a pill shape with contrasting text. At 20px height and 0.6rem font, badges are appropriately sized, but they appear adjacent to chips of nearly the same dimensions, creating confusion about what is a count vs. a label.


## 8. Data Entry: Discoverability Issues

### Sliders in Causal Tab (lines 3216-3227)
Three HTML range inputs for Delay, Noise, and Sample Size. They use browser-default styling, which on a dark theme means nearly invisible track and thumb. The sliders have no tick marks, no snap-to-value behavior, and the current value is displayed below in a separate `<div>`. A user unfamiliar with the Causal tab must read the uppercase labels, then find the slider, then read the value below -- three-step comprehension for a single control.

### Search in Techniques Tab (line 1876)
The search input is styled with `flex:"1 1 200px", minWidth:150` and has placeholder text "Search techniques..." It is the only text input in the entire application. It works well but is not visually distinguished from the Segmented control next to it -- both are in bg2 with border1 borders.

### Segmented controls (line 1584)
Used everywhere: Techniques (families), Composer (families), Matrix (families), Principles (categories), Condensed Logs (operator categories), Observatory (feed categories). These are small buttons (`0.68rem` mono) in a tight group. At 9+ options (the FAMILIES segmented has "All" + 9 families), they wrap across lines and become hard to parse. There is no visual distinction between "All" and the specific filters.


## 9. The Dark Theme: Contrast and Readability

### Background hierarchy
`bg0:#08080c` (page), `bg1:#0e0e14` (sections), `bg2:#141420` (cards), `bg3:#1a1a28` (inner elements), `bg4:#222232` (active states). The difference between bg0 and bg1 is nearly imperceptible (lightness 3.5% vs 5.5%). bg2 and bg3 are similarly close. This means sections do not clearly separate from their containers.

### Text contrast
- `text0:#eae9f0` on `bg0:#08080c`: contrast ratio ~15.5:1 -- excellent
- `text1:#c4c3ce` on `bg2:#141420`: ~9.7:1 -- good
- `text2:#8a899a` on `bg2:#141420`: ~4.8:1 -- borderline (WCAG AA for normal text requires 4.5:1)
- `text3:#5a596a` on `bg2:#141420`: ~2.7:1 -- **FAILS WCAG AA**. This color is used for labels, timestamps, helper text, and meta-information throughout the entire application.

### Small monospace text
The smallest text in the app is 0.5rem mono (line 2309, "Used by:" label). At 0.5rem, that is approximately 8px -- below the minimum 9px readable threshold for most users. Combined with text3 color on bg2, this is essentially invisible.

Other problem sizes:
- 0.52rem (line 1637, pipeline role badges in TechCard): ~8.3px
- 0.55rem (line 1650, section sub-labels): ~8.8px
- 0.58rem (line 1633, expand arrow, technique mapping text): ~9.3px

These sizes create a gradient from "barely readable" to "unreadable" and are used for functionally important information.


## 10. The Expanded Card Pattern: max-height Transition

TechCard uses `maxHeight:expanded?2000:0` with `transition:"max-height 0.4s ease"` (line 1646). PrincipleCard uses `maxHeight:expanded?500:0` with `transition:"max-height 0.3s ease"` (line 1825). Archetype cards use `maxHeight:isOpen?400:0` with the same 0.3s transition (line 2341). Hilbert concept cards use `maxHeight:isOpen?400:0` (line 3164).

**The 2000px max-height on TechCard is the worst case.** The CSS `max-height` transition animates from 0 to 2000px in 0.4s, but the actual content might only be 600px tall. This means the animation completes long before the visual change stops -- the card appears to "pop" open rather than smoothly expanding, because the transition runs from 0 to 2000px at a constant rate, but the visual change ends when content height is reached.

Conversely, when collapsing, the transition runs from the actual rendered height to 0, but the timing function is calibrated for the full 0-to-2000px range. The first ~70% of the collapse animation (2000px down to 600px) is invisible because the content height was already at 600px, so the card appears to freeze for ~0.28s before collapsing. This creates a perceivable lag.

The 500px and 400px variants are better because the overshoot is smaller, but the fundamental problem with max-height transitions remains: they cannot adapt to actual content height without JavaScript measurement.
