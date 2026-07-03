# Agent Context & Skills Repository

Single source of truth for custom skills, configurations, and contexts used across coding agents. Keeps a central, versioned setup even when switching agents/projects.

## Linking Skills
Create symlinks (`ln -s`) from this repo to the target agent configuration folder.

```bash
# Example 1: Link code-review skill to current workspace config
mkdir -p .agents/skills
ln -s ~/coding/agent-context/.agents/skills/code-review .agents/skills/code-review

# Example 2: Link the full skills directory globally to Gemini config
ln -s ~/coding/agent-context/.agents/skills ~/.gemini/config/skills
```
