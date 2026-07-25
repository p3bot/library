# Review Types Change Record

A complete record of the consolidation applied to docs/review-types.md on 2026-07-25. It captures the analysis that prompted the change, every decision taken and rejected, the item-level movement of the entire framework, and the work left open. It is a design record, not a release changelog.

## Starting Point

The framework defined 17 review types holding 140 scope items. The immediately preceding commit had decoupled the review subject from the review type, split UI concerns out of Correctness into a new UI/UX type, and rewritten change-centric wording to be subject-neutral.

| Type | Items |
| --- | --- |
| Holistic | 7 |
| Security | 19 |
| Correctness | 7 |
| Architecture | 14 |
| Concurrency | 9 |
| Standards | 5 |
| Privacy | 11 |
| Observability | 8 |
| Performance | 10 |
| Error Handling | 9 |
| Testing | 11 |
| Readability | 6 |
| Dependency | 5 |
| Infrastructure | 8 |
| Duplication | 3 |
| Documentation | 5 |
| UI/UX | 3 |

## Problem Statement

Two problems were identified, in this order.

Coverage. A gap analysis against the question "can this framework drive a comprehensive review of a codebase" found eight genuine holes, five under-developed types, and three framework-level omissions.

Complexity. Seventeen top-level types was judged too many. The pain was diagnosed during discussion as selection complexity: the number of choices a reader must hold in mind to pick a type and to know where a finding belongs. It was explicitly not about run cost, and not about the volume of scope items, which was set aside for a later pass.

The two problems were solved together. Closing the gaps by appending types would have taken the count to 18 or 19; instead the gaps were used as evidence for where the type boundaries were drawn wrongly, and were absorbed by relocation.

## Gap Analysis

### Gaps identified and closed

| Gap | Why it was uncovered | Where it landed |
| --- | --- | --- |
| Recoverability and data durability | Failure Isolation, Chaos Testing, and Deployment Rollback all addressed degradation or in-flight failure, never loss of state. Privacy's Retention and Deletion covered deliberate erasure, the opposite problem | Operability, Recovery cluster, 6 items |
| Build, release, and first-party supply chain | Dependency reviewed what came in; nothing reviewed what went out. CI/CD appeared only as a passing phrase inside Holistic's Project Hygiene | Supply Chain, 5 items |
| Multi-tenancy and isolation | AuthZ, IDOR, and Privilege Escalation framed single-tenant access; nothing framed tenant-boundary bleed through shared caches, queues, jobs, or indices | Security, Tenant Isolation |
| Numeric precision, time handling, absent values | Correctness listed Boundary and Off-by-one but omitted its three closest sibling bug families | Correctness, 3 items |
| Portability and compatibility | No home for supported runtime matrix, path, encoding, or locale assumptions. Standards' i18n covered localisation only | Architecture, Portability and Runtime Compatibility |
| First-party licensing and IP | Dependency covered third-party licence compatibility only; nothing covered the subject's own licence, vendored code, or attribution | Supply Chain, First-Party Licensing and Attribution |
| Dead code and unused surface | Holistic's Codebase Atrophy covered macro rot only; nothing covered unreachable branches, unused exports, or stale flags | Maintainability, Dead Code and Unused Surface |
| Thin UI/UX | Three items against Security's nineteen, with Accessibility stranded in Standards | Experience, expanded 3 to 11 items |

### Gaps identified and not closed

These were raised, judged real, and left out of this change. They remain open.

- AI and LLM integration review: prompt injection through untrusted content, tool-permission scope, validation of model output before acting on it, non-determinism in tests, token and context budget. Raised as particularly relevant given this repository ships an agent launcher whose modules are themselves prompts. Deferred as a scope decision about the framework's reach rather than an omission within it
- Observability: metric cardinality and telemetry cost control, log retention
- Error handling: actionability of the user-facing and operator-facing error message, as distinct from leakage of sensitive data
- Infrastructure: capacity planning, quotas, and limits
- Security: time-of-check to time-of-use, and secrets committed to version control history

### Framework-level gaps

