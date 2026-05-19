# Advanced Warfare Strat Tester 

This is a mod for creating, testing, and learning new strategies in Call of Duty: Advanced Warfare. 

This mod is meant to be an all-encompassing mod, with loads of features and options to give yourself the loadout and map setup you need to practice your strategies.

## Download

1. Download Strat Tester at `Realease`
2. Download [s1-competitive](https://gitlab.com/EvelynYuki/Competitive-S1/-/blob/main/competitive-s1.exe).
3. Put the s1-competitive exe inside your gamefolder and launch the exe.
4. Put your patch inside Call of Duty Advanced Warfare\storage\scripts\mp.

Done!

(This also works with other clients, but the locations may differ)

## Additional Files

Some maps don't allow to load certain libraries if its for a different Map. For now my way to avoid this issue is to simply create Map specific files. So If you want to use map specific features, drag the coresponding file in. This also means if you play a different map, you should remove the Patch again. *Note: strat_tester.gsc should always be in*

## Current Features:

*Note* Some settings require a "fast_restart" to take effect.

### General
- 500,000 points on spawn
- Perks reserved on down

### Map Specifics
- Infection
    - No Toxic Zones
        `toxic_round 0`
- Carrier
    - No Breaches
        `breach 0`

### HUD
- Removed due to errors- Hud will be back once these errors have been fixed

### Round Settings
- Set various starting rounds
    `round <number>` and restarting.
- Set a delay to navigate to where you need to start the round at game start
    `delay <seconds>`

### Perks & Drops
- Choose weither you spawn with Perks or not 
    - `/perks 0` spawn with no Perks
    - `/perks 1` spawn with all Perks

### Game Settings
- Open/Close all Doors:
    - `/doors 1`
- Activate/Deactivate all Generators
    - `/power 1`
- Move the box/Don't move the box
    - `/move_box 1`

### Weapon Options
- Enable or Dissable loadout
    - `loadout 1` 

- Choose with what weapon you spawn in
    - `/weapons trident blunderbuss`

- Change Weapon level
    - `/lvl 15`

- Choose with what tactical & lethal you spawn in
    - `/tactical distraction`
    - `/lethal contact`

# Cheats

## List of Useful Cheats

- `/sv_cheats 1` Activate cheats
- `/god` godmode
- `/demigod` godmode but you still get hit
- `/noclip` flying
- `/fast_restart` restart map
- `/map_restart` fully restart map

*Note* A full game restart is required after activating cheats

# Credits

- [rFancy](#)

- [FOEDI](https://github.com/FOEDI)

- [llGaryyll](https://www.twitch.tv/ligaryyil)

- [DaddyDontStop](#)

