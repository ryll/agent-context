---
name: commit-message
description: Trigger this skill when you want to draft a commit message for currently staged changes matching the style of previous commits in the repository history, and execute the commit.
---

### Goal
Inspect staged files, generate a git commit message following Conventional Commits and matching the style of previous repository commits, and commit the staged changes.

### Instructions
1. Run `git status` to verify there are staged changes ready for commit. If no changes are staged, stop execution, explain to the user that changes must be staged first, and do not attempt to run `git add` or stage files yourself.
2. Run `git diff --cached` to inspect the contents of the staged changes.
3. Run `git log -n 5 --oneline` to analyze the naming and formatting style of recent commit messages in the repository.
4. Draft a commit message (e.g., `feat: ...`, `refactor: ...`, `chore: ...`) matching the style and type tags from the history.
5. Propose the commit message to the user.
6. Once the message is approved, execute the git commit command:
   ```bash
   git commit -m "<approved_commit_message>"
   ```

### Examples
**Example Input:** Write a commit message for staged files.
**Example Execution:**
1. Check status:
   ```bash
   git status
   ```
   *Output shows `Modified: src/pirr_evaluation/schemas.py` staged.*
2. Check changes:
   ```bash
   git diff --cached
   ```
3. Check commit history:
   ```bash
   git log -n 5 --oneline
   ```
   *Output shows:*
   `56760f8 refactor: Implement global storage and checked reuse for runs, and remove unused CLI scripts.`
4. Proposed message:
   `refactor: Standardize schema timestamps, rename evaluation models, and simplify fields.`
5. Execute commit:
   ```bash
   git commit -m "refactor: Standardize schema timestamps, rename evaluation models, and simplify fields."
   ```

### Constraints
- Never commit unless changes are already staged.
- The commit message must strictly match the Conventional Commits type prefixes (e.g. `refactor:`, `chore:`, `feat:`, `fix:`) present in the git log history.
- The first line of the commit message must never exceed 72 characters.
- Never push changes automatically.
- Never stage files or run `git add`. Only work with already staged changes.
- If no changes are staged, halt execution immediately and notify the user to stage their files.
