# Human-readable rules in docs/rules

## Context and Problem Statement

Cursor loads `.cursor/rules/*.mdc` for IDE agents. Humans and other tools need the same conventions in readable prose without Cursor frontmatter, and agents outside Cursor should discover how to work on the repo from the tree alone.

## Considered Options

- `.cursor/rules/` only
- `docs/rules/` only
- Dual maintenance: `docs/rules/` for humans and portable agents, `.cursor/rules/` for Cursor bindings

## Decision Outcome

Chosen option: "Dual maintenance: `docs/rules/` for humans and portable agents, `.cursor/rules/` for Cursor bindings", because each audience gets the right format while `docs-rules-sync` requires keeping policy aligned when it changes.

### Consequences

- Good, because philosophy and module conventions are browsable in git without Cursor
- Good, because future agents can be pointed at `docs/rules/README.md`
- Bad, because two files must update together when policy changes
- Bad, because drift is possible if only one location is edited

Related change: introduction of `docs/rules/` and `docs-rules-sync.mdc`.
