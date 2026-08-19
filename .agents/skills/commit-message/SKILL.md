---
name: commit-message
description: Draft an approved Conventional Commit message for currently staged changes and execute the commit. Use when the user asks to write a commit message or commit staged work while matching repository wording, scope, and tone.
---

### Goal
Inspect staged files, generate a Conventional Commit message informed by the repository's recent wording, scope, and tone, and commit the staged changes after approval.

### Instructions
1. Run `git status` to verify there are staged changes ready for commit. If no changes are staged, stop execution, explain to the user that changes must be staged first, and do not attempt to run `git add` or stage files yourself.
2. Run `git diff --cached` to inspect the contents of the staged changes.
3. Run `git log -n 5 --oneline` to analyze the wording, common scopes, and tone of recent commit messages. History is stylistic context only; do not copy a non-Conventional format from it.
4. Draft a valid Conventional Commit message, such as `feat(parser): ...`, `refactor: ...`, or `chore: ...`. Choose the type and optional scope from the staged change itself, using history only to make the wording and tone feel native to the repository.
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
   *Output shows `Modified: src/config/loader.py` staged.*
2. Check changes:
   ```bash
   git diff --cached
   ```
3. Check commit history:
   ```bash
   git log -n 5 --oneline
   ```
   *Output shows:*
   `56760f8 refactor(config): centralize environment loading`
4. Proposed message:
   `refactor(config): simplify environment loading`
5. Execute commit:
   ```bash
   git commit -m "refactor(config): simplify environment loading"
   ```

### Constraints
- Never commit unless changes are already staged.
- Always use the Conventional Commits structure `<type>[optional scope][!]: <description>`, even when recent repository history is not Conventional.
- Derive the type from the staged changes; never restrict valid Conventional Commit types to those present in history.
- The first line of the commit message must never exceed 72 characters.
- Never push changes automatically.
- Never stage files or run `git add`. Only work with already staged changes.
- If no changes are staged, halt execution immediately and notify the user to stage their files.
