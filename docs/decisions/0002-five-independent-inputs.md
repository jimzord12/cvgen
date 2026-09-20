# 0002. One template, five independent inputs

Date: 2026-09-09
Status: Amended by 0007 and 0011. The five inputs stand; "one template" does
not; 0011 adds a sixth optional input, `role`, because a template now sits
inside a domain and may be refined by one of its roles.

## Context

The design files mixed data, colours, geometry and illustrations in one
script. Producing a captain CV would have meant copying 150 lines and
editing a third of them. Changing a margin meant finding every magic number.

## Decision

`flagship` takes a candidate, a theme, an artwork pack, a layout profile and
a durations switch. Each is a plain dictionary in its own folder. Components
receive only the slice they need and never branch on role. A new look is a
new theme file; a new role is a new artwork pack; a new page balance is a
new layout or an override.

## Consequences

- An example entry point is seven lines.
- Captain Silver differs from Captain Classic by one import.
- A component that needs to know both the theme and the candidate's role is
  a design error and is refused in review.
- The template is the only file that composes; it stays under 50 lines.
