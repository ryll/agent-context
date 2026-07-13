---
name: skill-authoring
description: Trigger this skill when the user asks to create, modify, or author a new Antigravity skill, rule, or agent directive file.
---

### Goal
Guide the agent to generate or update Antigravity skills and rule directories that adhere to the standard three-level progressive disclosure layout, proper YAML frontmatter, and clear instruction/constraint sections.

### Instructions

1. **Target Location Identification**:
   - If the user has not specified where the skill should be located, stop and ask the user whether it should be:
     - **Global**: `~/home/ryll/coding/agent-context/.agents/skills/` (accessible across all projects through symlinks)
     - **Project-specific**: `.agents/skills/` (relative to the current workspace root)
   - Do not write any files until the directory location is confirmed.

2. **Initiation & Planning (Do Not Guess)**:
   - Determine the name, purpose, and trigger conditions of the skill.
   - If any requirements, behavior, design choices, or inputs are ambiguous, **do not guess**.
   - Create a rough plan describing the proposed goal, structure, and execution steps of the skill, and list any outstanding questions or decisions.
   - Present this plan and ask the user clarifying questions. Wait for the user's feedback/approval before writing the skill.
   - If modifying an existing skill, locate the skill directory.

3. **Skill Anatomy Setup**:
   - Create a directory named after the skill (kebab-case, e.g., `my-new-skill/`).
   - Create the main entrypoint file `my-new-skill/SKILL.md`.
   - If the skill requires scripts, create a `scripts/` directory inside.
   - If the skill requires large references (>300 lines), create a `references/` directory inside.

4. **Frontmatter Configuration**:
   - Place YAML frontmatter at the very top of `SKILL.md` using three dashes:
     ```yaml
     ---
     name: skill-name-here
     description: A highly specific trigger phrase explaining exactly when to use this skill.
     ---
     ```

5. **Document Structure**:
   - **### Goal**: Define a single clear, actionable statement of what the skill achieves.
   - **### Instructions**: Provide step-by-step logic or phases (e.g., Phase 0, Phase 1) for execution.
   - **### Examples**: Provide realistic input/output pairs showcasing the skill in action.
   - **### Constraints**: List absolute boundaries, style rules, or forbidden actions.

6. **Apply Progressive Disclosure**:
   - Keep the main `SKILL.md` under 500 lines.
   - If the file is too long, offload detail into `references/` or `scripts/` and link to them using relative links (e.g., `[reference docs](references/docs.md)`).
   - If reference files are larger than 300 lines, ensure they contain a Table of Contents at the top.

### Examples

**Example Input:**
> "create a git-helper skill that explains when to run git commit and checks status"

**Expected Output:**
```markdown
---
name: git-helper
description: Trigger this skill when the user wants to status check, stage, or commit files using git.
---

### Goal
Efficiently verify the repository status, stage modified files, and draft clean, structured commit messages.

### Instructions
1. Run `git status` to see unstaged changes.
2. Stage modified files with `git add <file>`.
3. Draft a commit message following the Conventional Commits specification.
4. Verify the commit with `git log -n 1`.

### Examples
**Input:** Stage and commit `src/main.py`
**Output:**
```bash
git add src/main.py
git commit -m "feat(core): add main entrypoint logic"
```

### Constraints
- Never perform a git push without user confirmation.
- Commit messages must never exceed 72 characters on the first line.
```

### Constraints
- The YAML frontmatter must always contain exactly the `name` and `description` keys.
- Keep the `SKILL.md` body under 500 lines.
- Do not use placeholders or incomplete templates.
- Always use kebab-case for skill directory names.
- Always ask the user if a skill should be global or project-specific if the location is not explicitly stated.
- Always propose an initial plan and ask clarifying questions first if any decisions or requirements are ambiguous.
