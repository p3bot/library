# CSS Review

Review of CSS stylesheets and styling architecture within the repository. Covers structural and maintainability concerns across all stylesheet files. This is not a general code review or a visual design review — focus on the CSS itself.

## Prerequisites

- A codebase containing CSS, including preprocessor or CSS-in-JS variants

## Workflow

1. Identify the CSS footprint: file types (.css, .scss, .less, .styled, CSS-in-JS), preprocessor configuration, and build tooling
2. Read configuration files related to styling (PostCSS, Tailwind, Sass config, style linting, etc.)
3. Read stylesheets systematically, starting with base and global styles before moving to component styles
4. Review against the scope points below and any other concerns relevant to the styling layer
5. Produce a structured report of findings and present it inline. Save only if the user asked, or if they instructed this run to proceed without intervention. Use the path they gave. If they asked to save but named no path, ask. If they instructed this run to proceed without intervention and named no path, write to `.start/reviews/YYYY-MM-DD-css-NN.md` (`NN` starts at `01`, incrementing against existing files matching the date and type)

## Reviewer Guidance

- Consider the project's chosen methodology. Inconsistency within a chosen approach is more concerning than the choice of approach itself.
- Distinguish between subjective style preferences and genuine maintainability or correctness concerns. Only report the latter.
- CSS findings are typically medium or low severity. Reserve critical for accessibility failures or systemic issues that affect the entire styling layer. Reserve high for patterns that actively cause bugs or make the styles unmaintainable.
- Classify findings by severity (critical, high, medium, low, info). Write "None" for any severity level where no findings exist. Every section must be present in the report.
- It is acceptable to find no issues. If the stylesheets are well-implemented, say so. Do not manufacture findings to justify the review.

## Scope

The following scope points are the primary areas of concern. They orient the review but do not limit it. Report any findings relevant to the styling layer, including those outside these areas.

- Specificity and Cascade Management: Evaluating selector weight strategy, cascade layer usage, and the avoidance of specificity conflicts that lead to fragile overrides.
- Design Token Architecture: Assessing the use of custom properties and design tokens to maintain a consistent, themeable value system across the codebase.
- Layout Strategy: Reviewing the use of modern layout methods and identifying legacy patterns that introduce fragility or unnecessary complexity.
- Responsive Design: Evaluating breakpoint strategy, media query organisation, and the approach to fluid versus fixed layouts across viewport sizes.
- Naming and Methodology: Assessing the consistency of naming conventions and the adherence to a coherent organisational methodology.
- Value Consistency: Identifying hardcoded or duplicated values that should reference shared definitions to prevent drift.
- Unused and Dead Styles: Detecting orphaned selectors, unreachable rules, and stale overrides that increase maintenance burden.
- Rendering Performance: Evaluating animation and transition choices for compositor efficiency and identifying patterns that trigger expensive layout or paint operations.
- Accessibility: Reviewing focus visibility, colour contrast, motion preferences, and other styling decisions that affect usability for diverse users.
- Browser Compatibility: Assessing feature usage against target browser support and the approach to progressive enhancement.
- Z-index Management: Evaluating stacking context strategy and the use of z-index values to prevent layering conflicts.
- Typography System: Reviewing font scale consistency, line-height rhythm, and web font loading strategy.

## Report Format

```
## CSS Review Summary

Scope: {what was reviewed, number of files}
Findings: {count per severity, e.g. 2 critical, 1 high, 3 medium, 1 low}

## Critical Findings

{findings that represent serious risk or deficiency, or "None"}

## High Findings

{findings that should be addressed, or "None"}

## Medium Findings

{findings worth considering, or "None"}

## Low / Info

{minor observations and suggestions, or "None"}

## Assessment

{overall assessment of this area, noting both strengths and weaknesses}
```
