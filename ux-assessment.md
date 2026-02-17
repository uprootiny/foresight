# Foresight Compendium -- Structured UX Assessment

## Tab-Level Scoring (1-10)

### Techniques Tab
| Dimension        | Score | Notes |
|------------------|-------|-------|
| Clarity          | 6/10  | Card layout is logical but expanded state overwhelms with 14 sections |
| Information Density | 4/10 | Collapsed: good. Expanded: excessive. 25-30 chips per expanded card |
| Interactivity    | 5/10  | Search and family filter work. No sort, no compare, no bookmark |
| Visual Polish    | 7/10  | Colored top bars, StatusDots, family badges -- cohesive within this tab |

### Composer Tab
| Dimension        | Score | Notes |
|------------------|-------|-------|
| Clarity          | 7/10  | Pipeline flow is visually clear with arrows and scores |
| Information Density | 6/10 | Three sections (pipeline, checks, palette) are well separated |
| Interactivity    | 8/10  | Click-to-add, click-to-remove, load canonical -- best interaction design |
| Visual Polish    | 7/10  | Score colors, progress bars, pair-check cards are well designed |

### Matrix Tab
| Dimension        | Score | Notes |
|------------------|-------|-------|
| Clarity          | 5/10  | Heatmap is readable at family filter level but 35x35 is too dense |
| Information Density | 3/10 | 1225 cells with no way to filter by score range or highlight patterns |
| Interactivity    | 6/10  | Hover-to-detail works but no click, no row/col highlighting |
| Visual Polish    | 6/10  | Color legend present; rotated labels are hard to read at small cell sizes |

### Principles Tab
| Dimension        | Score | Notes |
|------------------|-------|-------|
| Clarity          | 8/10  | Clean expand/collapse, rule + examples is a natural structure |
| Information Density | 8/10 | 12 items is manageable; expanded content is proportionate |
| Interactivity    | 6/10  | Expand/collapse, filter by category. Expand All/Collapse All is good |
| Visual Polish    | 7/10  | Consistent category colors, badge numbering, StatusDots |

### Condensed Logs Tab
| Dimension        | Score | Notes |
|------------------|-------|-------|
| Clarity          | 5/10  | Three unrelated sections (schema, operators, archetypes) in one tab |
| Information Density | 4/10 | 22 operators with formulas and cross-refs create a wall of text |
| Interactivity    | 5/10  | Category filter on operators, expandable archetypes. No search |
| Visual Polish    | 6/10  | Left-border color coding is nice; formula chips are visually distinct |

### Graph Tab
| Dimension        | Score | Notes |
|------------------|-------|-------|
| Clarity          | 6/10  | Column layout of nodes is logical; edge spaghetti at full scale |
| Information Density | 7/10 | Graph is appropriately information-dense; panels below are manageable |
| Interactivity    | 9/10  | Click nodes, hover edges, discover paths, percolate feeds, canonical overlay |
| Visual Polish    | 8/10  | Animated glow rings, edge dimming, percolation sparklines -- the most polished tab |

### Causal Tab
| Dimension        | Score | Notes |
|------------------|-------|-------|
| Clarity          | 4/10  | Hilbert space concepts are inherently complex; the UI does not simplify them |
| Information Density | 3/10 | Summary grid + 6 concept cards + lab controls + 4 result panels + 35 mappings |
| Interactivity    | 7/10  | Sliders, experiment runner, expandable cards -- functional |
| Visual Polish    | 6/10  | Consistent with other tabs but default browser sliders break the dark theme |

### Observatory Tab
| Dimension        | Score | Notes |
|------------------|-------|-------|
| Clarity          | 5/10  | Good empty state, but loaded state is a vertical scroll marathon |
| Information Density | 3/10 | 12 stat cards + ACF chart + recommendations + pipelines = extreme |
| Interactivity    | 7/10  | Feed selection is intuitive; active state on selected feed button is clear |
| Visual Polish    | 6/10  | Sparklines are attractive; stat cards are uniform to the point of monotony |


## System-Level Scoring (1-10)

