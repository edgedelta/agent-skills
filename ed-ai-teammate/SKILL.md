---
name: ed-ai-teammate
description: AI Teammate - issues raised by teammates, threads, channels, teammates (agents), connectors and activity.
metadata:
  version: "1.1.0"
  author: edgedelta
  repository: https://github.com/edgedelta/agent-skills
  tags: edgedelta,ai,teammate,issues,threads,connectors
  alwaysApply: "false"
---

# Edge Delta AI Teammate

AI Teammates watch connected tools (PagerDuty, Slack, GitHub, ...), raise
**issues**, and work them in **threads** inside **channels**. This skill covers
issues, threads, channels and teammates, plus the **connectors** that feed them
and teammate **activity**.

Issues/threads/channels are served by the chat service and teammates by the
agent service — `edx` routes to the right host automatically based on the
active environment (`--env` / `ED_ENV`). The issues API is rolling out to
production; until it lands, target staging with `--env staging`.

## Prerequisites

The `edx` CLI must be installed and authenticated. See the **ed-edx** skill.

## Issues

```bash
edx ai issues list                       # open issues (add --include-closed for all)
edx ai issues list --with-threads        # include each issue's threads
edx ai issues critical --limit 10        # most critical open issues, ranked
edx ai issues health                     # current health score (from open issues)
edx ai issues timeline --lookback 24h    # health-score timeline
edx ai issues get <issue-id> --with-threads
edx ai issues threads <issue-id>         # threads attached to an issue
edx ai issues close <issue-id>           # mark resolved
```

Table view is handy for triage:

```bash
edx ai issues list -o table --columns issueId,severity,state,title
```

## Channels, threads & teammates

```bash
edx ai channels list                                     # channels (note the channel id)
edx ai channels get <channel-id>
edx ai channels messages <channel-id>

edx ai threads list --channel <channel-id>               # threads are scoped to a channel
edx ai threads get --channel <channel-id> <thread-id>
edx ai threads messages --channel <channel-id> <thread-id>

edx ai agents list                                       # AI teammates (agents)
edx ai agents get <agent-id>
```

## Connectors & activity

```bash
edx ai connectors list             # configured connectors
edx ai connectors specs            # available connector types + required fields
edx ai connectors environments     # where connectors can run
edx ai activity --lookback 24h     # teammate activity metrics
```

## Add or Update a Connector

1. Find the connector type and its required fields:

```bash
edx ai connectors specs --output json | jq '.[] | select(.type=="pagerduty")'
```

2. Build the request JSON per the spec (type, name, credentials/settings).

3. Apply it:

```bash
edx ai connectors update --file connector.json
```

Connector data flows through an ingestion pipeline that Edge Delta provisions
automatically; check it with `edx pipelines list --keyword ai`.

## Remove a Connector

The delete request body identifies the connector (same shape as update):

```bash
edx ai connectors delete --file connector.json --yes
```

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Connector not ingesting | `edx pipelines list --keyword ai` then `edx health problems` |
| Unknown required fields | `edx ai connectors specs` is the source of truth |
| Credential errors | Re-apply with `edx ai connectors update --file` and fresh secrets |
