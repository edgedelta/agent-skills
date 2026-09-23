---
name: ed-onboard
description: Connect customer systems to Edge Delta across cloud providers, on-premises and hybrid environments. Discover telemetry sources, choose supported collection paths, configure pipelines and agents, and verify logs, metrics and traces. Use for first-time onboarding or adding sources.
metadata:
  version: "1.0.0"
  author: edgedelta
  repository: https://github.com/edgedelta/agent-skills
  tags: edgedelta,onboarding,telemetry,integrations
---

# Onboard telemetry to Edge Delta

Start from the customer's systems and requested signals, not a cloud provider or a
fixed list of services. This applies to hosts, containers, Kubernetes, applications,
databases, managed services and other telemetry-producing systems. A source does not
need its own recipe in this skill to be onboarded.

Use **ed-edx** for Edge Delta operations and the environment's existing tools, provider
CLI, APIs or infrastructure as code for deployment. Use **ed-pipelines** for pipeline
lifecycle and **ed-pipeline-tuning** for processing. Keep environment credentials and
context separate from the Edge Delta organization/profile.

## Collection principles

- Minimize hops and duplicate ingestion. Prefer native push directly to a compatible
  Edge Delta receiver, or an Edge Delta agent close to the source when collection or
  local processing is needed. For pull sources, let a supported Edge Delta source pull.
- Prefer Edge Delta agents over another collector. Add an intermediary or collector
  only for a verified requirement, explaining its operational and cost implications.
  Existing use of a provider's logging service does not make it the preferred path.
- Decide per signal. Application/client telemetry does not establish host, service or
  database-server coverage. An agent does not manufacture application traces or gain
  access to a managed service's private filesystem.
- A missing direct path is a gap to explain, not a reason to silently omit a requested
  signal. Propose the shortest supported alternative and honor existing authorization
  for exceptions. Do not promise an integration based only on a similar product name.
- Verify the real source path. Do not fetch infrastructure data in an ad-hoc script and
  resubmit it as proof that an Edge Delta source supports the integration. Application
  instrumentation may emit its own measured activity.
- Preserve existing collection until its replacement is verified. Retire duplicate
  paths only within scope and honor explicit retention instructions.

## Adapt to the environment

Discover the user's chosen environment boundaries: provider/account/project/subscription,
cluster/context, hosts, region or datacenter as applicable. Identify actual resources,
current telemetry paths, agents and ownership. Inspect only the authorized scope; access
denied means inaccessible, not absent. Do not create demo infrastructure merely because
discovery returned an empty result.

Track requested logs, metrics and traces per resource, with selected source/path,
capability gaps, necessary exceptions and evidence/status. For a simple source this can
be a short note rather than a formal plan. Revisit choices as discovery reveals constraints.

Choose by source capabilities using [collection paths](references/collection-paths.md).
Inspect supported inputs, formats, authentication and deployment options for the actual
Edge Delta runtime. Read [cloud hints](references/cloud-hints.md) only when relevant;
these are optional examples, not a supported-provider list or the default workflow.

Prepare and apply changes through the customer's existing ownership mechanism. Reuse
appropriate resources, reconcile uncertain creates before retrying, and track created
IDs immediately. Existing authorization to perform the work is sufficient; ask only for
missing scope or an action outside it. Keep credentials out of artifacts and use the
customer's secret-delivery mechanism for agent credentials.

Verify with [verification](references/verification.md), distinguishing deployment health,
source receipt, correct processing and indexed telemetry. Report partial coverage and
unverified signals explicitly. Keep a proportionate [handoff](references/handoff.md) for
work spanning sessions or involving created resources. No fixed command stages or
backend onboarding state are required.

When asked to retain a test, keep agents and workloads running. When cleanup is authorized,
remove only owned resources in dependency order and verify residuals. Deleting a pipeline
configuration does not uninstall its agents or delete external infrastructure.

## Pipeline authoring

Follow **ed-pipelines** for directly attached multiprocessors: each application source
and destination gets a `type: sequence` named `<node-name>_multiprocessor`, even when
empty. Standalone intermediate processors do not replace these attachments. Preserve
default direct self-telemetry/internal-statistics routing.

Give nested processors meaningful display names through JSON-encoded `metadata.name`,
including Custom OTTL. Preserve existing metadata and processing semantics.

Validate configurations and test representative inputs and expected outputs before
promoting transformations. Check signal identity, value/unit, original timestamp,
filter exclusions and unintended extra outputs. Use existing edx preview/live-capture
capabilities; this skill does not require a bundled test runner or deployment script.
