---
name: pull-request
description: Trigger this skill when the user wants to create a pull request using the GitHub CLI (gh), including reviewing all branch changes against the target branch, verifying README documentation, summarizing commits, and pushing the branch.
---

### Goal
Create an accurate Pull Request by fetching issue context, reviewing the complete change set relative to the target branch, ensuring the README reflects user-facing changes, drafting a PR title and body, and executing the PR creation via the `gh` CLI.

### Instructions
1. **Gather Inputs**: Verify that the user has explicitly provided the **target base branch** and any **issue number(s)** that this PR will resolve. If either is missing, stop and ask the user for them before proceeding.
2. **Fetch Issue Context**: Run `gh issue view <issue_number>` to gather context on the issue provided by the user.
3. **Establish the Full Change Range**: Before analyzing changes, refresh the target branch and calculate the common ancestor:
   ```bash
   git fetch origin <base_branch>
   git merge-base HEAD origin/<base_branch>
   ```
   Use the resulting merge-base SHA as `<merge_base>` for every subsequent change review. This includes work committed before a merge of the target branch into the feature branch, rather than limiting review to commits added after that merge.
4. **Review All Branch Changes**: Review both the full unique commit history and the aggregate diff from `<merge_base>` to `HEAD`:
   ```bash
   git log <merge_base>..HEAD --oneline
   git diff --stat <merge_base>..HEAD
   git diff --name-status <merge_base>..HEAD
   git diff <merge_base>..HEAD
   ```
   Base the PR summary on the complete diff as well as the commits. Do not substitute a recent-commit-only range or rely solely on commit messages.
5. **Verify README Documentation**: Before drafting the PR, assess whether the complete diff changes installation, setup, configuration, usage, public behavior, commands, or other user-facing information documented in `README.md`. If it does, update `README.md` so it accurately describes the resulting behavior, then repeat the full change review from the same merge base. If no README update is needed, state that conclusion and why when presenting the PR draft.
6. **Draft PR**:
   - Draft a PR title using the Conventional Commits specification. 
   - Draft a clear and concise PR description that summarizes all changes based on the commit history and issue context. 
   - Ensure the description includes `Resolves #<issue_number>`.
7. **Propose Draft**: Propose the draft PR title and body to the user for review. Include the README review result. Stop execution and wait for the user to approve or request changes.
8. **Execute Push & PR Creation**: Once the user approves the draft:
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
2. Establish and review the complete change range:
   ```bash
   git fetch origin main
   git merge-base HEAD origin/main
   git log <merge_base>..HEAD --oneline
   git diff <merge_base>..HEAD
   ```
3. Review `README.md` against that diff and update it if the change affects documented user-facing behavior.
4. Propose Draft to User:
   *Title:* `feat: implement judge validation pipeline`
   *Body:* `Resolves #3. ...`
   *README review:* `Updated to document the validation setup.`
   *(Wait for user approval)*
5. After user approves:
   ```bash
   # (Agent creates .pr_body.txt with the approved body)
   git push -u origin HEAD
   gh pr create --title "feat: implement judge validation pipeline" --body-file .pr_body.txt --base main
   rm .pr_body.txt
   ```

### Constraints
- Never proceed with drafting or creating the PR if the target base branch is missing. Always prompt the user for it.
- Always derive the reviewed range from `git merge-base HEAD origin/<base_branch>` after fetching the target branch. Review the aggregate diff and all commits in that range before drafting the PR.
- Always assess the README against the complete change set before drafting. Update it when the PR changes information the README should communicate; otherwise, report why no update was needed.
- Never push or create the PR without explicit user approval of the drafted title and body.
- The PR title must strictly adhere to Conventional Commits guidelines.
- Always use a temporary file (`.pr_body.txt`) with the `--body-file` argument for `gh pr create` to avoid bash string escaping complexities.
