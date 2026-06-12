---
name: edgedelta-skills
description: Edge Delta skills for AI agents. Pipelines, logs, metrics, traces, monitors and AI Teammate.
metadata:
  version: "1.0.0"
---

# Edge Delta Skills

Essential Edge Delta skills for AI agents, built on the `edx` CLI.

## Core Skills

| Skill | Description |
|-------|-------------|
| **ed-edx** | Primary CLI - all edx commands, auth, setup |
| **ed-logs** | Search logs with CQL, log volume graphs |
| **ed-patterns** | Log patterns, anomaly and sentiment analysis |
| **ed-metrics** | Discover and aggregate metrics |
| **ed-traces** | Distributed traces and the service map |
| **ed-events** | Events: anomalies, monitor alerts, K8s events |
| **ed-monitors** | Create, manage and resolve monitors |
| **ed-pipelines** | Fleet management, config changes, deployments, live capture |
| **ed-investigate** | Cross-signal incident investigation workflow |
| **ed-ai-teammate** | AI Teammate connectors and activity |

## Install

```bash
npx skills add edgedelta/agent-skills \
  --skill ed-edx \
  --skill ed-logs \
  --skill ed-patterns \
  --skill ed-metrics \
  --skill ed-traces \
  --skill ed-monitors \
  --skill ed-pipelines \
  --full-depth -y
```

## Prerequisites

The `edx` CLI must be installed and authenticated. See the **ed-edx** skill or
[edgedelta/edx](https://github.com/edgedelta/edx).

## Command Execution Policy

Use this order for scoped commands:

1. Check context first (conversation, prior outputs, known values).
2. Run discovery commands when required values are missing
   (`edx facets keys`, `edx facets options`, `edx pipelines list`).
3. Ask the user only when values remain ambiguous.
4. Run the target command after required inputs are known.
5. Avoid speculative commands likely to fail.

## Quick Reference

| Task | Command |
|------|---------|
| Search error logs | `edx logs search -q 'severity_text:"ERROR"' --lookback 1h` |
| Top log patterns | `edx patterns list --summary --lookback 1h` |
| Query a metric | `edx metrics query --name system.cpu.usage --agg avg` |
| Find failed spans | `edx traces search -q 'status.code:"ERROR"' --lookback 1h` |
| Recent anomalies | `edx events search -q 'event.type:"pattern_anomaly"'` |
| List monitors | `edx monitors list --output table` |
| List pipelines | `edx pipelines list --output table` |
| Live capture | `edx capture start <conf-id> --duration 2m` |
| Check auth | `edx auth status` |

## Auth

```bash
edx auth login --token <api-token> --org-id <org-id>
edx auth status
```

Or set `ED_API_TOKEN` and `ED_ORG_ID` environment variables.
