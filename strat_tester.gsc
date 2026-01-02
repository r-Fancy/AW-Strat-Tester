#include common_scripts\utility;
#include common_scripts\_createfx;

#include maps\mp\gametypes\zombies;
#include maps\mp\gametypes\_hud_util;

#include maps\mp\_utility;

#include maps\mp\zombies\_zombies;
#include maps\mp\zombies\zombies_spawn_manager;
#include maps\mp\zombies\_doors;
#include maps\mp\zombies\_terminals;
#include maps\mp\zombies\_util;
#include maps\mp\zombies\_wall_buys;
#include maps\mp\zombies\_power;

main()
{
    level.getMapName = getMapName();
    //setdvar("sv_cheats", 1); 
    setdvar("g_useholdtime", 0); 
    create_dvar("doors", 1);
    create_dvar("power", 1);
    create_dvar("round", 60);
    create_dvar("delay", 30);

    create_dvar("loadout", 1);
    create_dvar("primary", "arx160");
    create_dvar("secondary", "rw1");
    create_dvar("lvl", 15);
    create_dvar("perks", 1);
    
    create_dvar("lethal", "contact_grenade");
    create_dvar("tactical", "distraction_drone");

    create_dvar("zombie_hud", 0);
    create_dvar("velocity_hud", 0);
    create_dvar("zone_hud", 0);
}

init()
{    
    level thread onPlayerConnect();
    level thread initWeaponDatabase();
    level thread doors();
    level thread power();
}

initWeaponDatabase()
{
    level.weaponData = [];
    
    // Primary weapons
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
    
    // Secondary weapons
    level.weaponData["rw1"] = "iw5_rw1zm_mp";
    level.weaponData["vbr"] = "iw5_vbrzm_mp";
    level.weaponData["gm6"] = "iw5_gm6zm_mp";
    level.weaponData["rhino"] = "iw5_rhinozm_mp";
    
    // Special/DLC weapons
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
    
    // Equipment
    level.weaponData["contact_grenade"] = "contact_grenade_zombies_mp";
    level.weaponData["explosive_drone"] = "explosive_drone_zombie_mp";
    level.weaponData["distraction_drone"] = "distraction_drone_zombie_mp";
    level.weaponData["dna_aoe_grenade"] = "dna_aoe_grenade_zombie_mp";
    level.weaponData["teleport"] = "teleport_zombies_mp";
    level.weaponData["repulsor"] = "repulsor_zombie_mp";
    
    level.weaponData["frag_grenade"] = "frag_grenade_zombies_mp";
}

onPlayerConnect()
{
    level endon("game_ended");
    
    for(;;)
    {
        level waittill("connected", player);
        player thread setup_settings();
        player thread onPlayerSpawned();
    }
}

setup_settings()
{
    self endon("disconnect");
    self thread hud_init();
}


hud_init()
{
    self endon("disconnect");
    self thread strat_tester_txt();    
    self thread cleanupHUD();
    
    if (getDvarInt("zombie_hud"))
        self thread zombie_hud();
    if (getDvarInt("velocity_hud"))
        self thread velocity_hud();
    if (getDvarInt("zone_hud"))
        self thread zone_hud();
}

cleanupHUD()
{
    self endon("disconnect");    
    self waittill("disconnect");
    
    if(isDefined(self.zT_hud)) 
        self.zT_hud destroy();
    if(isDefined(self.vel_hud)) 
        self.vel_hud destroy();
    if(isDefined(self.zone_hud)) 
        self.zone_hud destroy();
    if(isDefined(self.hud_text)) 
        self.hud_text destroy();
}

onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    
    for(;;)
    {
        self waittill("spawned_player");
        self freezeControls(false);
        self resetmoney(500000);
        self thread set_delay();
        self thread set_round();
        self thread give_player_assets();
    }
}

power()
{
    if(getDvarInt("power") == 0)
        return;

    wait 1;

    if (!isDefined(level.power_switches) || level.power_switches.size == 0)
        return;

    foreach (power_switch in level.power_switches)
    {
        if (!isDefined(power_switch)) continue;
        
        flag_set(power_switch.script_flag);
        power_switch notify("on");

        if (isDefined(power_switch.showents))
        {
            foreach (ent in power_switch.showents)
                if (isDefined(ent)) ent show();
        }
        
        if (isDefined(power_switch.hideents))
        {
            foreach (ent in power_switch.hideents)
                if (isDefined(ent)) ent hide();
        }
    }
}

