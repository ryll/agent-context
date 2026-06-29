---
name: code-review
description: Trigger this skill when the user asks for a comprehensive code review of the project to ensure clean, modular, and production-ready code.
---

### Goal
Perform a critical, professional, and thorough code review of the codebase, and analyze the full project folder structure and file naming to ensure a high standard of clean, modular, easily maintainable, and production-ready code.

### Instructions

#### Phase 0 — Automated Tooling (scope: source and test directories)
Identify and run the project's configured linters, formatters, and type checkers against the main source (e.g., `src/`, `app/`) and test directories. Fix nothing yet — only collect output.

1. Review project configuration files (e.g., `pyproject.toml`, `package.json`) to determine the correct commands.
2. Run type checking, linting, and format checking.
3. Record every error and warning. These findings feed into the module-level review tables in Phase 3.

#### Phase 1 — Project Structure & Naming (scope: full project)
Review the **entire** project directory, providing an overview that explicitly covers naming and structure. Use one graph for the top-level structure and one separate graph for the main source folder structure.

1. List all top-level directories and files, as well as all directories and files within the main source folder.
2. **Check `.gitignore` (or equivalent ignore files) first** and skip any ignored files/folders.
3. Check that directory and file names follow a consistent convention appropriate for the project's language and framework (e.g., snake_case for Python, camelCase/PascalCase for TS/JS, lowercase-with-hyphens for non-code folders).
4. Flag misplaced files, unclear names, or structural inconsistencies. Verify that functions, classes, and helper logic are located in files that align with their semantic purpose. Flag cases where utilities or low-level operations are defined within orchestrating scripts.
5. Only primary source files are reviewed for deep code quality. Scripts outside the main source directory are **not** subject to code review, but their names and placement are still checked here.

#### Phase 2 — Incremental, Batch-Based Code Reading
Do **not** read all files at once. Read them in logical batches grouped by directory structure to maintain context.

For each batch, list the defined classes and functions. Maintain a running checklist of every function/class so you can verify none were skipped.

#### Phase 3 — Manual Code Review
For every function/class found in Phase 2, evaluate:

- Correctness and clarity of logic.
- Can this code be written in a simpler or less complex way? Avoid overengineering.
- Type annotations (cross-reference with findings from Phase 0).
- Lint and style issues (cross-reference with findings from Phase 0).
- Code duplication — use `grep_search` to look for repeated imports, helpers, config reading, and common patterns across files.
- Dead code or unnecessary defensive checks.
- Modularity and coupling.
- **Code Placement & Structural Alignment**: Evaluate if functions or classes are defined in the correct architectural layer. Orchestration entrypoints (like CLI commands, web route handlers, or UI controllers) should not contain low-level utilities, configuration loading, or I/O logic. Flag code that is out-of-place and recommend moving it to dedicated utility or domain-specific modules.
  * *Example*: Functions like `load_judges_config` or storage-collision directory checks do not belong directly inside a CLI runner (like `setup_benchmark.py`); they should be extracted to utility modules (such as `utils/config_loaders` or `utils/io`).

#### Phase 4 — Self-Correction
Before completing the review, verify the function/class checklist from Phase 2 to ensure absolutely no item was skipped.

#### Phase 5 — Output Generation
Format the final report as a concise markdown artifact containing:

1. **Automated Tooling Summary** — Results from linters, formatters, and type checkers.
2. **Project Folder Structure & Naming** — full-project assessment (including source folder specific).
3. **Module-by-Module Review** — tables per file. **Only include functions/classes that need changes.**
4. **Unchanged Functions List** — A short, separate list of all functions/classes that required no changes, for verification purposes. Do not provide positive feedback.
5. **High-Level Architectural Recommendations**.

### Examples
**Expected Output Format:**
```markdown
# Critical Codebase Review

## 1. Automated Tooling Summary
- **Type Checker:** 2 errors (see §2 for details)
- **Linter:** 1 warning in `schemas.py`
- **Formatter:** All files formatted correctly ✓

## 2. Project Folder Structure & Naming
*The folder structure is clean...*

## 3. Module Review

### src/utils/io.py
| Class / Function / Method | Findings & Recommendations |
| :--- | :--- |
| `read_file()` | *Use pathlib directly instead of os.path.* |

**Unchanged:** `write_file()`, `delete_file()`

## 4. High-Level Architectural Recommendations
- **Modularity & Coupling**: *The CLI logic is tightly coupled...*
```

### Constraints
- **Maintain a senior engineering standard**; do not hold back on criticism.
- **No positive feedback**; only report items that need changing or improvement.
- **Simplicity first**; strictly flag overengineered or unnecessarily complex solutions.
