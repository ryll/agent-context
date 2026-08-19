---
name: code-review
description: Perform an architectural code review of a project or directory and write the required report to CODE_REVIEW.md in the project root. Use when the user asks for a code review, architecture review, structural review, or an assessment of structure, module boundaries, responsibilities, dependencies, coupling, cohesion, or maintainability. Do not perform linting, formatting, type checking, or other line-level style analysis.
---

### Goal
Perform a critical, professional architectural review of the target directory. Assess whether the codebase has a clear, coherent, modular, and maintainable structure.

This is an **architectural review only**. Review implementation details only as needed to understand responsibilities, boundaries, dependencies, and data/control flow.

### Hard Scope Boundary

Do **not** check, run, or report on:

- Linting or linter violations.
- Formatting, whitespace, indentation, line length, or import ordering.
- Type-checker results or type annotation completeness.
- Line-level style preferences.
- Minor naming or implementation details that do not affect architectural clarity.
- Tests, builds, linters, formatters, or type checkers solely to assess code quality.

If such issues are encountered incidentally, omit them from the report unless they directly cause a structural or architectural problem. Do not present the absence of these checks as a review gap.

### Instructions

#### Scope Determination
Determine the target directory for the review:
  - If the user specified a directory along with the skill invocation, use that directory as the target directory.
  - If the user did not specify a directory, target the entire project directory.

#### Phase 1 — Structural Overview
Review the target directory structure and provide a clear overview or folder structure graph.

1. List the contents of the target directory.
2. **Check `.gitignore` (or equivalent ignore files) first** and skip any ignored files/folders.
3. Identify the major components, layers, entry points, shared modules, and dependency direction.
4. Flag misplaced files, unclear module responsibilities, structural inconsistencies, and names that obscure a component's architectural role.
5. Review files outside the target directory only when needed to understand an in-scope architectural dependency.

#### Phase 2 — Architecture Mapping
Read code in logical batches grouped by component or directory. Read enough implementation to map:

- Module and layer responsibilities.
- Dependency direction and cross-module relationships.
- Public interfaces and ownership of shared concepts.
- Data flow, control flow, and orchestration boundaries.
- Extension points and areas where changes would have broad impact.

Do not inventory or review every function and class unless necessary to establish architectural coverage.

#### Phase 3 — Architectural Evaluation
Evaluate:

- Whether components have clear, cohesive responsibilities.
- Whether module and layer boundaries are explicit and respected.
- Coupling, dependency cycles, inappropriate dependency direction, and hidden global dependencies.
- Separation of domain logic, orchestration, infrastructure, presentation, and shared utilities where applicable.
- Whether abstractions simplify the design or add unnecessary indirection.
- Whether duplicated architectural concepts indicate missing ownership or boundaries.
- Whether files, classes, or functions live in the correct component or layer.
- Whether the structure makes common changes easy to locate, reason about, test, and implement without unrelated impact.
- Whether architectural naming clearly communicates component roles and relationships.

Prioritize issues by architectural impact and explain the concrete maintenance or changeability risk. Recommend the smallest durable structural improvement that addresses each issue.

#### Phase 4 — Coverage Check
Before completing the review, verify that every major in-scope component, layer, entry point, and important dependency relationship was considered. Do not use line-level or symbol-level coverage as the completeness criterion.

#### Phase 5 — Output Generation
Write the final report to `CODE_REVIEW.md` in the current project root. Format it as a concise markdown artifact containing:

1. **Architecture Overview** — major components, responsibilities, boundaries, and dependency flow.
2. **Architectural Findings** — only structural issues that need changes, prioritized by impact and supported with file/module evidence.
3. **Architectural Strengths** — structural choices that are clear and worth preserving.
4. **Recommended Improvements** — focused, durable changes ordered by priority.

Do not include linting, formatting, type-checking, line-level style, or other non-architectural findings.

After writing the file, briefly tell the user that the review was saved to `CODE_REVIEW.md`.
