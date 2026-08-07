# Advanced Warfare Strat Tester

> **Advanced Warfare Strat Tester** is an all-in-one practice and strategy-testing mod for **Call of Duty: Advanced Warfare Zombies**.

Create the exact loadout, map state, round, perks, drops, and other settings you need to practice, test, and develop new strategies without manually setting everything up each time.

---

## Installation

### Requirements

* **Strat Tester** — Download from **Releases**
* [s1-competitive](https://gitlab.com/DaddyDontStop/Competitive-S1)

### Setup

1. Download the latest **Strat Tester** release.
2. Download [s1-competitive](https://gitlab.com/DaddyDontStop/Competitive-S1).
3. Place `s1-competitive.exe` inside your **Call of Duty: Advanced Warfare** game folder.
4. Launch `s1-competitive.exe`.
5. Place the Strat Tester patch inside:

```text
Call of Duty Advanced Warfare\storage\scripts\mp
```

6. Launch the game.

> **Note:** Strat Tester also works with other clients, although the file locations may differ.

---

# Features

> **Note:** Some settings require a `fast_restart` to take effect.

## General

* **7,777,777 points** on spawn
* **Perks are reserved** when downed

---

## Map Specific

### Infection

Toggle Toxic Zones:

```text
toxic_round 0
```

* `1` = On
* `0` = Off

### Carrier

Toggle Bomb Breach:

```text
breach 0
```

* `1` = On
* `0` = Off

---

## HUD

Toggle individual HUD elements:

```text
velocity_hud 1
zombie_hud 1
zone_hud 1
sph_hud 1
```

| Command        | Description         |
| -------------- | ------------------- |
| `velocity_hud` | Toggle Velocity HUD |
| `zombie_hud`   | Toggle Zombie HUD   |
| `zone_hud`     | Toggle Zone HUD     |
| `sph_hud`      | Toggle SPH HUD      |

For all HUD settings:

* `1` = On
* `0` = Off

Example:

```text
sph_hud 0
```

---

## Round Settings

### Starting Round

Set the round you want to start on:

```text
round <number>
```

A restart is required after changing the round.

Example:

```text
round 30
fast_restart
```

### Special Rounds

Toggle Special Rounds:

```text
special_round 1
```

* `1` = On
* `0` = Off

Example:

```text
special_round 0
```

---


### Spawn Delay

Set a delay before navigating to your starting location:

```text
delay <seconds>
```

Example:

```text
delay 10
```

---

## Perks & Drops

### Perks

Toggle perks:

```text
perks 1
```

### Drops

Toggle regular drops:

```text
drops 0
```

Applies to:

* Outbreak
* Infection

Toggle DLC 3 drops:

```text
drops_dlc3 0
```

Applies to:

* Carrier
* Descent

### Supply Drops

Toggle Supply Drops:

```text
supply_drops 0
```

For these settings:

* `1` = On
* `0` = Off

---

## Game Settings

### Doors

Open all doors:

```text
doors 1
```

### Power

Turn on all generators:

```text
power 1
```

### Moving Box

Toggle box movement:

```text
move_box 1
```

For these settings:

* `1` = On
* `0` = Off

---

# Loadout

Customize your starting loadout without manually setting everything up.

### Enable / Disable Loadout

```text
loadout 1
```

### Starting Weapons

Choose which weapons you spawn with:

```text
weapons trident blunderbuss
```

### Killstreaks

Choose your starting killstreaks:

```text
killstreak camouflage
```

### Weapon Level

Set your weapon level:

```text
lvl 15
```

### Tactical & Lethal

Choose your starting tactical and lethal equipment:

```text
tactical distraction
lethal contact
```

---

# Cheats

## Useful Cheats

| Command         | Description                          |
| --------------- | ------------------------------------ |
| `/sv_cheats 1`  | Activate cheats                      |
| `/god`          | Enable god mode                      |
| `/demigod`      | God mode, but damage still registers |
| `/noclip`       | Enable flying / noclip               |
| `/fast_restart` | Restart the current map              |
| `/map_restart`  | Fully restart the map                |

> **Note:** A full game restart is required after activating cheats.

---

# Quick Reference

| Setting        | Command         | Values      |
| -------------- | --------------- | ----------- |
| Starting Round | `round`         | `<number>`  |
| Spawn Delay    | `delay`         | `<seconds>` |
| Toxic Zones    | `toxic_round`   | `1` / `0`   |
| Bomb Breach    | `breach`        | `1` / `0`   |
| Velocity HUD   | `velocity_hud`  | `1` / `0`   |
| Zombie HUD     | `zombie_hud`    | `1` / `0`   |
| Zone HUD       | `zone_hud`      | `1` / `0`   |
| SPH HUD        | `sph_hud`       | `1` / `0`   |
| Perks          | `perks`         | `1` / `0`   |
| Drops          | `drops`         | `1` / `0`   |
| DLC3 Drops     | `drops_dlc3`    | `1` / `0`   |
| Supply Drops   | `supply_drops`  | `1` / `0`   |
| Doors          | `doors`         | `1` / `0`   |
| Power          | `power`         | `1` / `0`   |
| Move Box       | `move_box`      | `1` / `0`   |
| Loadout        | `loadout`       | `1` / `0`   |
| Special Round  | `special_round` | `1` / `0`   |

---

# Credits

* [rFancy](#)
* [FOEDI](https://github.com/FOEDI)
* [llGaryyll](https://www.twitch.tv/ligaryyil)
* [DaddyDontStop](#)
