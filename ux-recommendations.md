# Foresight Compendium -- Concrete UX Recommendations

## 1. Tab Consolidation Strategy

### Current: 8 flat tabs
```
Techniques | Composer | Matrix | Matrix | Principles | Condensed Logs | Graph | Causal | Observatory
```

### Proposed: 4 primary tabs + contextual sub-views

**Tab 1: "Explore"** (merges Techniques + Principles)
- Default view: Techniques catalog (current TechniquesTab)
- Sub-toggle: "Techniques" / "Principles" / "Operators" (move operator stack from Condensed Logs here)
- Rationale: Techniques and Principles are both reference material. Operators describe what techniques compute. They belong together.

**Tab 2: "Build"** (merges Composer + Matrix)
- Default view: Pipeline Composer (current ComposerTab)
- Matrix available as a toggle view within Build: "Composer" / "Compatibility"
- Rationale: The Matrix exists to inform composition decisions. Users check compatibility WHILE building pipelines. Having them in separate tabs creates tab-switching friction.

**Tab 3: "Analyze"** (merges Observatory + Graph)
- Default view: Observatory feed selector + analysis (current ObservatoryTab)
- Graph available as a sub-view: "Feed Analysis" / "Pipeline Graph" / "Percolation"
- Move percolation from Graph into this tab, since it requires feed data anyway
- Rationale: Observatory and Graph are both analysis tools. The Graph tab is useless without a pipeline; Observatory recommends pipelines. They complete each other.

**Tab 4: "Causal Lab"** (current Causal tab, focused)
- Standalone because it is a specialist tool with distinct interaction patterns (sliders, experiment runs)
- Move the Technique-to-Hilbert mapping into the Explore tab (it is reference material, not a lab tool)
- Move Archetypes from Condensed Logs into the Explore tab
- Remove CLR Schema section (move to a collapsible reference panel or footer)

### What Condensed Logs becomes
The Condensed Logs tab is eliminated. Its three sections are redistributed:
- CLR Schema -> collapsible reference panel in Explore tab footer, or a help/info overlay
- Operator Stack -> sub-view in Explore tab ("Techniques" / "Principles" / "Operators")
- Stream Archetypes -> sub-view in Explore tab, or promoted to a filter in Observatory

### Navigation implementation
Replace the 8-tab TabBar with a 4-tab primary bar plus a Segmented sub-bar per tab:
```
[ Explore ] [ Build ] [ Analyze ] [ Causal Lab ]
   |-- Techniques | Principles | Operators
```


## 2. Typography Scale Cleanup

### Current: 18 distinct font sizes
```
0.50rem  0.52rem  0.55rem  0.58rem  0.60rem  0.62rem  0.65rem  0.68rem
0.72rem  0.75rem  0.78rem  0.82rem  0.85rem  0.88rem  0.95rem  1.10rem
1.60rem  1.80rem
```

### Proposed: 6 sizes on a 1.25 ratio
```
xs:   0.65rem  (10.4px) -- minimum readable size, for chip text, timestamps, meta
sm:   0.75rem  (12px)   -- body text, descriptions, card content
md:   0.85rem  (13.6px) -- card titles, section subtitles, primary UI text
lg:   1.05rem  (16.8px) -- section headers, tab labels
xl:   1.35rem  (21.6px) -- page section headings
xxl:  1.70rem  (27.2px) -- page title only
```

### Mapping old sizes to new
| Current usage | Current size | New size | Notes |
|---|---|---|---|
| "Used by:" labels, op cross-refs | 0.50-0.52rem | xs (0.65rem) | Was unreadable, now legible |
| Section sub-labels (UPPERCASE) | 0.55rem | xs (0.65rem) | Uppercase + letterspacing compensate for size increase |
| Chip text, badges | 0.58-0.68rem | xs (0.65rem) | Standardize all chip/badge text |
| Card descriptions, data values | 0.72-0.75rem | sm (0.75rem) | Collapse to single size |
| Card titles | 0.82-0.88rem | md (0.85rem) | Collapse to single size |
| Section titles | 0.95rem | lg (1.05rem) | Slight increase for hierarchy |
| Metric card values | 1.60rem | xl (1.35rem) | Reduce prominence of static counts |
| Page title | 1.80rem | xxl (1.70rem) | Slight reduction |

### Font family rules
- `T.display` (Georgia): used ONLY for page title (xxl), section titles (lg), and metric card values (xl)
- `T.body` (system-ui): used for descriptions, prose, and card body text (sm)
- `T.mono` (ui-monospace): used ONLY for: chip/badge labels (xs), data values in stat cards, formulas, code-like content (technical names, IDs)

### Line height rules
- xs: 1.3
- sm: 1.5
- md: 1.4
- lg: 1.2
- xl, xxl: 1.1


## 3. Color Simplification

### Current: 9 base colors, 3 variants each = 27 tokens, 3 competing taxonomies

### Proposed: 6 functional colors, 2 variants each = 12 tokens + 2 neutral

