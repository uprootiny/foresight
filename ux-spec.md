# Foresight Compendium -- Implementation Spec

This spec defines exact changes to execute the UX refactoring. Reference the source file `/home/uprootiny/foresight/index.html` (3497 lines).

---

## 1. Design Token Changes (lines 20-37)

### Before
```javascript
const T = {
  bg0:"#08080c", bg1:"#0e0e14", bg2:"#141420", bg3:"#1a1a28", bg4:"#222232",
  border0:"#1e1e2e", border1:"#2a2a3c", border2:"#36364a",
  text0:"#eae9f0", text1:"#c4c3ce", text2:"#8a899a", text3:"#5a596a",
  blue:"#4a8fe7", blueDim:"rgba(74,143,231,0.15)", blueMid:"rgba(74,143,231,0.35)",
  red:"#e84a5a", redDim:"rgba(232,74,90,0.15)", redMid:"rgba(232,74,90,0.35)",
  purple:"#9b6dff", purpleDim:"rgba(155,109,255,0.15)", purpleMid:"rgba(155,109,255,0.35)",
  green:"#3dbe78", greenDim:"rgba(61,190,120,0.15)", greenMid:"rgba(61,190,120,0.35)",
  yellow:"#e0c040", yellowDim:"rgba(224,192,64,0.12)", yellowMid:"rgba(224,192,64,0.30)",
  orange:"#e8762b", orangeDim:"rgba(232,118,43,0.15)", orangeMid:"rgba(232,118,43,0.35)",
  teal:"#2bbfa0", tealDim:"rgba(43,191,160,0.15)", tealMid:"rgba(43,191,160,0.35)",
  silver:"#b0b3c0", silverDim:"rgba(176,179,192,0.10)", silverMid:"rgba(176,179,192,0.28)",
  crimson:"#dc2640", crimsonDim:"rgba(220,38,64,0.15)", crimsonMid:"rgba(220,38,64,0.35)",
  rSm:3, rMd:5, rLg:8, rPill:100,
  mono:"ui-monospace, 'SF Mono', monospace",
  display:"Georgia, serif",
  body:"system-ui, sans-serif",
};
```

### After
```javascript
const T = {
  // Backgrounds -- increase contrast between layers
  bg0:"#08080c", bg1:"#0f0f18", bg2:"#161624", bg3:"#1e1e30", bg4:"#28283c",

  // Borders
  border0:"#1e1e2e", border1:"#2c2c40", border2:"#3a3a50",

  // Text -- text3 raised from #5a596a to #8a8999 for WCAG AA compliance
  text0:"#eae9f0", text1:"#c4c3ce", text2:"#9a99aa", text3:"#8a8999",

  // 6 functional colors (base + dim only, drop "mid" variants)
  accent:"#4a8fe7",    accentDim:"rgba(74,143,231,0.12)",
  positive:"#3dbe78",  positiveDim:"rgba(61,190,120,0.12)",
  warning:"#e0c040",   warningDim:"rgba(224,192,64,0.10)",
  danger:"#e84a5a",    dangerDim:"rgba(232,74,90,0.12)",
  info:"#9b6dff",      infoDim:"rgba(155,109,255,0.12)",
  highlight:"#e8762b", highlightDim:"rgba(232,118,43,0.12)",

  // Deprecated aliases (keep temporarily for migration)
  blue:"#4a8fe7", blueDim:"rgba(74,143,231,0.12)",
  green:"#3dbe78", greenDim:"rgba(61,190,120,0.12)",
  yellow:"#e0c040", yellowDim:"rgba(224,192,64,0.10)",
  red:"#e84a5a", redDim:"rgba(232,74,90,0.12)",
  purple:"#9b6dff", purpleDim:"rgba(155,109,255,0.12)",
  orange:"#e8762b", orangeDim:"rgba(232,118,43,0.12)",
  teal:"#3dbe78", tealDim:"rgba(61,190,120,0.12)",       // teal -> positive (green)
  silver:"#9a99aa", silverDim:"rgba(154,153,170,0.10)",   // silver -> text2
  crimson:"#e84a5a", crimsonDim:"rgba(232,74,90,0.12)",   // crimson -> danger (red)

  // Radii
  rSm:4, rMd:6, rLg:10, rPill:100,

  // Typography
  mono:"ui-monospace, 'SF Mono', 'Cascadia Code', monospace",
  display:"Georgia, 'Times New Roman', serif",
  body:"system-ui, -apple-system, sans-serif",

  // Type scale (NEW)
  fs: {
    xs: "0.65rem",   // 10.4px -- minimum readable, chips, timestamps
    sm: "0.75rem",   // 12px   -- body text, descriptions
    md: "0.85rem",   // 13.6px -- card titles, section subtitles
    lg: "1.05rem",   // 16.8px -- section headers, tab labels
    xl: "1.35rem",   // 21.6px -- page section headings
    xxl: "1.70rem",  // 27.2px -- page title
  },

  // Spacing scale (NEW)
  sp: {
    xs: 4,   // tight internal spacing
    sm: 8,   // chip gaps, small card padding
    md: 12,  // card padding, section gaps
    lg: 16,  // section padding
    xl: 24,  // major section breaks
    xxl: 32, // page-level spacing
  },
};
```

