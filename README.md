# Agent Context

A small, version-controlled collection of reusable skills for coding agents. The repository keeps shared workflows in one place so the same review, commit, pull-request, and skill-authoring guidance can be used across Codex, Gemini, and Claude.

The project favors explicit approval gates, narrow responsibilities, portable `SKILL.md` files, and simple installation. The skills guide an agent's work; they do not replace project-specific instructions or grant permissions the agent does not already have.

## Skills

| Skill | Purpose | Important behavior |
| --- | --- | --- |
| [`code-review`](.agents/skills/code-review/SKILL.md) | Review architecture, boundaries, dependencies, cohesion, and maintainability. | Writes the review to `CODE_REVIEW.md`; excludes linting and other line-level analysis. |
| [`commit-message`](.agents/skills/commit-message/SKILL.md) | Draft and execute a commit for already-staged changes. | Always uses Conventional Commits, asks for approval, and never stages or pushes. |
| [`pull-request`](.agents/skills/pull-request/SKILL.md) | Review a complete branch change set and create a GitHub pull request. | Requires a base and issue decision, protects existing work, and asks before edits, commits, pushes, or PR creation. |
| [`skill-writer`](.agents/skills/skill-writer/SKILL.md) | Create or improve focused, reusable agent skills. | Emphasizes concrete use cases, lean instructions, and verification. |

## Repository structure

```text
.
├── .agents/skills/
│   └── <skill>/
│       ├── SKILL.md
│       └── agents/openai.yaml
├── link-skills.sh
├── LICENSE
└── README.md
```

Each skill uses the portable `SKILL.md` format. The optional `agents/openai.yaml` file supplies OpenAI-specific display metadata and is harmless to agents that do not use it.

## Prerequisites and compatibility

Installation requires Bash, `ln`, and a filesystem that supports symbolic links. The documented workflow supports Linux, macOS, and WSL; native Windows shells are not currently supported.

The installer links every skill into these global locations:

| Agent | Skill directory |
| --- | --- |
| Codex | `~/.codex/skills` |
| Gemini | `~/.gemini/config/skills` |
| Claude | `~/.claude/skills` |

Agent capabilities and skill-loading behavior can vary by product version. Git-based skills also require Git, and the pull-request workflow requires an authenticated [GitHub CLI](https://cli.github.com/).

## Installation

Clone the repository, then run the linker from anywhere:

```bash
git clone https://github.com/ryll/agent-context.git ~/coding/agent-context
bash ~/coding/agent-context/link-skills.sh
```

The script creates the three target directories when needed and links all four skills into each one. Run it again after adding a skill. Existing entries—including files, directories, valid symlinks, and broken symlinks—are reported and left untouched.

To install only one skill, create the desired agent directory and link it manually. For example:

```bash
mkdir -p ~/.codex/skills
ln -s ~/coding/agent-context/.agents/skills/code-review ~/.codex/skills/code-review
```

Use the corresponding Gemini or Claude directory from the compatibility table when installing for those agents.

## Usage examples

Once the agent has discovered the skills, request the workflow in ordinary language:

```text
Review the architecture of src/services.
Draft a commit message for my staged changes and commit after I approve it.
Create a pull request into main for issue #42.
Improve this reusable deployment skill.
```

Read each linked `SKILL.md` for its inputs and safeguards. In particular, the commit workflow requires staged changes, the pull-request workflow requires an explicit base branch and issue decision, and the code-review workflow creates `CODE_REVIEW.md` in the project root.

## Limitations

- The installer intentionally has no flags or per-agent/per-skill filtering.
- It never overwrites or repairs an existing target entry; remove or replace entries yourself after inspecting them.
- The skills rely on the host agent to provide the tools, permissions, and approval interactions their workflows require.
- There is no native Windows installer, package manager integration, or automatic update mechanism.

## License

Licensed under the [MIT License](LICENSE).
