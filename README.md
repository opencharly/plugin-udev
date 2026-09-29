# plugin-udev

GPU device access for OpenCharly — the externalized `charly udev` command.

The plugin owns the `charly udev …` CLI — the GPU-device udev-rule manager
(`generate` / `install` / `remove` / `status`). It is a **pure command-only**
plugin (no gRPC verb), ported out of charly's core so the GPU-detection and
udev-rule-writing code no longer compiles into the core binary. It is the first
externalizable-command precedent in the core-externalization program.

charly's loader fetches this repo, host-builds the provider binary, and on
`charly udev <args…>` `syscall.Exec`s it in CLI mode — or runs the host-installed
`/usr/lib/charly/plugins` binary on a project-less host. The plugin owns real
terminal stdio, so `charly udev install` / `remove` shell out to `sudo tee` /
`sudo udevadm` and reach the real terminal natively.

## What it provides

| Capability | Surface |
|---|---|
| `command:udev` | the `charly udev` CLI — `generate`, `install`, `remove`, `status` |

## How to use it

```bash
charly udev generate     # print the 99-charly-container-access rules
charly udev install      # install the rules (sudo)
charly udev remove       # remove the rules (sudo)
charly udev status       # report GPU devices + rule status
```

`generate` and `status` are GPU-less and safe to run anywhere.

## Layout

- `candy/plugin-udev/` — the plugin module: `command.go` (the CLI + rule
  generation), `provider.go` / `plugin.go`, `schema/udev.cue`,
  `params/cue_types_gen.go`, `cmd/serve/main.go`.
- `charly.yml` — the root project manifest (`discover: candy` + the
  `check-udev-local` R10 witness bed).
- `.github/workflows/tag-on-merge.yml` — CalVer tag + `CHANGELOG/` on merge.

## Related

- Owning skill: `/charly-automation:udev` — the GPU device access rules and
  `charly udev` commands. This candy carries no `skill:` entity of its own; the
  gap is tracked in
  [opencharly/opencharly#291](https://github.com/opencharly/opencharly/issues/291).
- `/charly-internals:plugin` — the plugin/provider model.
- [`opencharly/charly`](https://github.com/opencharly/charly) — the charly CLI.