### Migration notes
- `T.blueMid`, `T.redMid`, `T.purpleMid`, `T.greenMid`, `T.yellowMid`, `T.orangeMid`, `T.tealMid`, `T.silverMid`, `T.crimsonMid` are all **removed**. Replace all occurrences with `${T.accent}55` (hex opacity suffix) or the corresponding dim variant.
- Semantic aliases: use `T.accent` instead of `T.blue` for interactive elements, `T.positive` instead of `T.green` for success, etc. The deprecated aliases ensure nothing breaks during migration.


## 2. Typography Scale Application (every component)

### Global rule: Replace every font size with the nearest scale value

**Mapping (search-and-replace targets):**

| Find (fontSize) | Replace with |
|---|---|
| `"0.50rem"`, `"0.5rem"` | `T.fs.xs` |
| `"0.52rem"` | `T.fs.xs` |
| `"0.55rem"` | `T.fs.xs` |
| `"0.58rem"` | `T.fs.xs` |
| `"0.60rem"`, `"0.6rem"` | `T.fs.xs` |
| `"0.62rem"` | `T.fs.xs` |
| `"0.65rem"` | `T.fs.xs` |
| `"0.68rem"` | `T.fs.xs` |
| `"0.72rem"` | `T.fs.sm` |
| `"0.75rem"` | `T.fs.sm` |
| `"0.78rem"` | `T.fs.sm` |
| `"0.82rem"` | `T.fs.md` |
| `"0.85rem"` | `T.fs.md` |
| `"0.88rem"` | `T.fs.md` |
| `"0.95rem"` | `T.fs.lg` |
| `"1.1rem"` | `T.fs.xl` |
| `"1.6rem"` | `T.fs.xl` |
| `"1.8rem"` | `T.fs.xxl` |

**Affected lines (non-exhaustive):**
- Chip: line 1464 `fontSize:"0.68rem"` -> `fontSize:T.fs.xs`
- Badge: line 1481 `fontSize:"0.6rem"` -> `fontSize:T.fs.xs`
- StatusDot: unchanged (no text)
- Sparkline labels: line 1514 `fontSize: 8` -> `fontSize: 10`
- AcfChart labels: line 1541 `fontSize: 7` -> `fontSize: 9`
- ProgressBar: unchanged (no text)
- MetricCard label: line 1560 `fontSize:"0.6rem"` -> `fontSize:T.fs.xs`
- MetricCard value: line 1561 `fontSize:"1.6rem"` -> `fontSize:T.fs.xl`
- MetricCard unit: line 1562 `fontSize:"0.8rem"` -> `fontSize:T.fs.sm`
- MetricCard delta: line 1564 `fontSize:"0.65rem"` -> `fontSize:T.fs.xs`
- Section title: line 1575 `fontSize:"0.95rem"` -> `fontSize:T.fs.lg`
- Segmented buttons: line 1589 `fontSize:"0.68rem"` -> `fontSize:T.fs.xs`
- TabBar buttons: line 1608 `fontSize:"0.72rem"` -> `fontSize:T.fs.sm`
- TechCard name: line 1630 `fontSize:"0.88rem"` -> `fontSize:T.fs.md`
- TechCard desc: line 1635 `fontSize:"0.75rem"` -> `fontSize:T.fs.sm`
- TechCard sub-labels: lines 1637, 1639, 1641 -- all -> `fontSize:T.fs.xs`
- TechCard section labels: lines 1650, 1654, 1658, 1664, 1670, 1674 -- all -> `fontSize:T.fs.xs`
- TechCard section chip text: lines 1651, 1655, 1660, 1666, 1671, 1675 -- all -> `fontSize:T.fs.xs`
- Strengths/weaknesses header: lines 1689, 1699 -> `fontSize:T.fs.xs`
- Strengths/weaknesses body: lines 1693, 1703 -> `fontSize:T.fs.xs`
- Synergies/Conflicts/Related headers: lines 1711, 1723, 1735 -> `fontSize:T.fs.xs`
- Synergies/Conflicts/Related chips: lines 1714, 1727, 1738 -> `fontSize:T.fs.xs`
- CLR Operators header: line 1749 -> `fontSize:T.fs.xs`
- CLR Operators chips: line 1755 -> `fontSize:T.fs.xs`
- Pipelines header: line 1770 -> `fontSize:T.fs.xs`
- Pipeline chips: line 1773 -> `fontSize:T.fs.xs`
- Hilbert label: line 1791 -> `fontSize:T.fs.xs`
- Hilbert symbol: line 1792 -> `fontSize:T.fs.xs`
- Hilbert name: line 1794 -> `fontSize:T.fs.xs`
- Hilbert interpretation: line 1796 -> `fontSize:T.fs.xs`
- App header title: line 3421 `fontSize:"1.8rem"` -> `fontSize:T.fs.xxl`
- App header subtitle: line 3424 `fontSize:"0.55rem"` -> `fontSize:T.fs.xs`

