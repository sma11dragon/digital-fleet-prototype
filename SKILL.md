# Skill: Enterprise UI Redesign (DAE × Jonathan Ive–Inspired)

## Purpose
This skill enables an AI agent to redesign or refine a digital product UI
using a Jonathan Ive–inspired design philosophy
while strictly preserving existing UX flows, logic, and task completion paths.

The skill is optimized for:
- Enterprise / B2B products
- Mission-critical, task-driven applications
- Outdoor, time-sensitive usage (e.g. fleet, energy, logistics)

---

## Product Context
- Company: DAE (Digital Assistant for Energy)
- Product Type: Brand-neutral digital fleet fueling app
- Primary Users: Fleet drivers (non-technical, task-focused)
- Market: Malaysia
- Usage Environment:
  - Fuel stations
  - Bright sunlight
  - One-handed operation
  - Time-critical workflows

---

## Core Design Philosophy (Jonathan Ive–Inspired)
This skill applies *principles*, not stylistic imitation.

1. Subtract until only what is necessary remains
2. Design should be self-evident
3. Interfaces should feel engineered, not decorated
4. Visual calm enables speed and confidence
5. The product should disappear in use

Avoid trends, novelty, or expressive decoration.

---

## Branding Constraints (DAE — Mandatory)

### Typography
- Primary font: **Inter**
- Secondary / body (optional): **Plus Jakarta Sans**
- No additional fonts allowed
- Hierarchy achieved through:
  - Size
  - Weight
  - Spacing
- NOT through excessive color or decoration

### Color System
- Primary brand color: **#004B8E** (DAE Blue)
- Primary text color: **#3C3C49** (Dark Grey)
- Neutral backgrounds
- Color is used ONLY for:
  - Primary actions
  - Status states (success, error, warning)
- Forbidden:
  - Gradients
  - Glassmorphism
  - Neumorphism
  - Decorative color usage

---

## UX Safety Guardrails (Non-Negotiable)

The agent MUST:
- Preserve navigation structure
- Preserve screen count
- Preserve task flow order
- Preserve information visibility
- Preserve button placement and hierarchy
- Preserve interaction logic

The agent MUST NOT:
- Add new features
- Add new gestures
- Hide critical information
- Introduce learning requirements
- Increase cognitive load

A first-time driver must be able to complete fueling with zero instruction.

---

## Redesign Scope
This skill applies to visual and structural refinement only:

1. Typography & spacing system
2. Color application within brand rules
3. Buttons & interaction surfaces
4. Iconography
5. Status, confirmation, and error states

UX logic and workflows are out of scope.

---

## Typography & Spacing Rules
- Use fewer font sizes and weights
- Prefer spacing over dividers
- Clear separation of:
  - Primary action
  - Secondary information
- Optimized for outdoor readability

---

## Buttons & Interaction Surfaces
- Primary action must be visually confident but calm
- Touch targets must be generous
- No shadows, outlines, or decorative animations
- Interaction should feel deliberate and predictable

---

## Iconography Rules
- Functional, industrial, universal
- Consistent stroke weight and geometry
- Icons support text; never replace it
- No playful, metaphor-heavy, or brand-like symbols

---

## Validation Checklist (Required Before Output)

Before finalizing any redesign, the agent must verify:

- [ ] Task completion steps are unchanged
- [ ] No additional cognitive load introduced
- [ ] All critical information remains visible
- [ ] Primary actions remain obvious
- [ ] UI feels calmer, not emptier
- [ ] Design aligns with DAE branding
- [ ] No trend-based styling introduced

If any item fails, the redesign must be revised.

---

## Output Expectations
When this skill is applied, outputs must:
- Be screen-by-screen or system-by-system
- Explain *why* each change improves clarity or calm
- Explicitly state what was removed or simplified
- Confirm UX parity after changes
- Avoid code unless explicitly requested

---

## Guiding Principle
If the interface draws attention to itself, the design has failed.
If the user completes the task faster and with less stress, the design has succeeded.