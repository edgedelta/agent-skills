---
name: ed-events
description: Events - pattern anomalies, monitor alert triggers and Kubernetes events.
metadata:
  version: "1.0.0"
  author: edgedelta
  repository: https://github.com/edgedelta/agent-skills
  tags: edgedelta,events,anomalies,alerts,kubernetes
  alwaysApply: "false"
---

# Edge Delta Events

Events are the "what happened" stream: anomaly detections, monitor alert
triggers and Kubernetes events. Always check events early in an incident -
they often point straight at the cause.

## Prerequisites

The `edx` CLI must be installed and authenticated. See the **ed-edx** skill.

## Event Types

| Query | Meaning |
|-------|---------|
| `event.type:"pattern_anomaly"` | Log anomaly detections |
| `event.type:"metric_threshold"` | Metric alert triggers |
| `event.type:"log_threshold"` | Log alert triggers |
| `event.domain:"Monitor"` | All monitor-triggered events |
| `event.domain:"K8s"` | Kubernetes events (OOMKilled, BackOff, ...) |

Discover the live set: `edx facets options --scope event --facet event.type`
and `--facet event.domain`.

## Search Events

```bash
# All anomalies in the last 6 hours
edx events search -q 'event.type:"pattern_anomaly"' --lookback 6h

# Anomalies for one service
edx events search -q 'service.name:"api" AND event.type:"pattern_anomaly"'

# Everything monitors fired recently, as a table
edx events search -q 'event.domain:"Monitor"' --output table

# Kubernetes trouble
edx events search -q 'event.domain:"K8s" AND OOMKilled' --lookback 24h
```

Full-text search is supported in the event scope (bare words work).

## Pagination - counting events over a long window

**A single page is a lower bound, never a total.** The response envelope is
`{query_id, items, next_cursor}`. `next_cursor` is always present: non-empty
means more results exist, `""` means the result set is complete. The default
`--limit` is 20, so an unqualified search over 30 days returns 20 events and a
cursor - reporting "20 events" from that is wrong.

Use `--all` to sweep the whole window (requires `edx` >= 0.20.0). It follows
`next_cursor` until the server reports the set complete and prints one
combined envelope (`{items, pages, total_items, next_cursor}`), with per-page
progress on stderr:

```bash
# Every monitor alert in the last 30 days, complete
edx events search -q 'event.domain:"Monitor"' --lookback 720h --all \
  --output-file alerts-30d.json
# stderr: page 1: 1000 item(s), 1000 total
#         page 2: 1000 item(s), 2000 total
#         ...
jq '.total_items, .pages' alerts-30d.json
```

The monitor domain is `"Monitor"` on current orgs (`"Monitor Alerts"` exists
on older data - `event.domain:("Monitor" OR "Monitor Alerts")` covers both).
Do not guess domain values; list the live set first:
`edx facets options --scope event --facet event.domain`.

- With `--all`, `--limit` is the **page size** and defaults to 1000 (the
  server's own default) rather than 20. Leave it alone unless you have a
  reason.
- `--all` is atomic: if any page fails, the command exits non-zero and prints
  **nothing**, so a partial sweep can never be misread as a complete one. A
  `total_items` you did receive is therefore always a true total.
- Long sweeps survive flaky pages: a failed page is retried a few times with
  backoff (the event search backend 500s transiently under load). If it still
  fails, the error names the cursor to resume from
  (`resume from this point with --all --cursor '...'`).
- Pair it with `--output-file` (see **ed-edx** > Large outputs); a 30-day
  monitor sweep is easily megabytes.

Paging by hand is still available when you want one page at a time - pass the
previous response's `next_cursor` and keep the query and time flags identical:

```bash
edx events search -q 'event.domain:"Monitor"' --lookback 720h --limit 1000
# -> "next_cursor": "PP-FAwEBBmN1cnNvcg..."   (opaque - pass it back verbatim)
edx events search -q 'event.domain:"Monitor"' --lookback 720h --limit 1000 \
  --cursor 'PP-FAwEBBmN1cnNvcg...'
# repeat until "next_cursor": ""
```

Without `--all`, edx prints a note **on stderr** when a page leaves results
behind (`more results exist: re-run with --cursor ...`). Keep stderr separate
from stdout when piping to `jq` - `2>&1 | jq` will choke on that note.

There is no server-side cap on the limit and no maximum time window for event
search, so the sweep is bounded only by the result set itself.

## Incident Usage

1. Establish the incident window (from the page/alert).
2. `edx events search --from <start> --to <end>` - what fired in the window?
3. Pattern anomalies name the service and signature - pivot to
   `edx patterns list` / `edx logs search` for detail.
4. Monitor alerts carry the monitor ID - `edx monitors get <id>` for the
   query and thresholds behind it.