**SVG text sizes (integer px):**
- Graph node labels: line 2901 `fontSize: 7.5` -> `fontSize: 9`
- Graph column labels: line 2811 `fontSize: 8` -> `fontSize: 9`
- Matrix labels: line 2137 `fontSize: Math.min(7, cellSize*0.4)` -> `fontSize: Math.min(9, cellSize*0.45)`


## 3. Spacing System Application

### Standard padding/gap values
Replace all ad-hoc padding/gap values with `T.sp.*`:

| Current pattern | Replace with |
|---|---|
| `padding:2` | `padding:T.sp.xs` |
| `padding:3` | `padding:T.sp.xs` |
| `gap:2`, `gap:3` | `gap:T.sp.xs` |
| `gap:4`, `padding:"4px..."` | `gap:T.sp.xs` |
| `gap:6`, `padding:"6px..."` | `gap:T.sp.sm` |
| `gap:8`, `padding:"8px..."` | `gap:T.sp.sm` |
| `gap:10`, `padding:"10px..."` | `gap:T.sp.md` |
| `gap:12`, `padding:"12px..."` | `gap:T.sp.md` |
| `padding:"14px..."`, `padding:14` | `padding:T.sp.lg` |
| `padding:16`, `padding:"16px..."` | `padding:T.sp.lg` |
| `padding:20` | `padding:T.sp.xl` |
| `padding:"24px..."` | `padding:T.sp.xl` |
| `padding:"32px..."` | `padding:T.sp.xxl` |
| `marginBottom:24` | `marginBottom:T.sp.xl` |
| `marginTop:12` | `marginTop:T.sp.md` |
| `marginTop:32` | `marginTop:T.sp.xxl` |

### Specific Section component (lines 1569-1582)
Before: `padding:"14px 16px"`
After: `padding:\`${T.sp.lg}px ${T.sp.lg}px\``

### Specific card padding
Before (TechCard, line 1627): `padding:"12px 14px"`
After: `padding:\`${T.sp.md}px ${T.sp.lg}px\``

### App container (line 3417)
Before: `padding:"24px 32px 48px"`
After: `padding:\`${T.sp.xl}px ${T.sp.xxl}px ${T.sp.xxl + T.sp.lg}px\``


## 4. Tab Structure Changes

### App component (lines 3385-3486)

#### Before: tabs array (lines 3388-3397)
```javascript
const tabs = [
  { key:"techniques", label:"Techniques", color:T.orange },
  { key:"composer", label:"Composer", color:T.green },
  { key:"matrix", label:"Matrix", color:T.blue },
  { key:"principles", label:"Principles", color:T.purple },
  { key:"logs", label:"Condensed Logs", color:T.teal },
  { key:"graph", label:"Graph", color:T.green },
  { key:"causal", label:"Causal", color:T.crimson },
  { key:"observatory", label:"Observatory", color:T.yellow },
];
```