### Navigation: 4/10
- 8 flat tabs with no grouping or hierarchy
- No indication of which tab is "start here"
- Tab labels compete for space at 0.72rem mono
- No breadcrumbs, no back navigation within tabs
- No keyboard navigation between tabs (no arrow key support)
- Mobile: tabs will overflow or become unreadable

### Typography: 5/10
- Three font families is correct (display, body, mono)
- Too many sizes in use: 0.5, 0.52, 0.55, 0.58, 0.6, 0.62, 0.65, 0.68, 0.72, 0.75, 0.78, 0.82, 0.85, 0.88, 0.95, 1.1, 1.6, 1.8rem -- that is 18 distinct font sizes
- Several sizes are indistinguishable at rendered pixels (0.55 vs 0.58 = 8.8px vs 9.3px)
- Monospace is overused for non-tabular content (descriptions, interpretations)
- Display font (Georgia) is underused -- only titles and metric values
- Line heights are inconsistent (1, 1.1, 1.5, 1.6 used in different places)

### Color System: 4/10
- 9 base colors x 3 variants = 27 color tokens is excessive
- Three separate color taxonomies overlap (epistemic levels, families, operators)
- Blue means three different things depending on context
- Epistemic color system in header/footer serves no functional purpose in tab content
- Dim variants (e.g., `rgba(74,143,231,0.15)`) are too similar across colors on dark backgrounds
- No documented rules for when to use base vs dim vs mid

### Component Library: 6/10
- Chip, Badge, StatusDot, Sparkline, ProgressBar, MetricCard, Section, Segmented, TabBar -- 9 reusable components
- Components are consistent within themselves
- Missing: Tooltip component (raw `title` attributes used instead), Modal/Drawer, Skeleton/Loader, Toast/Notification
- Card pattern is inconsistently implemented (TechCard, PrincipleCard are React components; archetype cards and Hilbert cards are inline JSX)
- No shared "expandable card" abstraction despite 4 implementations of the same pattern

### Responsiveness: 2/10
- No media queries
- No responsive typography
- Grid minmax values (380px, 320px, 260px, 180px, 160px, 150px) are desktop-assumed
- SVG visualizations (Matrix, Graph) have fixed conceptual dimensions
- Tab bar breaks on any screen under ~900px
- 32px horizontal padding wastes space on small screens


## Strengths to Preserve

1. **Composability engine** (lines 759-827): The `checkComposition()` function and its 8 checks are the intellectual core. The Composer tab's visual representation of pair scores with color-coded arrows is excellent UX.

2. **Graph tab interaction model** (lines 2674-3073): Node selection -> path discovery -> path selection -> percolation is a well-designed progressive disclosure flow. This is the best tab.

3. **Color-coded left borders on cards**: The `borderLeft: 3px solid ${color}` pattern (used in operators at line 2291, pipelines at line 2031, recommendations at line 2599) is a subtle, effective visual cue.

4. **Sparkline component** (lines 1495-1520): Clean, lightweight SVG sparklines with optional fill, mean line, and range labels. Well-executed data visualization primitive.

5. **Section component** (lines 1569-1582): The colored top bar + title + count badge pattern is a solid information container. Used consistently across all tabs.

6. **ProgressBar component** (lines 1549-1555): Simple, effective, with smooth CSS transition. Correctly sized at 6px default and 10px thick variant.

7. **Pipeline flow visualization** in Composer (lines 1938-1976): The horizontal chain of technique cards with score arrows between them is intuitive and scannable.

8. **Feed recommendation system** (lines 994-1076): The `recommendTechniques()` and `recommendPipelines()` functions that analyze data characteristics and suggest approaches are genuinely useful and unique.

9. **Design token centralization** (lines 20-37): All colors, radii, and font stacks in one `T` object. This is proper design token architecture.

10. **Data richness**: 35 techniques, 54 synergies, 30+ conflicts, 12 principles, 22 operators, 12 canonical pipelines -- the content is comprehensive and well-structured.


## Weaknesses to Fix (Prioritized)

### P0 -- Must Fix (Blocks Core Usability)

1. **text3 color fails WCAG AA** (line 23: `text3:"#5a596a"`). Used for labels, helper text, and meta-information across every tab. Contrast ratio of ~2.7:1 on bg2 is below the 4.5:1 minimum. Affects every user, every session. **Fix: lighten text3 to at minimum #7a7990 (~4.5:1 ratio).**

