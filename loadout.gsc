#include common_scripts\utility;
#include maps\mp\zombies\_terminals;
#include maps\mp\zombies\killstreaks\_zombie_killstreaks;

main()
{
    create_dvar("loadout", 1);

    create_dvar("weapons", "mp11 rhino");
    create_dvar("lvl", 15);
    
    create_dvar("lethal", "contact");
    create_dvar("tactical", "distraction");

    create_dvar("killstreak", "camouflage");
}

initKillstreakDatabase()
{
    level.killstreakData = [];
    level.killstreakData["sentry"] = "zm_sentry";
    level.killstreakData["drone"] = "zm_ugv"; 
    level.killstreakData["camouflage"] = "zm_camouflage";
    level.killstreakData["squadmate"] = "zm_squadmate";
}

initWeaponDatabase()
{
    level.weaponData = [];
    level.weaponData["arx160"] = "iw5_arx160zm_mp";
    level.weaponData["maul"] = "iw5_maulzm_mp";
    level.weaponData["hbra3"] = "iw5_hbra3zm_mp";
    level.weaponData["hmr9"] = "iw5_hmr9zm_mp";
    level.weaponData["himar"] = "iw5_himarzm_mp";
    level.weaponData["m182spr"] = "iw5_m182sprzm_mp";
    level.weaponData["mp11"] = "iw5_mp11zm_mp";
    level.weaponData["sac3"] = "iw5_sac3zm_mp";
    level.weaponData["uts19"] = "iw5_uts19zm_mp";
    level.weaponData["lsat"] = "iw5_lsatzm_mp";
    level.weaponData["asaw"] = "iw5_asawzm_mp";
    level.weaponData["rw1"] = "iw5_rw1zm_mp";
    level.weaponData["vbr"] = "iw5_vbrzm_mp";
    level.weaponData["gm6"] = "iw5_gm6zm_mp";
    level.weaponData["rhino"] = "iw5_rhinozm_mp";
    level.weaponData["ak12"] = "iw5_ak12zm_mp";
    level.weaponData["bal27"] = "iw5_bal27zm_mp";
    level.weaponData["asm1"] = "iw5_asm1zm_mp";
    level.weaponData["sn6"] = "iw5_sn6zm_mp";
    level.weaponData["fusion"] = "iw5_fusionzm_mp";
    level.weaponData["crossbow"] = "iw5_exocrossbowzm_mp";
    level.weaponData["mahem"] = "iw5_mahemzm_mp";
    level.weaponData["em1"] = "iw5_em1zm_mp";
    level.weaponData["ae4"] = "iw5_dlcgun1zm_mp";
    level.weaponData["ohm"] = "iw5_dlcgun2zm_mp";
    level.weaponData["m1"] = "iw5_dlcgun3zm_mp";
    level.weaponData["microwave"] = "iw5_microwavezm_mp";
    level.weaponData["linegun"] = "iw5_linegunzm_mp";
    level.weaponData["trident"] = "iw5_tridentzm_mp";
    level.weaponData["blunderbuss"] = "iw5_dlcgun4zm_mp";
    level.weaponData["titan45"] = "iw5_titan45zm_mp";

    level.weaponData["contact"] = "contact_grenade_zombies_mp";
    level.weaponData["explosive"] = "explosive_drone_zombie_mp";
    level.weaponData["distraction"] = "distraction_drone_zombie_mp";
    level.weaponData["dna"] = "dna_aoe_grenade_zombie_mp";
    level.weaponData["teleport"] = "teleport_zombies_mp";
    level.weaponData["repulsor"] = "repulsor_zombie_mp";
    level.weaponData["frag"] = "frag_grenade_zombies_mp";
}

init()
{
    level thread onPlayerConnect();
    level thread initWeaponDatabase();
    level thread initKillstreakDatabase();
}

onPlayerConnect()
{
    self endon("disconnect");
    level endon("game_ended");
    
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned(); 
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    
    for(;;)
    {
        self waittill("spawned_player");
        self thread give_loadout();
        self thread give_killstreaks();
    }
}

give_loadout()
{
    self endon("disconnect");
    level endon("game_ended");

    if(getDvarInt("loadout") == 0)
        return;

    wait 15;
    self takeweapon("iw5_titan45zm_mp");

    wait 1;
    
    weapons_string = getDvar("weapons");
    weapons = strtok(weapons_string, " ");
    
    primary_weapon = weapons[0];
    secondary_weapon = weapons[1];
    
    lethal_weapon = getDvar("lethal");
    tactical_weapon = getDvar("tactical");
    
    lvl_dvar = getDvarInt("lvl");
    
    if (isDefined(level.weaponData[primary_weapon]))
    {
        primary_full_name = level.weaponData[primary_weapon];
        maps\mp\zombies\_wall_buys::givezombieweapon(self, primary_full_name, 1, 1);
        maps\mp\zombies\_wall_buys::setweaponlevel(self, primary_full_name, lvl_dvar);
    }
    
    if (isDefined(secondary_weapon) && secondary_weapon != "" && isDefined(level.weaponData[secondary_weapon]))
    {
        secondary_full_name = level.weaponData[secondary_weapon];
        self giveweapon(secondary_full_name);
        self givemaxammo(secondary_full_name);
        maps\mp\zombies\_wall_buys::setweaponlevel(self, secondary_full_name, lvl_dvar);
    }

    if (isDefined(level.weaponData[lethal_weapon]))
    {
        lethal_full_name = level.weaponData[lethal_weapon];
        maps\mp\zombies\_wall_buys::givezombieequipment(self, lethal_full_name, 1);
    }
    
    if (isDefined(level.weaponData[tactical_weapon]))
    {
        tactical_full_name = level.weaponData[tactical_weapon];
        maps\mp\zombies\_wall_buys::givezombieequipment(self, tactical_full_name, 1);
    }
}

give_killstreaks()
{   
    if(getDvarInt("loadout") == 0)
        return;

    wait 1;

    killstreak_name = getDvar("killstreak");
    
    if(isDefined(level.killstreakData[killstreak_name]))
    {
        killstreak_full_name = level.killstreakData[killstreak_name];
        self maps\mp\killstreaks\_killstreaks::givekillstreak(killstreak_full_name, 0, 0, self, undefined, 2);
        self maps\mp\killstreaks\_killstreaks::givekillstreak(killstreak_full_name, 0, 0, self, undefined, 3);
        self maps\mp\killstreaks\_killstreaks::givekillstreak(killstreak_full_name, 0, 0, self, undefined, 4);
    }
}