#### After: primary tabs + sub-tab state
```javascript
const [tab, setTab] = useState("explore");
const [subTab, setSubTab] = useState("techniques");

const tabs = [
  { key:"explore", label:"Explore", color:T.highlight },
  { key:"build", label:"Build", color:T.positive },
  { key:"analyze", label:"Analyze", color:T.accent },
  { key:"causal", label:"Causal Lab", color:T.info },
];

const subTabs = {
  explore: [
    { key:"techniques", label:"Techniques" },
    { key:"principles", label:"Principles" },
    { key:"operators", label:"Operators" },
  ],
  build: [
    { key:"composer", label:"Composer" },
    { key:"matrix", label:"Compatibility" },
  ],
  analyze: [
    { key:"observatory", label:"Feed Analysis" },
    { key:"graph", label:"Pipeline Graph" },
  ],
  causal: [], // no sub-tabs
};
```

#### After: tab content rendering (lines 3452-3460)
```javascript
<TabBar tabs={tabs} active={tab} onChange={k => { setTab(k); setSubTab(subTabs[k]?.[0]?.key || k); }} />
{subTabs[tab]?.length > 0 && (
  <Segmented options={subTabs[tab]} active={subTab} onChange={setSubTab}
    style={{ marginBottom: T.sp.lg }} />
)}

{tab === "explore" && subTab === "techniques" && <TechniquesTab />}
{tab === "explore" && subTab === "principles" && <PrinciplesTab />}
{tab === "explore" && subTab === "operators" && <OperatorsSubTab />}
{tab === "build" && subTab === "composer" && <ComposerTab />}
{tab === "build" && subTab === "matrix" && <MatrixTab />}
{tab === "analyze" && subTab === "observatory" && <ObservatoryTab />}
{tab === "analyze" && subTab === "graph" && <GraphTab />}
{tab === "causal" && <CausalTab />}
```

### New OperatorsSubTab component
Extract the Operator Stack section (lines 2280-2324) and Stream Archetypes section (lines 2326-2382) from CondensedLogsTab into a standalone component. Remove CLR Schema or put it in a collapsible details element at the top.


## 5. Component Modifications

### 5a. ExpandableCard abstraction (replaces 4 implementations)

```javascript
function ExpandableCard({ title, subtitle, color, badge, headerRight, expanded, onToggle, children }) {
  const contentRef = useRef(null);
  const [measuredHeight, setMeasuredHeight] = useState(0);

  useEffect(() => {
    if (contentRef.current) {
      setMeasuredHeight(contentRef.current.scrollHeight);
    }
  });

  return (
    <div style={{
      background: T.bg2,
      border: `1px solid ${T.border0}`,
      borderRadius: T.rMd,
      overflow: "hidden",
    }}>
      {color && <div style={{ height: 2, background: color }} />}
      <div
        onClick={onToggle}
        role="button"
        tabIndex={0}
        aria-expanded={expanded}
        onKeyDown={e => { if (e.key === "Enter" || e.key === " ") { e.preventDefault(); onToggle(); } }}
        style={{ padding: `${T.sp.md}px ${T.sp.lg}px`, cursor: "pointer" }}
      >
        <div style={{ display: "flex", alignItems: "center", gap: T.sp.sm }}>
          {badge}
          <span style={{
            fontFamily: T.display,
            fontWeight: 700,
            fontSize: T.fs.md,
            color: T.text0,
            flex: 1,
          }}>{title}</span>
          {headerRight}
          <span style={{
            fontFamily: T.mono,
            fontSize: T.fs.xs,
            color: T.text3,
            transform: expanded ? "rotate(90deg)" : "rotate(0)",
            transition: "transform 0.2s",
          }}>&#9656;</span>
        </div>
        {subtitle && (
          <div style={{
            fontFamily: T.body,
            fontSize: T.fs.sm,
            color: T.text2,
            marginTop: T.sp.xs,
            marginLeft: badge ? 28 : 0,
          }}>{subtitle}</div>
        )}
      </div>
      <div style={{
        maxHeight: expanded ? measuredHeight : 0,
        overflow: "hidden",
        transition: "max-height 0.3s ease-out",
      }}>
        <div ref={contentRef} style={{
          padding: `0 ${T.sp.lg}px ${T.sp.lg}px`,
          borderTop: `1px solid ${T.border0}`,
        }}>
          {children}
        </div>
      </div>
    </div>
  );
}
```