2. **Sub-9px font sizes throughout** (0.5rem at line 2309, 0.52rem at line 1637, 0.55rem at lines 1650/1689/etc.). Text below 9px is unreadable for most users and fails accessibility guidelines. Used for functionally important content like labels, cross-references, and pipeline roles. **Fix: establish 0.65rem (10.4px) as the minimum font size.**

3. **Tab bar breaks on mobile** (lines 1603-1618). Eight flex:1 tabs at 0.72rem mono will be unreadable or overflow on any screen under 900px. The primary navigation is broken on ~50% of devices. **Fix: implement responsive tab strategy (scrollable, collapsible, or reorganized).**

4. **No keyboard navigation**. No `tabIndex`, no `onKeyDown` handlers, no focus styles. All interactive elements are inaccessible to keyboard-only users. The entire application is unusable without a mouse. **Fix: add focus management and keyboard event handlers.**

### P1 -- Should Fix (Degrades Experience)

5. **18 font sizes with indistinguishable steps**. The type scale has no ratio or system. Adjacent sizes like 0.55rem and 0.58rem render at 8.8px and 9.3px -- a sub-pixel difference. **Fix: reduce to 5-6 sizes on a modular scale.**

6. **max-height:2000px transition on TechCard** (line 1646). Creates a perceivable lag when collapsing and a premature "pop" when opening. Affects the most-used interaction in the Techniques tab. **Fix: use JavaScript height measurement or switch to CSS `grid-template-rows: 0fr/1fr` animation.**

7. **Overlapping color semantics**. Blue = Statistical family = Level operator = Inferred epistemic level. Three separate taxonomies reuse the same 9 colors. Users cannot build reliable color-to-meaning associations. **Fix: define color usage rules per context and reduce palette overlap.**

8. **Expanded TechCard has 14 content sections**. This is information overload in a single card. Users need to scroll inside a card to see its full content, which is an anti-pattern. **Fix: use tabbed or stepped disclosure within the card, or move deep detail to a slide-out panel.**

9. **No loading skeletons in Observatory tab** (lines 2490-2494). A simple text indicator for multi-second API fetches. **Fix: add skeleton screens matching the layout of the analysis section.**

10. **Epistemic color system is decorative, not functional** (lines 39-48). The 8 epistemic levels appear in header/footer chips but serve no purpose in tab content. They add visual complexity without informational value. **Fix: remove from chrome unless integrated into actual content, or integrate them into technique/principle confidence levels.**

### P2 -- Nice to Fix (Polish and Refinement)

11. **Condensed Logs tab conflates three unrelated concerns**: CLR schema, operators, and archetypes. These should be separate tabs or sub-tabs.

12. **No sort/compare functionality in Techniques tab**. Users cannot sort by complexity, family, or leakage risk. Cannot select two techniques for side-by-side comparison.

13. **Matrix tab hover-only interaction**. Clicking a cell could select that pair and populate a detail view, or navigate to the Composer with that pair. Currently click does nothing.

14. **Segmented controls overflow with 10+ options** (Techniques family filter: "All" + 9 families = 10 buttons). They wrap across lines and become a block of tiny text.

15. **Missing tooltips on graph nodes**. The node labels truncate at 10 characters (line 2904: `t.name.length > 10 ? t.name.slice(0, 9) + "..."`) but have no tooltip to show the full name.

16. **Browser-default range inputs in Causal tab** (lines 3216-3227). These do not respect the dark theme -- track and thumb colors are OS-dependent.

17. **Global `button:hover { opacity:0.85 }` is lazy** (line 3414). All buttons dim uniformly on hover regardless of their role or importance.

18. **No empty state illustration**. Empty pipeline (line 1933), empty analysis (line 2662), and empty path list (line 2950) use plain mono text. A simple SVG illustration would improve these states.

19. **Footer epistemic level legend and family legend** (lines 3463-3482) take up 60+ pixels at the bottom of every tab. This is chrome that belongs in a settings or help panel, not permanently on screen.

20. **No URL routing**. Tab state is lost on page refresh. Deep-linking to a specific tab or technique is impossible.
