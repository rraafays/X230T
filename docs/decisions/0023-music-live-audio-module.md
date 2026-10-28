# Music module for guitar apps and low-latency PipeWire

## Context and Problem Statement

The laptop is used for guitar recording and live performance. Amp/modeling tools (ToneLib, Guitarix), TuxGuitar, and predictable low audio latency should live in one importable module instead of scattered user packages and default PipeWire buffers.

## Considered Options

- Keep apps in `user/` and tune PipeWire only in `system/`
- New `music` module: packages, `@audio` limits, PipeWire drop-ins, optional RT kernel
- Move PipeWire entirely out of `system/` into `music` (breaks hosts without `music`)

## Decision Outcome

Chosen option: "New `music` module", because it matches other feature submodules and owns the full PipeWire/rtkit/unfree stack so it can be imported with `./common` alone on a fresh host.

### Consequences

- Good: one enable flag for the live-audio stack; TuxGuitar colocated with related tools
- Good: JACK via PipeWire for Guitarix without a separate JACK daemon
- Bad: `realtimeKernel` depends on nixpkgs still shipping `linuxPackages-rt_latest`; current channel may only get kernel parameter tuning
- Bad: lower `quantum` increases CPU and xrun risk on older hardware (ThinkPad-class)