### 5b. TechCard refactored (line 1620)

Split expanded content into two tiers:

**Tier 1 (expanded inline):** Inputs, Outputs, Assumptions, Owns, Time Scales, Best For
**Tier 2 (detail drawer):** Strengths, Weaknesses, Synergies, Conflicts, Related, Operators, Pipelines, Hilbert

```javascript
function TechCard({ tech, expanded, onToggle, onShowDetail }) {
  const fc = familyColor(tech.family);

  return (
    <ExpandableCard
      title={tech.name}
      subtitle={tech.desc}
      color={fc}
      badge={<StatusDot color={fc} size={7} />}
      headerRight={
        <span style={{
          fontFamily: T.mono, fontSize: T.fs.xs,
          padding: "0.15em 0.5em", borderRadius: T.rSm,
          background: `${fc}22`, color: fc, border: `1px solid ${fc}33`,
        }}>{familyName(tech.family)}</span>
      }
      expanded={expanded}
      onToggle={onToggle}
    >
      {/* Tier 1: essential metadata grid */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: T.sp.md, marginTop: T.sp.md }}>
        <MetaSection label="Inputs" items={tech.inputTypes} />
        <MetaSection label="Outputs" items={tech.outputTypes} />
        <MetaSection label="Time Scales" items={tech.timeScales} />
        <MetaSection label="Best For" items={tech.bestFor} color={T.positive} />
      </div>

      {/* Tier 2 trigger */}
      <button onClick={e => { e.stopPropagation(); onShowDetail(tech.id); }} style={{
        fontFamily: T.mono, fontSize: T.fs.xs, padding: `${T.sp.xs}px ${T.sp.sm}px`,
        borderRadius: T.rSm, border: `1px solid ${T.border1}`,
        background: T.bg3, color: T.text2, cursor: "pointer",
        marginTop: T.sp.md, display: "block", width: "100%",
      }}>
        Strengths, Weaknesses, Connections, Hilbert...
      </button>
    </ExpandableCard>
  );
}

function MetaSection({ label, items, color }) {
  return (
    <div>
      <div style={{
        fontFamily: T.mono, fontSize: T.fs.xs, color: T.text3,
        textTransform: "uppercase", letterSpacing: "0.1em", marginBottom: T.sp.xs,
      }}>{label}</div>
      <div style={{ display: "flex", gap: T.sp.xs, flexWrap: "wrap" }}>
        {items.map(item => (
          <span key={item} style={{
            fontFamily: T.mono, fontSize: T.fs.xs,
            padding: "0.15em 0.5em", borderRadius: T.rSm,
            background: color ? `${color}15` : T.bg3,
            color: color || T.text1,
            border: `1px solid ${color ? `${color}33` : T.border0}`,
          }}>{item.replace(/_/g, " ")}</span>
        ))}
      </div>
    </div>
  );
}
```

### 5c. TabBar responsive (line 1603)

```javascript
function TabBar({ tabs, active, onChange }) {
  return (
    <div role="tablist" style={{
      display: "flex", gap: T.sp.xs,
      background: T.bg2, border: `1px solid ${T.border0}`,
      borderRadius: T.rMd, padding: T.sp.xs,
      marginBottom: T.sp.xl,
      overflowX: "auto",       // allow horizontal scroll on mobile
      WebkitOverflowScrolling: "touch",
    }}>
      {tabs.map(t => (
        <button
          key={t.key}
          role="tab"
          aria-selected={active === t.key}
          tabIndex={active === t.key ? 0 : -1}
          onClick={() => onChange(t.key)}
          onKeyDown={e => {
            const idx = tabs.findIndex(x => x.key === active);
            if (e.key === "ArrowRight" && idx < tabs.length - 1) onChange(tabs[idx + 1].key);
            if (e.key === "ArrowLeft" && idx > 0) onChange(tabs[idx - 1].key);
          }}
          style={{
            flex: "1 0 auto",
            minWidth: 100,       // ensure readability
            fontFamily: T.mono,
            fontSize: T.fs.sm,
            fontWeight: active === t.key ? 600 : 400,
            padding: `${T.sp.md}px ${T.sp.lg}px`,
            borderRadius: T.rSm,
            border: "none",
            cursor: "pointer",
            background: active === t.key ? T.bg4 : "transparent",
            color: active === t.key ? T.text0 : T.text3,
            transition: "all 0.2s ease",
            borderBottom: active === t.key ? `3px solid ${t.color || T.accent}` : "3px solid transparent",
            whiteSpace: "nowrap",
          }}
        >{t.label}</button>
      ))}
    </div>
  );
}
```

