# Kanata restart on input device hotplug

## Context and Problem Statement

Kanata runs as a system service with a fixed config. Plugging in keyboards or other input devices can leave Kanata unaware of the new hardware until manual restart.

## Considered Options

- Manual `systemctl restart` after hotplug
- udev rule plus oneshot systemd unit to restart Kanata
- Run Kanata in user session with device discovery

## Decision Outcome

Chosen option: "udev rule plus oneshot systemd unit to restart Kanata", because Kanata stays a system service with the existing NixOS module while udev triggers a targeted restart when input devices appear.

### Consequences

- Good, because hot-plugged keyboards work without logging out
- Good, because logic lives next to other `keyboard/` module settings
- Bad, because restarts can interrupt in-flight key state briefly
- Bad, because udev rules are hardware-specific and need care on new machines

Related commit: `48ef444`.
