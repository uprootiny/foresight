# Foresight Project — Cadence Analysis

## Prompt History: 36 prompts across 2 active days

### Pattern: Bursty nocturnal development

| Metric | Value |
|--------|-------|
| Total prompts | 36 |
| Active days | 2 (Feb 15, Feb 17) |
| Avg prompts/day | 18 |
| Median inter-prompt gap | 1.8 min |
| Peak hours (UTC) | 02:00, 06:00, 11:00 |
| Burst events | 6 (3+ prompts within 5min) |

### Time Distribution

```
02:00  ████████   8 prompts
05:00  ███        3
06:00  █████████  9 prompts (peak)
11:00  ███████    7
13:00  ███        3
14:00  ███        3
23:00  ███        3
```

### Gap Distribution

```
<1min   ████████████████  16 (46%) — rapid-fire within bursts
1-5min  ███████            7 (20%) — intra-session thinking pauses
5-15min ██████             6 (17%) — reading/reviewing code
15-60m  ██                 2 (6%)  — context switches
1-4hr   ██                 2 (6%)  — breaks
>4hr    ██                 2 (6%)  — sleep/away
```

### Burst Events

1. **Feb 15 11:31** — 5 prompts: Project kickoff, initial spec
2. **Feb 15 23:55** — 3 prompts: Late-night UX review
3. **Feb 17 02:43** — 5 prompts: Major causal tab rewrite
4. **Feb 17 05:44** — 3 prompts: Feed infrastructure push
5. **Feb 17 06:00** — 3 prompts: Live URL requests
6. **Feb 17 06:17** — 4 prompts: Repo cleanup, cadence discussion

### Observations

1. **Work happens in bursts, not streams.** 46% of prompts arrive <1 min apart, then long silences. This matches a "think → burst → review → burst" pattern.

2. **No steady cadence exists.** There's no scheduled rhythm — development is reactive and opportunistic. The project would benefit from a defined refresh cadence (e.g., daily feed health check, weekly data snapshot).

3. **Two sessions, one dominant.** Session `aab03aab` carries 86% of all prompts. The project has been a single sustained effort, not distributed work.

4. **Night bias.** Peak activity at 02:00 and 06:00 UTC suggests a single timezone (CET/CEST evening-to-morning) developer pattern.

### Recommended Cadences

| Cadence | Frequency | What |
|---------|-----------|------|
| Feed health | Every 15 min | `health.sh` via cron, write to status file |
| Data snapshot | Daily | Prefetch all feeds, cache to disk |
| Benchmark run | Weekly | Full benchmark suite, track drift |
| Dependency check | Weekly | Verify CDN URLs (React, Babel) still resolve |
| Commit hygiene | Per-session | Stage meaningful changesets, not WIP |
