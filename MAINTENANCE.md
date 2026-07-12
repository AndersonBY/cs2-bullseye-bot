# Maintenance Policy

This repository is the public MBSifu-maintained fork of
[ed0ard/CS2-Bullseye-Bot](https://github.com/ed0ard/CS2-Bullseye-Bot).

## Branches and upstream changes

- The default branch contains reviewed MBSifu maintenance patches.
- The `upstream` source is `ed0ard/CS2-Bullseye-Bot:main`.
- The weekly `upstream-sync.yml` workflow may create a pull request, but it
  never merges or publishes upstream changes automatically.
- Keep upstream namespaces, assemblies, commands, and configuration paths stable
  unless a reviewed migration is required.

## Verification

Pull requests must pass:

1. The repository's .NET build and focused tests.
2. `scripts/package-release.sh <tag>`.
3. SHA-256, manifest, required-path, archive-root, and bundled-assembly checks in
   `scripts/validate-release.sh`.

## Native compatibility

- `PickNewAimSpot` is a non-schema native function. Its Linux and Windows
  signatures in `BotAimImprover.cs` must be checked against the current game
  binaries after a CS2 update.
- `CCSBot::m_targetSpot`, `CCSBot::m_enemy`, `CCSBot::m_isEnemyVisible`, and
  `CCSPlayerPawn::m_pBot` must be accessed through CounterStrikeSharp's live
  schema wrappers. Do not replace them with fixed offsets.
- Plugin startup resolves and logs all four schema offsets, then fails closed if
  the native signature or any required schema member is unavailable. A
  `css_plugins list` entry alone is not proof that the hook is active; runtime
  smoke tests must also observe the loaded message, a working `bot_aim` command,
  and the first-override log.
- Do not run CounterStrikeSharp's `css_dump_schema` command on a customer or
  shared test server. It caused a native segmentation fault on CS2 build 14169;
  use the startup offset log and an isolated disposable process for diagnosis.

## Releases

Reviewed tags use `v<project-version>-mbsifu.<revision>`. The Release workflow
builds from the tag, creates one Linux x86_64 archive rooted at `addons/`, and
publishes the archive, its SHA-256 file, and `plugin-manifest.json`.

A successful CI build is not production approval. MBSifu separately validates
the manifest and archive, builds a test image, and runs a server smoke test
before promotion.
