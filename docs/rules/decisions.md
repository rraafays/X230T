# Architecture decisions (MADR)

We use [MADR minimal](https://github.com/adr/madr/blob/develop/template/adr-template-minimal.md) in `docs/decisions/`.

## Sections

1. Context and Problem Statement  
2. Considered Options  
3. Decision Outcome  
4. Consequences (Good / Bad under outcome)

Copy `docs/decisions/adr-template-minimal.md` for new records. Use the next free four-digit id (see index in `docs/decisions/README.md`).

## Granularity

- **Not** every tiny edit—no ADR for typos or format-only commits.
- **Yes** when a **git commit** is decision-worthy (someone would ask “why?”).
- Add the ADR with the change, **after commit**, or **retroactively** from `git log` / `git show` when backfilling.

## AskQuestion

When drafting an ADR and content is not already clear, use AskQuestion (MCQs) for problem, options, chosen outcome, and consequences if needed.

## Format

Format ADR markdown with the same headless Neovim pass as other docs.
