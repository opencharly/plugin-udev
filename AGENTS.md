# AGENTS.md — plugin-udev

Standalone plugin repo for the externalized `charly udev` command
(`command:udev`). The plugin is a Go module at `candy/plugin-udev/` (module path
`github.com/opencharly/plugin-udev/candy/plugin-udev`); the root `charly.yml`
declares `discover: candy` **and** the `check-udev-local` R10 witness bed.

Canonical files:

- `candy/plugin-udev/charly.yml` — the `plugin-udev:` candy entity (`plugin:`
  block, `plan:` check).
- `candy/plugin-udev/command.go` — the `charly udev` CLI + rule generation.
- `candy/plugin-udev/provider.go` / `plugin.go` — the provider + `NewMeta()`.
- `candy/plugin-udev/schema/udev.cue` — the self-contained schema.
- `charly.yml` — the project manifest + the `check-udev-local` bed.
- `.github/workflows/tag-on-merge.yml` — CalVer tag + `CHANGELOG/` on merge.
- `README.md` — user overview only; never agent guidance.

## Load these skills first (R0)

- `/charly-internals:plugin` — the plugin authoring reference: the `plugin:`
  block, the unified Provider model, the pure-command plugin shape, the
  per-plugin CUE-schema contract, placement. Load before touching the provider or
  schema.
- `/charly-automation:udev` — the GPU device access rules and `charly udev`
  commands this plugin owns.
- `/charly-check:check` — the disposable bed / R10 run sequence.
- `/charly-internals:git-workflow` — before any git/PR action.

## Build / validate / test

- `go build ./...` in `candy/plugin-udev/` — compile the plugin module.
- `go test ./...` in `candy/plugin-udev/` — the plugin's Go tests
  (`schema_serve_test.go`).
- `charly box validate` at the repo root — the structural check (the candy +
  `plugin:` block, CUE schema, the witness bed).
- The merge gate is the **org-wide** `charly/pr-validator` (required check
  `validate / validate`, defined in `opencharly/.github`); this repo has **no**
  per-repo candy gate.
- R10 witness: the `check-udev-local` disposable bed asserts `charly udev
  generate` rule content and `charly udev status` exit 0 host-side (GPU-less).

## Modify this repo

- Edit the `plugin-udev:` candy entity, the Go source, and `schema/udev.cue`
  **together** — the schema is the single source for the generated types.
- `command:udev` is dispatched via the CLI `syscall.Exec` path, not the gRPC
  provider registry; it advertises no `Describe` capability.

## Landing

- PR-only. Every change lands through a pull request; the org-required
  `charly/pr-validator` validates the diff and body and arms native auto-merge on
  PASS. Direct pushes to `main` are blocked.
- History lives in `CHANGELOG/` (written by `tag-on-merge` at merge time); the PR
  body IS the changelog.
- The authoritative rulebook is the umbrella `AGENTS.md` in
  `opencharly/opencharly` and `charly/AGENTS.md` in the charly repo. Do not
  restate its rules here.