- No overlap or ownership policy. A comprehensive review runs many types and will emit the same finding more than once. Dependency Vulnerabilities appeared in both Security and Dependency; Privacy's Telemetry and Diagnostic Surfaces overlaps Observability; Error Handling's Sensitive Data in Errors overlaps Security's Data Protection. Only the first was resolved in this change, by relocation. No general policy was added
- The Severity Rubric has no confidence axis. Five impact dimensions determine how bad a finding is if real, and nothing captures how sure the reviewer is, so a speculative Critical outranks a verified High. Not addressed
- Holistic's summary line claimed coverage "across all dimensions" while its purpose and scope described repository-level structural health. Resolved by dissolving the type

## Decisions

### Merge rather than add profiles

Two levers were considered for the complexity problem. Review profiles would have kept all 17 types as a vocabulary and defined a small number of bindable sets over them. Merging would have reduced the type count itself.

Merging was chosen because the diagnosis was conceptual rather than cost-driven. The supporting evidence was the thin types: Duplication at 3 items, UI/UX at 3, Standards at 5, Documentation at 5. The test applied was that a type earns its place if it is one pass, with one expert lens, and its own failure vocabulary. Duplication failed it because nobody reviews for duplication alone. Standards failed it because its five items were three unrelated lenses wearing one label.

The profile idea was not discarded. Holistic's dissolution depends on it: "survey everything at a high level" is now expressed as selecting all types at low depth.

### Dissolve Holistic

Judged not a lens but a breadth setting wearing a lens's clothes, which is what produced its self-contradicting summary line. All seven items had better homes, so the type was removed without loss.

### Fold Infrastructure into Operability

Proposed as the last defensible merge and taken. The known cost was recorded at the time: it produces a 32-item type spanning two audiences, the code path and the platform. The stated mitigation was to cluster its scope under labelled groups rather than present a flat list of 32, and to expect the later scope purge to bite hardest here.

### Stop at ten

A floor was named during discussion. A review pass carrying thirty concerns produces a shallower review than two passes of fifteen, because attention is finite whether the reviewer is human or an agent. Below roughly nine types, merges stop being consolidation and start being dilution. Two further merges were explicitly considered and rejected on that basis: Supply Chain into Security, and Testing into Correctness.

### Add families

Ten types is still ten choices. Five families of one to three types each were added so a reader holds five things and then descends. Families are a navigation aid only; a review binds types, never families.

## Type Mapping

17 types to 10, in five families.

| Family | Type | Composed from |
| --- | --- | --- |
| Does It Work | Correctness | Correctness + Concurrency + 3 new items |
| | Testing | Testing, unchanged |
| Is It Safe | Security | Security − Dependency Vulnerabilities + 2 new items |
| | Compliance | Standards (regulatory, industry, organisational) + Privacy |
| Will It Hold Up | Performance | Performance, unchanged |
| | Operability | Error Handling + Observability + Infrastructure + 2 Architecture items + Documentation's runbooks + 5 new items |
| Can We Live With It | Architecture | Architecture − 2 items + 3 Holistic items + 1 new item |
| | Maintainability | Readability + Duplication + Documentation − runbooks + 3 Holistic items + 1 new item |
| | Supply Chain | Dependency + Security's Dependency Vulnerabilities + Holistic's Project Hygiene + 5 new items |
| Does It Serve The User | Experience | UI/UX + Standards' accessibility and i18n + 6 new items |

Item totals moved from 140 to 162: 23 items added, 1 pair merged into a single item, nothing discarded.

| Type | Items |
| --- | --- |
| Correctness | 19 |
| Testing | 11 |
| Security | 20 |
| Compliance | 14 |
| Performance | 10 |
| Operability | 32 |
| Architecture | 16 |
| Maintainability | 17 |
| Supply Chain | 12 |
| Experience | 11 |

## Item Movement

### Types dissolved

Holistic, all seven items relocated:

| Item | Destination |
| --- | --- |
| Conceptual Integrity | Maintainability |
| Codebase Atrophy | Maintainability |
| Cognitive Profile | Maintainability |
| Repository Structure | Architecture |
| Solution Fit | Architecture |
| Tech Stack Coherence | Architecture |
| Project Hygiene | Supply Chain |

Standards, all five items relocated:

| Item | Destination |
| --- | --- |
| Regulatory Compliance | Compliance |
| Industry Standards | Compliance |
| Organisational Standards | Compliance |
| Accessibility (WCAG/ARIA) | Experience |
| Internationalisation (i18n) | Experience |

Documentation, all five items relocated:

