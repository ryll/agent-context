---
name: code-review
description: Trigger this skill when the user asks for a comprehensive code review of the project or a specific directory to ensure clean, modular, and production-ready code.
---

### Goal
Perform a critical, professional, and thorough code review of the target directory (either the specific directory supplied by the user, or the full project if no directory is specified) and analyze its structure and naming to ensure clean, modular, easily maintainable, and production-ready code.

### Instructions

#### Scope Determination
Determine the target directory for the review:
  - If the user specified a directory along with the skill invocation, use that directory as the target directory.
  - If the user did not specify a directory, target the entire project directory.

#### Phase 1 — Structure & Naming
Review the target directory structure and naming conventions. Provide a clear overview or folder structure graph.

1. List the contents of the target directory.
2. **Check `.gitignore` (or equivalent ignore files) first** and skip any ignored files/folders.
3. Check that directory and file names within the target directory follow a consistent convention appropriate for the project's language and framework.
4. Flag misplaced files, unclear names, or structural inconsistencies. Verify that functions, classes, and helper logic are located in files that align with their semantic purpose. Flag cases where utilities or low-level operations are defined within orchestrating scripts.
5. Only code files inside the target directory are reviewed for deep code quality. Other scripts or configuration files outside the target directory are not subject to deep code review, though their placement may be flagged if relevant.

#### Phase 2 — Incremental, Batch-Based Code Reading
Do **not** read all files at once. Read the code files inside the target directory in logical batches grouped by directory structure to maintain context.

For each batch, list the defined classes and functions. Maintain a running checklist of every function/class so you can verify none were skipped.

#### Phase 3 — Manual Code Review
For every function/class found in Phase 2, evaluate:

- Naming of files, classes, functions, and variables. Do they clearly convey their purpose and intent?
- Correctness and clarity of logic.
- Can this code be written in a simpler or less complex way? Avoid overengineering.
- Code duplication — use `grep_search` to look for repeated imports, helpers, config reading, and common patterns across files.
- Dead code or unnecessary defensive checks.
- Modularity and coupling.
- Evaluate if functions or classes are defined in the correct architectural layer. Flag code that is out-of-place and recommend moving it to dedicated utility or domain-specific modules.

#### Phase 4 — Self-Correction
Before completing the review, verify the function/class checklist from Phase 2 to ensure absolutely no item was skipped.

#### Phase 5 — Output Generation
Format the final report as a concise markdown artifact containing:

1. **Folder Structure & Naming** — assessment of the target directory structure and naming conventions.
2. **Module-by-Module Review** — tables per file. **Only include functions/classes that need changes.**
3. **High-Level Architectural Recommendations**.

