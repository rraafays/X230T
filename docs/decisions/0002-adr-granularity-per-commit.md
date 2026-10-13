# ADR granularity per commit

## Context and Problem Statement

We record decisions with MADR in `docs/decisions/`. ADRs must stay useful without documenting every tiny edit. When should a new ADR be written?

## Considered Options

- One ADR per git commit when that commit is decision-worthy
- One ADR per agent task or pull request
- One ADR per non-trivial code change (before commit)
- ADR only when explicitly requested

## Decision Outcome

Chosen option: "One ADR per git commit when that commit is decision-worthy", because commits are the unit of history we already review and revert; tying ADRs to commits keeps the log aligned with `git log` without forcing an ADR on formatting-only or typo commits. Missing ADRs can be added retroactively after commit.

### Consequences

- Good, because ADR count stays proportional to meaningful history
- Good, because retroactive ADRs can recover decisions from past commits
- Good, because agents skip ADRs for mechanical fixes
- Bad, because a commit may land before its ADR unless someone backfills
- Bad, because "decision-worthy" still needs judgment at commit time