| Item | Destination |
| --- | --- |
| External Accuracy | Maintainability |
| Developer Onboarding | Maintainability |
| Decision Records | Maintainability |
| Change Transparency | Maintainability |
| Operational Runbooks | Operability, Recovery cluster |

### Types absorbed whole

| Source type | Items | Destination |
| --- | --- | --- |
| Concurrency | 9 | Correctness |
| Privacy | 11 | Compliance |
| Error Handling | 9 | Operability, Failure handling cluster |
| Observability | 8 | Operability, Telemetry cluster |
| Infrastructure | 8, one merged away | Operability, Environment cluster |
| Readability | 6 | Maintainability |
| Duplication | 3 | Maintainability |
| Dependency | 5, one renamed | Supply Chain |
| UI/UX | 3 | Experience |

### Individual relocations

| Item | From | To | Reason |
| --- | --- | --- | --- |
| Failure Isolation | Architecture | Operability | Operational rather than structural, and it pairs with retries and degradation |
| Idempotency | Architecture | Operability | Exists to make retry safe, so it belongs with retry |
| Dependency Vulnerabilities | Security | Supply Chain | Removes the framework's one exact duplicate |

### Items merged

Architecture's Failure Isolation and Infrastructure's Failure Containment both landed in Operability, where they read as redundant. They became one item, Failure Isolation and Containment, covering circuit breakers and bulkheads at the code level and partitioning of a misconfiguration or failed deployment at the infrastructure level.

### Items renamed

| Before | After | Reason |
| --- | --- | --- |
| License and Security | Licence Compatibility | The security half duplicated Dependency Vulnerabilities, now a separate item; spelling brought to Australian English |
| UI/UX Review | Experience Review | Scope widened past the rendered interface to reach, input method, and content |

### Items added

Correctness:

- Numeric Precision and Overflow
- Time and Clock Handling
- Absent Value Handling

Security:

- Tenant Isolation
- Webhook and Callback Verification

Operability, Recovery cluster:

- Backup Coverage and Restore Verification
- Recovery Objectives
- Point-in-Time and Data Rollback
- Backup Isolation and Immutability
- Corruption Detection and Reconciliation

Architecture:

- Portability and Runtime Compatibility

Maintainability:

- Dead Code and Unused Surface

Supply Chain:

- First-Party Licensing and Attribution
- Build Reproducibility
- Artefact Provenance
- Pipeline Security
- Release and Deprecation Policy

Experience:

- State Coverage
- Keyboard and Focus Management
- Form and Validation Feedback
- Content and Microcopy
- Theming and Visual Preferences
- Perceived Performance

## Structural Changes

- Families introduced as `##` sections, types demoted to `###`, keeping the depth limit
- Numbered type headings dropped. They forced renumbering on every edit and nothing referenced types by number
- The Summary table became a Review Families table carrying family, type, and purpose
- Operability is the only type whose scope is clustered, under Failure handling, Telemetry, Recovery, and Environment, with a lead-in sentence explaining the split. Every other type keeps a flat list
- The Review Subject section's example was changed from Holistic to Architecture, since Holistic no longer exists
- The Severity Rubric is unchanged

## Judgement Calls Made Inside the Sign-off

Two decisions were taken during writing that the agreed mapping table did not specify.

Operational Runbooks moved to Operability rather than Maintainability. The mapping table showed Documentation moving to Maintainability wholesale, but the earlier exchange had proposed splitting runbooks out as operational and that framing was endorsed. It now sits in the Recovery cluster, where it supports the recovery gap directly.

Failure Isolation and Failure Containment were merged, as recorded above. The mapping implied both would survive as separate items in the same type.

## Flagged, Not Actioned

- Deployment and Rollback Safety stayed in Architecture per the agreed mapping, but now sits one type away from Environment Reproducibility, Drift Detection, and Point-in-Time and Data Rollback, which are its natural neighbours. Candidate for a later move
- Scope item purge. Deferred by agreement. Total item count rose from 140 to 162, and the initial read was that ten to fifteen items across the framework are low-yield or restate a sibling. Operability at 32 items is the densest target
- Downstream module churn. `tasks/review/` holds 21 published modules, of which roughly a dozen are named for types that no longer exist: holistic, concurrency, duplication, readability, documentation, dependency, error-handling, observability, standards. These are published to the CUE Central Registry and consumers are pinned to them, so renaming or retiring them is a versioning decision, not a rename. It must be settled before the revised framework is relied upon
