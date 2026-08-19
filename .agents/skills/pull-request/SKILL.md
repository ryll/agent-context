---
name: pull-request
description: Create a GitHub pull request with the gh CLI after reviewing all branch changes against an explicitly supplied base branch, resolving issue context, protecting existing work, and obtaining approval before edits, commits, pushes, or PR creation. Use when the user asks to prepare or create a pull request.
---

### Goal
Create an accurate pull request by reviewing the complete change set relative to the target branch, incorporating issue context when supplied, checking user-facing documentation, and executing approved push and PR-creation steps without modifying pre-existing work.

### Instructions

1. **Gather required inputs**: Confirm that the user explicitly supplied:
   - The target base branch. Never infer it from repository defaults, branch names, or conventions.
   - Either an issue number the PR resolves or an explicit statement that the PR has no connected issue. Never assume the absence of an issue.

   If either answer is missing, stop and ask only for the missing information.

2. **Protect existing work**: Run `git status --short` before fetching, reviewing, or validating. If the working tree has any staged, unstaged, or untracked changes, stop and report them. Never commit, stash, discard, alter, or include pre-existing working-tree changes automatically.

3. **Fetch issue context when applicable**: If the user supplied an issue number, run `gh issue view <issue_number>` and use its context in the review and draft. If the user explicitly confirmed there is no connected issue, skip this step.

4. **Establish the full change range**: Refresh the explicit target branch and calculate its common ancestor with the current branch:

   ```bash
   git fetch origin <base_branch>
   git merge-base HEAD origin/<base_branch>
   ```

   Use the resulting merge-base SHA as `<merge_base>` throughout the review. This captures all branch changes, including work committed before a merge of the target branch into the feature branch.

5. **Review all branch changes**: Inspect the unique commits and aggregate diff from `<merge_base>` to `HEAD`:

   ```bash
   git log <merge_base>..HEAD --oneline
   git diff --stat <merge_base>..HEAD
   git diff --name-status <merge_base>..HEAD
   git diff <merge_base>..HEAD
   ```

   Base the PR summary on the complete diff and use commit messages as supporting context only.

6. **Assess fixes and README documentation**: Review validation results and determine whether any fixes are warranted. Also assess whether the complete diff changes installation, setup, configuration, usage, public behavior, commands, or other information that `README.md` should describe.
   - If no edits are needed, record why for the PR proposal.
   - If fixes or README updates are advisable, describe each proposed edit and its reason, then stop for user approval before writing anything.
   - Never write or commit a proposed fix or documentation update without explicit approval. Approval should establish both which edits may be made and whether they may be committed.
   - After approved edits, repeat relevant validation and the full review from the same merge base. Show the resulting diff and proposed commit message, and obtain commit approval if it was not already explicit before committing.

7. **Require a clean tree before drafting**: Run `git status --short`. Do not draft or propose the PR while any staged, unstaged, or untracked changes remain. If approved review edits have not been committed, request the needed commit approval; otherwise stop and report the unexpected changes.

8. **Draft the PR**:
   - Use a Conventional Commits title.
   - Summarize the complete change set using the diff, commit history, and issue context when available.
   - Add `Resolves #<issue_number>` only when the user supplied an issue. Do not add an issue-closing line for the explicit no-issue flow.
   - Include the README review result.

9. **Propose the draft**: Present the title and body to the user for review. Stop and wait for explicit approval or requested revisions. Immediately before presenting the proposal, verify again that `git status --short` is empty.

10. **Push and create the PR**: After the user approves the exact title and body:
    - Verify `git status --short` is empty immediately before pushing. Stop if it is not.
    - Push with `git push -u origin HEAD` only after approval.
    - Verify `git status --short` is still empty immediately before creating the PR. Stop if it is not.
    - Create an OS temporary file with `mktemp`, write the approved body to it without shell-interpolating its contents as code, and pass it to `gh pr create --body-file`.
    - Ensure the temporary file is removed on success, failure, or interruption. Prefer a `trap` in the same shell session as file creation and PR creation, or an equivalent `finally` cleanup mechanism.

   Representative shell flow:

   ```bash
   tmp_file=$(mktemp "${TMPDIR:-/tmp}/pr-body.XXXXXX")
   trap 'rm -f -- "$tmp_file"' EXIT HUP INT TERM
   # Write the approved body to "$tmp_file" using a safe file-writing mechanism.
   gh pr create --title "<approved_title>" --body-file "$tmp_file" --base "<base_branch>"
   ```

### Examples

**Issue-linked input:** `Create a PR into main for issue #3.`

- Fetch issue #3, review from the merge base with `origin/main`, and include `Resolves #3` in the proposed body.

**Explicit no-issue input:** `Create a PR into develop. This has no connected issue.`

- Skip issue lookup, review from the merge base with `origin/develop`, and omit any issue-closing line.

**Incomplete input:** `Create a PR for this branch.`

- Ask for both the target base branch and whether an issue is connected before performing the workflow.

### Constraints

- Never infer the base branch or issue status.
- Stop on any pre-existing working-tree change, including untracked files; never absorb it into the PR workflow.
- Always use the merge base with the freshly fetched `origin/<base_branch>` for the complete review.
- Never make or commit review fixes or README updates without explicit approval.
- Require a clean working tree before drafting, proposing, pushing, and creating the PR.
- Never push or create the PR without explicit approval of the exact title and body.
- Always use a Conventional Commits PR title.
- Use an OS temporary file for the PR body and reliably remove it; never create `.pr_body.txt` in the repository.
