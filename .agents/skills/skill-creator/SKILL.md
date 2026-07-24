---
name: skill-authoring
description: Create, update, or improve reusable agent skills. Use when a user wants to capture specialized knowledge, a repeatable workflow, or reliable tool usage in a SKILL.md-based skill.
---

# Skill Authoring

## Goal

Create small, useful skills that give an agent the non-obvious guidance and reusable resources needed for a particular kind of work.

## Workflow

1. Understand the intended skill before writing.
   - Inspect relevant existing skills, examples, and project conventions first.
   - When the user asks to turn existing work into a skill, extract the observed steps, tools, inputs, outputs, and corrections from the conversation before asking for missing details.
   - Establish the skill's purpose, expected users or requests, trigger conditions, expected outcomes, and success criteria.
   - Ask about material gaps or decisions rather than inventing requirements. Confirm the target location before creating files if it is not already established. For an update, preserve the existing name and identity unless the user asks to change them.

2. Design from concrete use cases.
   - Use real examples from the conversation or ask for a few representative requests.
   - Identify the information or procedure an agent would not reliably infer without help.
   - Set the level of instruction to the task: use flexible guidance where judgment is needed, and precise steps or scripts where work is fragile, repetitive, or must be consistent.

3. Keep the skill self-contained and lean.
   - Create a kebab-case skill directory with a required `SKILL.md` entrypoint.
   - Put valid YAML frontmatter at the top. Include `name` and `description` as the portable minimum.
   - Make the description state both what the skill does and the requests or contexts that should trigger it. The body is available only after triggering, so do not hide trigger guidance there.
   - Assume the agent already knows general-purpose concepts. Include only domain knowledge, decisions, or procedures that are non-obvious and useful at execution time.
   - Write clear, imperative instructions. Explain the reason for important guardrails when that helps the agent make sound decisions.
   - Include examples, output formats, and constraints only when they prevent a likely mistake or clarify an important expectation. Do not impose a fixed document template on every skill.
   - Record required dependencies, permissions, inputs, or side effects when they affect successful execution.

4. Add resources only when they earn their place.
   - Use `scripts/` for deterministic or repeatedly needed operations; test added scripts.
   - Use `references/` for detailed domain knowledge, schemas, or variant-specific guidance that should be consulted only when relevant.
   - Use `assets/` for files intended to be copied into or used by the final output, such as templates or visual resources.
   - Do not create empty folders, placeholder content, duplicate documentation, or auxiliary files that do not help the agent perform the skill.

5. Apply progressive disclosure.
   - Keep `SKILL.md` focused on core workflow, decisions, and navigation; aim to stay well below 500 lines.
   - Move lengthy, optional, or variant-specific material into directly linked reference files and state when to read each one.
   - Keep references shallow and discoverable. Give longer reference files a short table of contents or clear headings.

6. Check the result and iterate.
   - Verify the frontmatter, name, paths, links, and any bundled-resource assumptions.
   - For repeatable or high-impact workflows, exercise the skill with two or three realistic requests and, when feasible, a near-boundary case. Confirm it triggers for intended work and stays out of adjacent work. For subjective skills, use qualitative review rather than forcing objective checks.
   - Compare the outcome to the stated success criteria, then remove dead guidance and refine gaps revealed by real use.

## Examples

### Trigger description

```yaml
---
name: release-notes
description: Draft accurate release notes from repository changes and issue context. Use when a user asks to prepare, revise, or standardize release notes, changelogs, or version summaries.
---
```

### Resource selection

For a document-conversion skill, put the repeatable conversion logic in `scripts/` when it needs reliable, consistent execution. Put file-format details in `references/` when they are needed only for particular formats. Do not add either directory when concise instructions are sufficient.

## Constraints

- Keep the skill scoped to a distinct, reusable capability; do not turn general-purpose knowledge into a skill without a clear need.
- Do not add platform-specific commands, metadata, packaging steps, or evaluation tooling unless the target environment or user explicitly requires them.
- Do not create deceptive, unsafe, unauthorized, or capability-obscuring skills.
- Preserve unrelated files and existing user changes.
