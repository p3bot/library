---
name: web-frontend
description: Visual and interaction design for websites and web apps, covering layout, color, typography, imagery, motion, forms, and UI states. Use when creating, redesigning, or restyling a web page, site, landing page, portfolio, storefront, dashboard, or app UI in HTML, CSS, Tailwind, React, or similar, even if they only say "make it look better", "build me a landing page", "this UI looks generic", "make it look professional", or "style this page".
---

# Web Frontend Design

Commit to a visual point of view drawn from the subject, open with the screen the format calls for, and let typography, proportion, color, imagery, and motion carry the design instead of decorative chrome. Verify the rendered page in a browser before finishing.

Rules are hard requirements. Defaults hold unless you can state why the brief needs otherwise. An explicit user request overrides a default. An existing project design system overrides everything here except the rules.

## Rules

- Text contrast meets WCAG AA: 4.5:1 for body text, 3:1 for large text, UI component boundaries, and focus indicators
- Semantic HTML: landmarks, one `<h1>`, ordered headings, `<button>` for actions, `<a>` for navigation
- Every input has a visible label. Placeholder text is not a label
- Every interactive element is keyboard reachable and shows a `:focus-visible` style
- Touch targets are at least 24x24px; primary controls aim for 44x44px
- Meaningful images have alt text; decorative images have `alt=""`
- Content is visible at rest, never left at `opacity: 0` awaiting an animation. Honor `prefers-reduced-motion: reduce`
- No horizontal page scroll and no clipped text from 320px wide upward. Size type in `rem`
- Transitions name their properties; never `transition: all`
- Never guess external image URLs or hardcode machine-local paths
- Preserve user-supplied copy verbatim
- In an existing codebase, use its framework, components, and design tokens rather than a parallel system

## Visual direction

- When the brief names a look, mood, era, or level of restraint, commit to it fully. Otherwise derive palette, contrast, and rhythm from the subject's real materials, setting, and audience
- Avoid the model reflexes unless asked for: warm beige or cream with rust or terracotta (often triggered by "artisanal", "craft", "warm", or a vintage decade), and dark slate with neon purple glow. Range wider: bold color-blocking; deep roast, forest, ink, or marine darks; cool stone or silver; sunlit pastels; crisp gallery white
- Starting fresh, define theme tokens (`:root` custom properties or Tailwind `@theme`): background, secondary surface, primary text, muted text, and one accent. Add status colors only for real state. Build dark mode by redefining tokens, not restyling components

## Typography

- At most two families: one versatile family across weights, or a deliberate pairing. Choose faces for the subject's character; do not default every creative brief to display serif plus generic sans
- Use `font-variant-numeric: tabular-nums` for prices, timers, and data columns instead of a monospace face, unless the product is code or terminal oriented
- Hold body content to about three sizes (heading, body, small). Separate subheadings, buttons, and labels by weight and color, not intermediate sizes. Dense dashboards and tables may add one step. The display headline and brand wordmark sit outside the scale and can be large
- Body text is at least 16px. Nothing goes below 12px except legal text, and nothing below 13px above the fold
- Body paragraphs and lists share one size: no oversized lead paragraph, no caption-sized lists
- Body measure is 45 to 75ch. Tighten display tracking slightly; leave body tracking normal
- Sentence case for labels, buttons, and table headers. No tracked-out all-caps micro-labels

## Opening screen

- Content and workspace formats open straight into content: news, blogs, docs, dashboards, search and directory pages, tools, and resumes. Never push articles, controls, or data below a marketing banner
- Brands, products, storefronts, events, portfolios, and long-form stories may earn a hero. One dominant element, the headline or the lead visual, owns the full width or depth of the viewport. Do not trap the `<h1>` in a half-width column beside a media box
- A hero headline gets one or two short lines of support and one primary action. No stat or spec strip along its bottom
- On hero-led pages the hero runs to the top edge behind a borderless header. A sticky header gains a surface once scrolled
- Desktop navigation fits on one line, with the brand mark visibly stronger than the links
- Carry the opening screen's ambition to the footer. Vary pacing across full-bleed stages, tools, asymmetric splits, and reading sections rather than falling into rows of three cards

## Web apps

- Design every state a view can reach: empty (what belongs here and how to start), loading (skeletons matching the final layout), error (what failed and how to fix it, beside where it failed), success, and disabled
- Forms: labels above fields, validation on blur or submit shown beside the field, errors that name the fix, and submit buttons that show progress and block double submission
- Keep the app shell stable: navigation marks the current location, and layout does not shift as data loads
- Tables: right-align numbers, left-align text, keep headers visible on scroll, and give narrow screens a deliberate pattern (priority columns or stacked rows) rather than overflow
- Every action gets visible feedback within about 100ms
- Set density by task: compact for expert tools and data, generous for content and onboarding

## Imagery and motion

- Skip decorative imagery inside dense workspaces. Where imagery earns its place, use an image-generation tool if one is available, saving into the project with relative paths, one distinct image per item. Otherwise build inline SVG, CSS, or canvas visuals, or use supplied assets
- Match each image's aspect ratio to its container, keep lighting and palette consistent across the set, and compose negative space where text overlays so contrast holds without heavy scrims
- Use scroll-driven moments only where they advance the story, such as a pinned stage stepping through a product view. Keep scrolling native on tools, feeds, data views, and navigation
- Interaction transitions run 150 to 250ms, ease-out, on `transform`, `opacity`, or `clip-path`. No idle looping animation
- Kinetic headline type is welcome where it lifts a hero, within the rest-state and reduced-motion rules

## Patterns to avoid

- Eyebrow labels or kickers above headings. Start sections with the heading
- Decorative non-interactive chips, badges, or tags of any shape on headings, images, or cards. Reserve pill and bordered shapes for controls and real status
- Decorative heading numbers (`01`, `[ 01 / 04 ]`, Roman numerals) unless the steps are a real sequence. Fake "LIVE" dots, "SCROLL" cues, rotated edge text
- More than one primary button per section, or a reflexive secondary link beside every primary
- Rows of bordered buttons for choosing modes, sizes, or filters. Use segmented controls, tabs, radios, switches, or `<select>`
- Cards nested in cards. Group with whitespace, 1px dividers, or surface tint
- Manifesto copy, filler ("seamless", "elevate", "reimagined"), stacked adjectives, or commentary on the design itself. Headings lead with the benefit, not the spec. Headlines stay whole, without `<br><em>` splits. No em-dashes or spaced en-dashes in generated copy

## Verify in a browser

Use webctl. If its skill is not loaded, run `webctl skill` for the command contract.

1. Serve so fonts and assets load: `webctl serve <dir>` for static files, or `webctl serve --proxy localhost:<port>` in front of the project's dev server. Then `webctl ready --network-idle`
2. Check `webctl console` for errors, and `webctl network --failed` plus `webctl network --status 4xx,5xx` for missing fonts and assets
3. Desktop: `webctl viewport 1440x900`, then `webctl screenshot` for the opening screen and `webctl screenshot --full-page` for the rest
4. Mobile: `webctl viewport 390x844 --mobile`, then the same two captures
5. At each viewport, measure what screenshots hide with `webctl eval`:
   - Overflow: `document.documentElement.scrollWidth > innerWidth`
   - Distinct computed `fontSize` and `fontFamily` values across text elements
   - Elements whose computed `transitionProperty` is `all` with a nonzero duration
6. Read the screenshots against this skill: opening screen fits the format, navigation on one line, no collisions or clipped words, type scale held to the footer, no avoided patterns
7. Fix everything found in one pass, repeat steps 3 to 5 once, then `webctl viewport reset`