doors()
{   
    if(getDvarInt("doors") == 0)
        return;
        
    flag_init("door_opened");
    if (!isdefined(level.doorhintstrings))
    {
        level.doorhintstrings = [];
    }
    if (!isdefined(level.zombiedoors))
    {
        level.zombiedoors = getstructarray("door", "targetname");
        array_thread(level.zombiedoors, ::init_door);
    }
    wait(1);
    
    doorFlags = undefined;
    switch(level.getMapName)
    {
        case "mp_zombie_lab":
            doorFlags = [
                "courtyard_to_roundabout",
                "roundabout_to_lab",
                "roundabout_to_military",
                "courtyard_to_administration",
                "administration_to_lab", 
                "lab_to_experimentation",
                "military_to_experimentation"
            ];
            break;

        case "mp_zombie_brg":
            doorFlags = [
                "warehouse_to_gas_station",
                "warehouse_to_atlas",
                "gas_station_interior", 
                "gas_station_to_sewer",
                "atlas_command",
                "atlas_to_sewer",  
                "sewertrans_to_sewertunnel",
                "sewermain_to_sewercave",
                "sewer_to_burgertown", 
                "burgertown_storage"  
            ];
            break;
        case "mp_zombie_ark":
            doorFlags = [
                "sidebay_to_armory", 
                "rearbay_to_armory", 
                "cargo_elevator_to_cargo_bay",
                "biomed_to_cargo_bay", 
                "armory_to_biomed", 
                "armory_to_cargo_elevator",
                "medical_to_biomed", 
                "moonpool_to_cargo_elevator", 
                "sidebay_to_medical", 
                "rearbay_to_moonpool"
            ];
            break;
        case "mp_zombie_h2o":
            doorFlags = [
                "start_to_zone_01", 
                "start_to_zone_02", 
                "zone_01_to_atrium",
                "zone_01_to_zone_01a",
                "zone_02_to_zone_01", 
                "zone_02_to_zone_02a",
                "zone_02a_to_venthall", 
                "venthall_to_zone_03", 
                "venthall_to_atrium", 
                "atrium_to_zone_04"
            ];
            break;
        return;
    }

    if (isdefined(doorFlags))
    {
        foreach(door_flag in doorFlags)
        {
            foreach(door in level.zombiedoors)
            {
                if(isdefined(door.script_flag) && door.script_flag == door_flag)
                {
                    door notify("open", undefined);
                    if(isdefined(level.doorbitmaskarray[door_flag]))
                    {
                        level.doorsopenedbitmask |= level.doorbitmaskarray[door_flag];
                    }
                }
            }
        }
    }
    
    flag_set("door_opened");
}

set_round()
{
    level.wavecounter = getDvarInt("round");
    level.wavecounter -=1;
}

set_delay()
{
    level endon("disconnect");
    level endon("game_ended");

    level.waitbs = getDvarInt("delay");
    level.waitbs += 10;

    maps\mp\zombies\_util::pausezombiespawning(1);

    while(level.waitbs > -1)
    {
        level.waithud settext(level.waitbs);
        wait 1;
        level.waitbs --;
    }

    maps\mp\zombies\_util::pausezombiespawning(0);
    level.waithud destroy();
}

give_player_assets()
{
    self thread upgrades();
    self thread loadout();
    self thread upgrades_revive();
}

upgrades()
{
    if(getDvarInt("perks") == 0)
        return;

    wait 5;
    if (level.getMapName == "mp_zombie_lab" || level.getMapName == "mp_zombie_brg")
    {
            perkterminalgive(self, "exo_suit");
            perkterminalgive(self, "exo_revive");
            perkterminalgive(self, "exo_stabilizer");
            perkterminalgive(self, "exo_slam");
            perkterminalgive(self, "specialty_fastreload");
            perkterminalgive(self, "exo_health");
    }

    if (level.getMapName == "mp_zombie_ark" || level.getMapName == "mp_zombie_h2o")
    {
            perkterminalgive(self, "exo_suit");
            perkterminalgive(self, "exo_tacticalArmor");
            perkterminalgive(self, "exo_revive");
            perkterminalgive(self, "exo_stabilizer");
            perkterminalgive(self, "exo_slam");
            perkterminalgive(self, "specialty_fastreload");
            perkterminalgive(self, "exo_health");
    }
}