### 5d. Chip simplification (line 1459)

Remove the `level` prop and the epistemic color system from Chip. Replace with a simpler Tag component:

```javascript
function Tag({ children, color, onClick, style: sx }) {
  return (
    <span onClick={onClick} style={{
      display: "inline-flex", alignItems: "center", gap: "0.3em",
      fontFamily: T.mono, fontSize: T.fs.xs, fontWeight: 500,
      padding: "0.2em 0.55em", borderRadius: T.rSm,
      border: `1px solid ${color ? `${color}33` : T.border0}`,
      background: color ? `${color}12` : T.bg3,
      color: color || T.text1,
      whiteSpace: "nowrap",
      cursor: onClick ? "pointer" : "default",
      ...sx,
    }}>
      {children}
    </span>
  );
}
```

Keep the existing Chip component for backward compatibility but internally redirect to Tag when no `level` prop is given.


## 6. Color Usage Rules

### Decision matrix for choosing a color

| Context | Color token | Example |
|---|---|---|
| Interactive element (selected tab, focused input, link) | `T.accent` (#4a8fe7) | Tab active state, search input focus border |
| Success, safe, compatible, synergy | `T.positive` (#3dbe78) | Compatibility > 80%, synergy edges, safe examples |
| Warning, caution, medium risk | `T.warning` (#e0c040) | Compatibility 40-80%, medium leakage risk |
| Error, conflict, incompatible, unsafe | `T.danger` (#e84a5a) | Compatibility < 40%, conflict edges, unsafe examples |
| Informational, educational, abstract | `T.info` (#9b6dff) | Hilbert concepts, principle badges, background knowledge |
| Emphasis, recommendation, call-to-action | `T.highlight` (#e8762b) | Recommended techniques, "Run Experiment" button, attention |
| Neutral metadata, de-emphasized | `T.text3` | Timestamps, helper text, secondary labels |

### Technique family colors (use semantic aliases)
```javascript
const FAMILIES = [
  { id:"baseline",      color: T.text3 },       // deliberately neutral
  { id:"statistical",   color: T.accent },       // blue
  { id:"statespace",    color: T.info },          // purple
  { id:"ml",            color: T.highlight },     // orange
  { id:"deep",          color: T.danger },        // red
  { id:"probabilistic", color: T.info },          // purple (shared with statespace)
  { id:"decomposition", color: T.positive },      // green
  { id:"pointprocess",  color: T.warning },       // yellow
  { id:"ensemble",      color: T.danger },        // red (shared with deep)
];
```

Note: Probabilistic and State-Space share purple; Deep Learning and Ensemble share red. This is acceptable because these families never appear in the same visual context (a technique card is always one family). If differentiation is needed, use shape (different icon) not color.


## 7. Transition and Animation Standards

### Standard durations
```
instant:  0ms    -- focus rings, state changes
fast:     150ms  -- hover effects, button state changes
normal:   250ms  -- card expand/collapse, tab switching
slow:     400ms  -- page transitions, percolation steps
```

### Standard easing
```
ease-out:     cubic-bezier(0.22, 1, 0.36, 1)   -- opening, appearing
ease-in:      cubic-bezier(0.55, 0, 1, 0.45)   -- closing, disappearing
ease-in-out:  cubic-bezier(0.4, 0, 0.2, 1)     -- movement, repositioning
```

### Specific transitions

**Card expand (replaces max-height hack):**
```css
.expandable-content {
  display: grid;
  grid-template-rows: 0fr;
  transition: grid-template-rows 250ms cubic-bezier(0.22, 1, 0.36, 1);
}
.expandable-content.open {
  grid-template-rows: 1fr;
}
.expandable-content > div {
  overflow: hidden;
}
```
If using the measured-height approach (5a above), use:
```javascript
maxHeight: expanded ? measuredHeight : 0,
transition: "max-height 250ms cubic-bezier(0.22, 1, 0.36, 1)",
```

**Button hover:**
```javascript
// Replace global button:hover { opacity:0.85 } with per-button:
onMouseEnter: e => e.target.style.background = T.bg4,
onMouseLeave: e => e.target.style.background = originalBg,
// Add to style: transition: "background 150ms ease"
```

**Tab switching:**
Tab content should use `opacity` + `transform` for entrance:
```javascript
// Wrap tab content in:
<div style={{
  opacity: 1,
  transform: "translateY(0)",
  transition: "opacity 250ms ease, transform 250ms ease",
}}>
```

**Progress bar fill:**
Already correct at line 1552: `transition:"width 0.6s cubic-bezier(0.22,1,0.36,1)"`. Reduce to 400ms for consistency.

**Percolation sparkline appearance:**
```javascript
// On percStages reveal:
opacity: reached ? 1 : 0,
transform: reached ? "scale(1)" : "scale(0.8)",
transition: "opacity 400ms ease, transform 400ms ease",
```

### Animations to remove
- The `statusPulse` keyframe animation (line 3410-3413) is used by StatusDot `pulse` prop. Keep it but reduce intensity: change `scale(1.6)` to `scale(1.3)` and `opacity:0.6` to `opacity:0.4`.
- The SVG `<animate>` elements on glow rings (lines 2888-2889) are fine for the Graph tab but should use `dur="3s"` instead of `2s"` for subtlety.


## 8. Global CSS Changes (lines 3405-3415)

### Before
```javascript
<style>{`
  * { box-sizing:border-box; margin:0; padding:0; }
  ::-webkit-scrollbar { width:3px; height:3px; }
  ::-webkit-scrollbar-track { background:transparent; }
  ::-webkit-scrollbar-thumb { background:${T.border1}; border-radius:2px; }
  @keyframes statusPulse {
    0%, 100% { opacity:0; transform:scale(0.8); }
    50% { opacity:0.6; transform:scale(1.6); }
  }
  button:hover { opacity:0.85; }
`}</style>
```

### After
```javascript
<style>{`
  * { box-sizing:border-box; margin:0; padding:0; }
  ::-webkit-scrollbar { width:4px; height:4px; }
  ::-webkit-scrollbar-track { background:transparent; }
  ::-webkit-scrollbar-thumb { background:${T.border1}; border-radius:${T.rSm}px; }
  ::-webkit-scrollbar-thumb:hover { background:${T.border2}; }
  @keyframes statusPulse {
    0%, 100% { opacity:0; transform:scale(0.85); }
    50% { opacity:0.4; transform:scale(1.3); }
  }
  :focus-visible {
    outline: 2px solid ${T.accent};
    outline-offset: 2px;
    border-radius: ${T.rSm}px;
  }
  button { transition: background 150ms ease, color 150ms ease, border-color 150ms ease; }
  button:hover { filter: brightness(1.15); }
  input[type="range"] {
    -webkit-appearance: none;
    appearance: none;
    height: 4px;
    background: ${T.bg4};
    border-radius: ${T.rPill}px;
    outline: none;
  }
  input[type="range"]::-webkit-slider-thumb {
    -webkit-appearance: none;
    width: 14px;
    height: 14px;
    border-radius: 50%;
    background: ${T.accent};
    cursor: pointer;
    border: 2px solid ${T.bg0};
  }
  input[type="range"]::-moz-range-thumb {
    width: 14px;
    height: 14px;
    border-radius: 50%;
    background: ${T.accent};
    cursor: pointer;
    border: 2px solid ${T.bg0};
  }
  @media (max-width: 768px) {
    body { font-size: 14px; }
  }
`}</style>
```


## 9. Header Simplification (lines 3419-3447)

### Before: 8 epistemic chips + 6 metric cards

### After: Compact header + 4 key metrics

```javascript
<header style={{ marginBottom: T.sp.xl }}>
  <div style={{
    fontFamily: T.display, fontWeight: 700,
    fontSize: T.fs.xxl, color: T.text0,
    lineHeight: 1.1, marginBottom: T.sp.xs,
  }}>
    Foresight Compendium
  </div>
  <div style={{
    fontFamily: T.mono, fontSize: T.fs.xs,
    textTransform: "uppercase", letterSpacing: "0.16em",
    color: T.text3, marginBottom: T.sp.lg,
  }}>
    Time Series Forecasting Observatory
  </div>
  {/* Remove epistemic chips -- they serve no functional purpose */}
  {/* Reduce metric cards from 6 to 4 */}
  <div style={{
    display: "grid",
    gridTemplateColumns: "repeat(auto-fill, minmax(140px, 1fr))",
    gap: T.sp.md,
    marginBottom: T.sp.xl,
  }}>
    <MetricCard label="Techniques" value={TECHNIQUES.length} color={T.highlight} />
    <MetricCard label="Synergies" value={KNOWN_SYNERGIES.length} color={T.positive} />
    <MetricCard label="Conflicts" value={KNOWN_CONFLICTS.length} color={T.danger} />
    <MetricCard label="Pipelines" value={CANONICAL_PIPELINES.length} color={T.accent} />
  </div>
</header>
```

Remove the footer legends (lines 3463-3482) entirely. The family color legend can be moved to the Explore tab if needed.


## 10. LEVEL_COLOR System Removal (lines 39-48)

### Delete
```javascript
const LEVEL_COLOR = { ... };
const lc = l => LEVEL_COLOR[l] || LEVEL_COLOR.used;
```

### Remove `level` prop from all Chip invocations
Lines 3428-3435: Replace epistemic-level chips with simple Tag components or remove entirely.
Lines 3468: Remove the footer epistemic legend.

### Update Chip component (line 1459)
Remove the `level` parameter, the `lc()` lookup, and the conditional dot rendering. Or better: replace Chip with the Tag component from section 5d.


## 11. Responsive Breakpoints

Add to the global CSS:

```css
@media (max-width: 768px) {
  /* Tab bar: allow horizontal scroll */
  [role="tablist"] {
    flex-wrap: nowrap !important;
    overflow-x: auto !important;
    -webkit-overflow-scrolling: touch;
  }
  /* Reduce container padding */
  .app-container {
    padding: 16px 16px 32px !important;
  }
  /* Stack grids to single column */
  .grid-auto {
    grid-template-columns: 1fr !important;
  }
  /* Hide matrix tab on mobile -- it requires hover */
  .matrix-container { display: none; }
  .matrix-mobile-notice { display: block; }
}
```

Since this is inline-style React without CSS classes, the responsive approach must be done via a `useMediaQuery` hook:

```javascript
function useMediaQuery(query) {
  const [matches, setMatches] = useState(
    () => window.matchMedia(query).matches
  );
  useEffect(() => {
    const mql = window.matchMedia(query);
    const handler = e => setMatches(e.matches);
    mql.addEventListener("change", handler);
    return () => mql.removeEventListener("change", handler);
  }, [query]);
  return matches;
}

// Usage in App:
const isMobile = useMediaQuery("(max-width: 768px)");
```

Then conditionally apply mobile-specific styles:
- Grid columns: `gridTemplateColumns: isMobile ? "1fr" : "repeat(auto-fill, minmax(380px, 1fr))"`
- Container padding: `padding: isMobile ? \`${T.sp.lg}px\` : \`${T.sp.xl}px ${T.sp.xxl}px\``
- Matrix tab: show a "Matrix requires desktop" message instead of the SVG
- Graph SVG: reduce GW to 600, increase node font to 9px


## Summary of Changes by Priority

### Phase 1 (Accessibility / P0)
1. Update `T.text3` to `#8a8999`
2. Replace all font sizes below 0.65rem with `T.fs.xs`
3. Add `:focus-visible` global style
4. Add `role`, `tabIndex`, `aria-*` attributes to TabBar, ExpandableCard
5. Style range inputs for dark theme

### Phase 2 (Structure / P1)
6. Consolidate 8 tabs to 4 + sub-tabs
7. Implement `ExpandableCard` component with measured heights
8. Implement `T.fs` type scale (replace all 18 sizes with 6)
9. Implement `T.sp` spacing scale
10. Split TechCard into Tier 1 (inline) + Tier 2 (drawer/detail)

### Phase 3 (Polish / P2)
11. Simplify color palette (remove mid variants, merge teal/crimson/silver)
12. Remove epistemic color system
13. Add hover states to cards (background change)
14. Replace global `button:hover opacity` with `filter: brightness`
15. Add skeleton loading states
16. Simplify header (remove epistemic chips, reduce to 4 metric cards)
17. Remove footer legends

### Phase 4 (Responsive / P2)
18. Add `useMediaQuery` hook
19. Apply mobile-conditional grid columns
20. Make tab bar horizontally scrollable
21. Hide Matrix SVG on mobile with fallback message