**Functional palette:**
```
accent:    #4a8fe7 (blue)     -- primary interactive, links, selected state
positive:  #3dbe78 (green)    -- success, compatible, safe, synergy
warning:   #e0c040 (yellow)   -- caution, medium risk, partial compatibility
danger:    #e84a5a (red)      -- error, incompatible, conflict, high risk
info:      #9b6dff (purple)   -- informational highlights, principles, Hilbert
highlight: #e8762b (orange)   -- emphasis, recommendations, attention
```

Each gets ONE variant: `dim` (12% opacity on dark background) for backgrounds.

**Dropped colors:**
- `teal` (#2bbfa0) -> merge into `positive` (green). Currently teal means "used" epistemic level AND "probabilistic family" AND "cross-stream operators." Too many meanings; green covers all these.
- `crimson` (#dc2640) -> merge into `danger` (red). Crimson and red are perceptually too similar to justify as separate tokens.
- `silver` (#b0b3c0) -> use `T.text2` instead. Silver was used for baseline family and aspirational epistemic level, both of which are "neutral" concepts.

**Technique family color assignments (revised):**
```
Baseline:       text2 (neutral gray) -- deliberately de-emphasized
Statistical:    accent (blue)
State-Space:    info (purple)
ML:             highlight (orange)
Deep Learning:  danger (red)
Probabilistic:  info (purple, lighter variant)
Decomposition:  positive (green)
Point Process:  warning (yellow)
Ensemble:       danger (red, lighter variant)
```

**Epistemic color system: remove entirely.** The 8 epistemic levels (verified, asserted, assumed, inferred, extrapolated, aspirational, invariant, used) appear only in header/footer chrome and serve no functional purpose. Remove the `LEVEL_COLOR` mapping (lines 39-48), the Chip level prop (line 1460), and the footer legend (lines 3463-3469). If epistemic tagging is desired in the future, integrate it as a property on individual data items (e.g., technique confidence).

**Color usage rules:**
1. `positive` (green) for: compatibility scores > 80%, synergy indicators, safe examples, recommended pipelines
2. `danger` (red) for: compatibility scores < 40%, conflict indicators, unsafe examples, high leakage risk
3. `warning` (yellow) for: compatibility 40-80%, medium risk, caution states
4. `accent` (blue) for: selected/focused elements, interactive affordances, links
5. `highlight` (orange) for: technique emphasis, recommendation priority markers, CTA buttons
6. `info` (purple) for: Hilbert space content, principle category badges, informational blocks
7. Never use color as the sole differentiator. Always pair with shape, icon, or text.


## 4. Component Consolidation

### Create: ExpandableCard component
Currently implemented 4 separate times:
- TechCard (line 1620): `maxHeight:expanded?2000:0`
- PrincipleCard (line 1809): `maxHeight:expanded?500:0`
- Archetype card (inline, line 2332): `maxHeight:isOpen?400:0`
- Hilbert concept card (inline, line 3151): `maxHeight:isOpen?400:0`

**Consolidate into:**
```jsx
function ExpandableCard({ title, subtitle, color, badge, expanded, onToggle, children }) {
  const contentRef = useRef(null);
  const [height, setHeight] = useState(0);
  useEffect(() => {
    if (contentRef.current) setHeight(contentRef.current.scrollHeight);
  }, [expanded, children]);
  // ... render with maxHeight: expanded ? height : 0
}
```
This uses measured height instead of arbitrary max-height values, fixing the transition lag.

### Create: Tooltip component
Currently using raw `title` attributes (lines 1755, 1773, etc.). Replace with a positioned tooltip that:
- Appears on hover after 300ms delay
- Uses bg3 background with border1 border
- Shows mono text at xs size
- Positions automatically (above/below/left/right based on viewport)

### Create: FilterBar component
The Segmented control + search input pattern is repeated in:
- Techniques tab (line 1875-1882)
- Composer tab (line 2064-2067)
- Matrix tab (line 2123-2125)
- Principles tab (line 2223-2226)
- Condensed Logs tab (line 2282-2284)
- Observatory tab (line 2444-2446)

Consolidate into: `<FilterBar search={bool} segments={[]} onSearch={fn} onFilter={fn} />`

### Create: LoadingState component
Replace the simple text indicator (lines 2491-2493) with:
```jsx
function LoadingState({ sections }) {
  // Renders skeleton rectangles matching the layout of the target sections
  // Animates with a shimmer effect on bg3 -> bg4
}
```

### Consolidate: "Chip" overuse
The Chip component is used for 8+ different semantic purposes: epistemic levels, family labels, input/output types, assumptions, owned responsibilities, time scales, best-for tags, operator cross-refs, pipeline names.

Differentiate:
- **Tag**: simple text label with subtle background (for types, scales, assumptions)
- **Chip**: colored with dot indicator (for family labels, operator categories)
- **Badge**: count indicator with strong background (for section counts -- keep as is)

Remove the dot indicator from Tags. Reserve the dot + colored border for Chips that represent named entities (techniques, operators).


## 5. Interaction Improvements

### Better affordances
1. **Card hover state**: Add `background: ${T.bg3}` on hover for all clickable cards, with a 150ms transition. Currently hover only changes cursor.
2. **Tab active indicator**: The current 2px bottom border (line 1613) is too subtle. Use a 3px border plus background color change to bg4.
3. **Pipeline add feedback**: When adding a technique to the pipeline, briefly flash the pipeline section header with the technique's family color.
4. **Matrix click behavior**: Clicking a cell should pin the detail panel (currently only hover). Clicking again deselects.

### Better transitions
1. **Replace max-height transitions** with `grid-template-rows` animation:
```css
.expandable { display: grid; grid-template-rows: 0fr; transition: grid-template-rows 0.3s ease; }
.expandable.open { grid-template-rows: 1fr; }
.expandable > div { overflow: hidden; }
```
This animates to actual content height without JavaScript.

2. **Stagger card grid animation**: When filtering techniques, animate newly visible cards with a 30ms stagger delay using `transitionDelay`.

3. **Percolation completion**: When percolation finishes, pulse the final stage border from yellow to green over 1 second.

### Better loading
1. **Observatory feed loading**: Show skeleton cards matching the stat grid layout (12 rectangles in `auto-fill minmax(180px, 1fr)`).
2. **Causal experiment running**: Show a progress animation on the "Run" button instead of changing text.
3. **Initial page load**: The Babel transpilation in-browser (line 9) causes a blank white flash before React renders. Add a CSS-only loading indicator in the `<body>` before the React mount.


## 6. Information Architecture: Progressive Disclosure

### Techniques tab: Two-level cards
**Level 1 (always visible):** Name, family, description, pipeline role, complexity dots.
**Level 2 (expanded):** Inputs/outputs, assumptions, time scales, best for.
**Level 3 (drawer/modal):** Strengths, weaknesses, synergies, conflicts, related, operators, pipelines, Hilbert mapping.

Currently Level 1 and Level 2 are collapsed into the card header, and Level 3 is the expanded state. The fix: make Level 2 the expanded state, and move Level 3 to a side drawer that opens on a "Details" button click. This keeps expanded cards under 300px tall.

### Observatory tab: Stepped analysis
Current: All analysis results render at once in a vertical scroll.
Proposed:
1. **Step 1**: Select feed -> show sparkline + 4 key stats (mean, std, trend, seasonality) in a compact summary bar.
2. **Step 2**: User clicks "Full Analysis" -> expand to show all 12 stats + ACF chart.
3. **Step 3**: Recommended techniques and pipelines appear below as a separate section with its own expand trigger.

### Condensed Logs tab: Kill it
As described in Tab Consolidation (section 1), redistribute its content:
- CLR Schema -> help overlay or documentation link
- Operators -> Explore tab sub-view
- Archetypes -> Explore tab sub-view or Observatory filter

### Smart defaults
1. **Techniques tab**: Open the first card (Naive) by default so users see what expanded state looks like.
2. **Composer tab**: Pre-load the "Quick Baseline" canonical pipeline so the composer is not empty on first visit.
3. **Observatory tab**: Auto-load the first synthetic feed ("Trending Walk") so users see the analysis immediately.
4. **Causal tab**: Auto-run the default experiment (linear, delay=3, noise=0.5, n=300) so results are visible on tab entry.


## 7. Accessibility

### Contrast fixes
| Token | Current | Proposed | Contrast on bg2 (#141420) |
|-------|---------|----------|--------------------------|
| text3 | #5a596a | #8a8999 | ~5.1:1 (WCAG AA pass) |
| text2 | #8a899a | #9a99aa | ~5.8:1 (comfortable) |

### Minimum font size
Enforce 0.65rem (10.4px) as the absolute minimum. Remove all instances of 0.5rem, 0.52rem, 0.55rem, 0.58rem, 0.6rem, 0.62rem. Map them all to 0.65rem.

### Focus states
Add a global focus-visible style:
```css
:focus-visible {
  outline: 2px solid ${T.accent};
  outline-offset: 2px;
  border-radius: ${T.rSm}px;
}
```

### Keyboard navigation
1. **Tab bar**: Arrow left/right to switch tabs. Enter/Space to select.
2. **Cards**: Enter/Space to expand/collapse. Tab to move between cards.
3. **Pipeline composer**: Tab to move between technique buttons. Enter to add. Delete/Backspace to remove focused pipeline step.
4. **Matrix**: Arrow keys to navigate cells. Enter to pin detail view.
5. **Sliders (Causal)**: Already keyboard-accessible via native `<input type="range">`.

### ARIA labels
- Tab bar: `role="tablist"`, individual tabs: `role="tab"`, `aria-selected`
- Expandable cards: `aria-expanded`, `aria-controls`
- Progress bars: `role="progressbar"`, `aria-valuenow`, `aria-valuemin`, `aria-valuemax`
- Sparklines: `role="img"`, `aria-label="Sparkline showing [description]"`
- Matrix cells: `aria-label="[techA] to [techB]: [score]% compatible"`

### Screen reader support
- Add `<h2>` for tab content section titles (currently styled `<span>` elements)
- Add `<h3>` for card titles (currently styled `<span>` elements)
- Use semantic `<details>/<summary>` for expandable cards where possible
- Add `aria-live="polite"` to the Observatory loading/results region