loadout()
{
    if(getDvarInt("loadout") == 0)
        return;

    wait 5;
    self takeweapon("iw5_titan45zm_mp");

    wait 1;
    primary_weapon = getDvar("primary");
    secondary_weapon = getDvar("secondary");
    lethal_weapon = getDvar("lethal");
    tactical_weapon = getDvar("tactical");
    
    lvl_dvar = getDvarInt("lvl");
    
    if (isDefined(level.weaponData[primary_weapon]))
    {
        primary_full_name = level.weaponData[primary_weapon];
        maps\mp\zombies\_wall_buys::givezombieweapon(self, primary_full_name, 1, 1);
        maps\mp\zombies\_wall_buys::setweaponlevel(self, primary_full_name, lvl_dvar);
    }
    
    if (isDefined(level.weaponData[secondary_weapon]))
    {
        secondary_full_name = level.weaponData[secondary_weapon];
        self giveweapon(secondary_full_name);
        self givemaxammo(secondary_full_name);
        maps\mp\zombies\_wall_buys::setweaponlevel(self, secondary_full_name, lvl_dvar);
    }
    
    wait 5; 
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



upgrades_revive()
{
    if(getDvarInt("perks") == 0)
        return;

    wait 2;
    while(1)
    {
        self waittill("revive_trigger");
        upgrades();
    }
}

zombie_hud()
{
    if (level.getMapName == "mp_zombie_brg")
        return;

    self.zT_hud = newClientHudElem(self);
    self.zT_hud.alignx = "right";
    self.zT_hud.aligny = "top";
    self.zT_hud.horzalign = "user_left";
    self.zT_hud.vertalign = "user_top";
    self.zT_hud.x += 20;
    self.zT_hud.y += 80;
    self.zT_hud.fontscale = 1;
    self.zT_hud.hidewheninmenu = 1;
    self.zT_hud.label = &"Zombies remaining: ";
    self.zT_hud.alpha = 1;
    
    lastCount = -1;
    
    while(true)
    {
        currentCount = self thread calculateZombieCount();
        if(currentCount != lastCount) 
        {
            self.zT_hud setvalue(currentCount);
            lastCount = currentCount;
        }
        wait 0.25;
    }
}

calculateZombieCount()
{
    totalAI = maps\mp\zombies\zombies_spawn_manager::calculatetotalai();
    killsThisRound = int(self.kills) - int(self.killsatroundstart);
    return totalAI - killsThisRound;
}

velocity_hud()
{
    if (level.getMapName == "mp_zombie_brg")
        return;

    self.vel_hud = newClientHudElem(self);
    self.vel_hud.alignx = "right";
    self.vel_hud.aligny = "top";
    self.vel_hud.horzalign = "user_left";
    self.vel_hud.vertalign = "user_top";
    self.vel_hud.x += 20;
    self.vel_hud.y += 70;
    self.vel_hud.fontscale = 1.0;
    self.vel_hud.hidewheninmenu = 1;
    self.vel_hud.label = &"Velocity: ";
    self.vel_hud.alpha = 1;

    lastVel = -1;
    
    while(true)
    {
        velocity = self getvelocity();
        currentVel = floor(sqrt(float(velocity[0] * velocity[0]) + float(velocity[1] * velocity[1])));
        
        if(currentVel != lastVel) 
        {
            self.vel_hud setvalue(currentVel);
            lastVel = currentVel;
        }
        wait 0.1;
    }
}

zone_hud()
{
    if (level.getMapName == "mp_zombie_brg")
        return;

    self.zone_hud = newClientHudElem(self);
    self.zone_hud.alignx = "right";
    self.zone_hud.aligny = "top";
    self.zone_hud.horzalign = "user_left";
    self.zone_hud.vertalign = "user_top";
    self.zone_hud.x += 20;
    self.zone_hud.y += 60;
    self.zone_hud.fontscale = 1.0;
    self.zone_hud.hidewheninmenu = 1;
    self.zone_hud.alpha = 1;

    lastZone = "";
    
    while(true)
    {
        if (isDefined(self.currentzone) && self.currentzone != lastZone)
        {
            self.zone_hud setText(self.currentzone);
            lastZone = self.currentzone;
        }
        wait 0.2;
    }
}

strat_tester_txt()
{
    if (level.getMapName == "mp_zombie_brg")
        return;

    hud_text = self createfontstring("default", 1.4);
    hud_text setpoint("TOPRIGHT", "TOPRIGHT", -5, 5);     
    hud_text.label = &"Strat Tester\nv.1.2";
    hud_text.sort = 1000; 
}
