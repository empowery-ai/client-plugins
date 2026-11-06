# Motion

The small amount of motion that helps forms, tables and overlays. Default is no
motion. Values are our assessment (A) unless marked otherwise.

Load when: something on the screen moves (a transition, an overlay, a skeleton
shimmer), or a review reaches lens 5.

Contents: 1 When motion earns its place · 2 Press feedback · 3 Durations and easing ·
4 Interruptibility · 5 Enter and exit · 6 Performance · 7 Reduced motion · 8 What we
do not do

## 1. When motion earns its place

Motion needs a job: show where something came from (a side panel from its edge),
point at what changed (a short tint on a row that was just updated), or confirm a
press. Test: remove it; if nobody would miss it, it goes. One transition per state
change is enough. Motion that delays reading or input is a finding.

## 2. Press feedback

- A press shows a visible change within 100 ms (A): `:active` with a background step
  from the tokens. No waiting for the server.
- Longer work switches the button to a pending state with its label kept
  (`Wird gespeichert …`); see `states-feedback.md` §4.

## 3. Durations and easing

| Use | Duration | Token |
|---|---|---|
| Press and hover | 100 to 150 ms | `--duration-fast` |
| Small overlays: dropdown, popover, toast | 150 to 250 ms | `--duration-base` |
| Panels, drawers, dialogs | 200 to 300 ms | `--duration-slow` |
| Anything in a task flow | never over 400 ms | |

- `--ease-out` on enter, `--ease-in` on exit, `linear` only for progress bars.
- No overshoot: `cubic-bezier` values stay between 0 and 1. Values live in the token
  file (`tokens-theming.md` §9), never as literals in components.

## 4. Interruptibility

- Never block input during a transition: no `pointer-events: none` on the page while
  a view changes, no disabled buttons just to wait for an animation.
- Escape or a tap outside closes an overlay even while it is still opening.
- A toggled element reverses from where it is. CSS transitions do this; `@keyframes`
  restart. Use transitions for things that open and close.
- Pass: open and close a panel three times fast; it follows each command without a
  jump and without queueing.

## 5. Enter and exit

- Leave the way you came: a panel that enters from the right exits to the right.
- Menus and popovers grow from their trigger: `transform-origin: top left` for a menu
  under a left-aligned button.
- Dialogs fade in with a slight scale (0.98 to 1). On the phone, bottom sheets and
  toasts enter from the bottom edge.

## 6. Performance

- Animate only `transform` and `opacity`; other properties force layout or paint on
  every frame (browser fact). `will-change` only while an element moves.
- Never animate `height` or `width` on table rows or accordions; show the new size at
  once. No entrance animation per row.
- Pass with CPU throttling 4x (`measuring.md` §9): no stutter, no delayed input.

## 7. Reduced motion

With `prefers-reduced-motion: reduce`, movement becomes a short fade or nothing.
Feedback stays: color and state changes still show.

```css
@media (prefers-reduced-motion: reduce) {
  .panel { transition: opacity var(--duration-fast) var(--ease-out); opacity: 0; }
  .panel[data-open] { transition: opacity var(--duration-fast) var(--ease-out); opacity: 1; }
  .skeleton { animation: none; }
  html { scroll-behavior: auto; }
}
```

- A 0 ms transition never fires `transitionend`; code that waits for it needs another
  trigger. Pass (`measuring.md` §8): nothing slides, the shimmer stops, nothing stays
  invisible.

## 8. What we do not do

Spring physics, momentum and bounce. Parallax and fade-in on scroll. Moving glass or
blur layers. Decorative loops and attention pulses. Celebration effects after a save.
Page transitions that keep the next view from being usable.
