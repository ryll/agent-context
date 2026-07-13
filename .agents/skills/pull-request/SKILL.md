---
name: pull-request
description: Trigger this skill when the user wants to create a pull request using the GitHub CLI (gh), including summarizing commits and pushing the branch.
---

### Goal
Automate the creation of a Pull Request by fetching issue context, summarizing branch commits, drafting a PR title and body, and executing the PR creation via the `gh` CLI.

### Instructions
1. **Gather Inputs**: Verify that the user has explicitly provided the **target base branch** and any **issue number(s)** that this PR will resolve. If either is missing, stop and ask the user for them before proceeding.
2. **Fetch Issue Context**: Run `gh issue view <issue_number>` to gather context on the issue provided by the user.
3. **Analyze Commits**: Run `git log <base_branch>..HEAD --oneline` to view all commits unique to the current branch compared to the target base branch.
4. **Draft PR**: 
   - Draft a PR title using the Conventional Commits specification. 
   - Draft a clear and concise PR description that summarizes all changes based on the commit history and issue context. 
   - Ensure the description includes `Resolves #<issue_number>`.
5. **Propose Draft**: Propose the draft PR title and body to the user for review. Stop execution and wait for the user to approve or request changes.
6. **Execute Push & PR Creation**: Once the user approves the draft:
   - Save the approved PR body to a temporary file: `.pr_body.txt`.
   - Run `git push -u origin HEAD` to push the branch to the remote repository.
   - Run `gh pr create --title "<title>" --body-file .pr_body.txt --base <base_branch>` to create the pull request.
   - Clean up the temporary file by running `rm .pr_body.txt`.

### Examples
**Input:** Create a PR into main for issue #3.
**Output:**
1. Fetch issue context:
   ```bash
   gh issue view 3
   ```
2. Analyze commits:
   ```bash
   git log main..HEAD --oneline
   ```
3. Propose Draft to User:
   *Title:* `feat: implement judge validation pipeline`
   *Body:* `Resolves #3. ...`
   *(Wait for user approval)*
4. After user approves:
   ```bash
   # (Agent creates .pr_body.txt with the approved body)
   git push -u origin HEAD
   gh pr create --title "feat: implement judge validation pipeline" --body-file .pr_body.txt --base main
   rm .pr_body.txt
   ```

### Constraints
- Never proceed with drafting or creating the PR if the target base branch is missing. Always prompt the user for it.
- Never push or create the PR without explicit user approval of the drafted title and body.
- The PR title must strictly adhere to Conventional Commits guidelines.
- Always use a temporary file (`.pr_body.txt`) with the `--body-file` argument for `gh pr create` to avoid bash string escaping complexities.
