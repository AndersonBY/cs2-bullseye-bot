> **MBSifu maintained fork.** This public fork tracks [ed0ard/CS2-Bullseye-Bot](https://github.com/ed0ard/CS2-Bullseye-Bot) and ships reviewed, reproducible Linux releases for MBSifu and the wider CS2 community. See [MAINTENANCE.md](MAINTENANCE.md) before proposing upstream sync or release changes.

[![CI](https://github.com/AndersonBY/cs2-bullseye-bot/actions/workflows/ci.yml/badge.svg)](https://github.com/AndersonBY/cs2-bullseye-bot/actions/workflows/ci.yml)

# CS2-Bullseye-Bot
CS2-Bullseye-Bot is a CounterStrikeSharp plugin that improves bots' aim in CS2.

![bullseye_2](https://github.com/user-attachments/assets/b658e64e-028c-42de-817c-1748fe0ca4f4)
# Dependency

The maintained Linux release bundles the pinned RayTrace v1.0.16 managed and native dependency pair. Source builds run `scripts/fetch-raytrace.sh`, verify both published SHA-256 values, and fail if the API assembly is unavailable.
# Commands

`bot_aim mixed`  
Bots select aiming spots flexibly based on situations (default)

`bot_aim head`  
Bots prioritize aiming at the head

`bot_aim body`  
Bots prioritize aiming at the torso

`bot_aim`  
Check the current aim mode
# Installation
1. Download the `linux-x64.zip` asset from [this fork's Releases](https://github.com/AndersonBY/cs2-bullseye-bot/releases).
2. Extract it into `game/csgo/`; the archive contains BotAimImprover, RayTrace's CounterStrikeSharp components, and the Linux Metamod module.
3. Cold-start the server. Hot-loading cannot initialize the native RayTrace dependency safely.
## If you find the plugin useful then please take the time to star⭐ the repository
