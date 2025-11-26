#include maps\mp\gametypes\zombies;
#include maps\mp\zombies\_zombies;
#include maps\mp\zombies\zombies_spawn_manager;
#include maps\mp\zombies\_doors;
#include maps\mp\zombies\_terminals;
#include maps\mp\zombies\_util;
#include maps\mp\zombies\_wall_buys;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\zombies\_power;

init()
{    
    level.getMapName = maps\mp\_utility::getMapName();
    level thread onPlayerConnect();
    level thread doors();
    level thread power();
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
    self thread settings();
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

settings()
{
    setdvar("sv_cheats", 1);
    setdvar("g_useholdtime", 0);

    dvars = [];
    dvars[dvars.size] = ["doors", "1"];
    dvars[dvars.size] = ["power", "1"];

    dvars[dvars.size] = ["round", "60"];
    dvars[dvars.size] = ["delay", "30"];
    dvars[dvars.size] = ["loadout", "1"];
    dvars[dvars.size] = ["perks", "1"];

    dvars[dvars.size] = ["zombie_hud", "0"];
    dvars[dvars.size] = ["velocity_hud", "0"];
    dvars[dvars.size] = ["zone_hud", "0"];

    foreach(dvar in dvars)
    {
        create_dvar(dvar[0], dvar[1]);
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
        
        common_scripts\utility::flag_set(power_switch.script_flag);
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
        
    common_scripts\utility::flag_init("door_opened");
    if (!isdefined(level.doorhintstrings))
    {
        level.doorhintstrings = [];
    }
    if (!isdefined(level.zombiedoors))
    {
        level.zombiedoors = common_scripts\utility::getstructarray("door", "targetname");
        common_scripts\utility::array_thread(level.zombiedoors, ::init_door);
    }
    wait(1);
    
    doorFlags = undefined;
    switch(level.getMapName)
    {
        case "mp_zombie_lab":
            doorFlags = [
                "courtyard_to_roundabout", "roundabout_to_lab", "roundabout_to_military",
                "courtyard_to_administration", "administration_to_lab", "military_to_experimentation"
            ];
            break;
        case "mp_zombie_brg":
            doorFlags = [
                "warehouse_to_gas_station", "warehouse_to_atlas", "gas_station_to_sewer",
                "atlas_to_sewer", "sewer_to_burgertown", "sewertrans_to_sewertunnel",
                "sewermain_to_sewercave", "burgertown_storage", "gas_station_interior", "atlas_command"
            ];
            break;
        case "mp_zombie_ark":
            doorFlags = [
                "sidebay_to_armory", "rearbay_to_armory", "cargo_elevator_to_cargo_bay",
                "biomed_to_cargo_bay", "armory_to_biomed", "armory_to_cargo_elevator",
                "medical_to_biomed", "moonpool_to_cargo_elevator", "sidebay_to_medical", "rearbay_to_moonpool"
            ];
            break;
        case "mp_zombie_h2o":
            doorFlags = [
                "start_to_zone_01", "start_to_zone_02", "zone_01_to_atrium",
                "zone_01_to_zone_01a", "zone_02_to_zone_01", "zone_02_to_zone_02a",
                "zone_02a_to_venthall", "venthall_to_zone_03", "venthall_to_atrium", "atrium_to_zone_04"
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
    
    common_scripts\utility::flag_set("door_opened");
}

set_round()
{
    level.wavecounter = getDvarInt("round");
    level.wavecounter -=1;
}

set_delay()
{
    self endon("disconnect");
    level endon("game_ended");

    level.waitbs = getDvarInt("delay");

    maps\mp\zombies\_util::pausezombiespawning(1);

    while(level.waitbs > -1)
    {
        self.waithud settext(level.waitbs);
        wait 1;
        level.waitbs --;
    }

    maps\mp\zombies\_util::pausezombiespawning(0);
    self.waithud destroy();
}

//Loadout Section

//give_player_assets --- function that runs upgrades, loadout and upgrades_revive
//upgrade --- gives Exo suit and Exo upgrades depending on map
//upgrades_revive --- gives Exo health and Exo revive after player is revived
//loadout --- gives player weapons depending on map

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
    switch(level.getMapName)
    {
        case "mp_zombie_lab":
            perkterminalgive(self, "exo_suit");
            perkterminalgive(self, "exo_revive");
            perkterminalgive(self, "exo_stabilizer");
            perkterminalgive(self, "exo_slam");
            perkterminalgive(self, "specialty_fastreload");
            perkterminalgive(self, "exo_health");
            break;
        case "mp_zombie_brg":
            perkterminalgive(self, "exo_suit");
            perkterminalgive(self, "exo_revive");
            perkterminalgive(self, "exo_stabilizer");
            perkterminalgive(self, "exo_slam");
            perkterminalgive(self, "specialty_fastreload");
            perkterminalgive(self, "exo_health");
            break;
        case "mp_zombie_ark":
            perkterminalgive(self, "exo_suit");
            perkterminalgive(self, "exo_tacticalArmor");
            perkterminalgive(self, "exo_revive");
            perkterminalgive(self, "exo_stabilizer");
            perkterminalgive(self, "exo_slam");
            perkterminalgive(self, "specialty_fastreload");
            perkterminalgive(self, "exo_health");
            break;
        case "mp_zombie_h2o":
            perkterminalgive(self, "exo_suit");
            perkterminalgive(self, "exo_tacticalArmor");
            perkterminalgive(self, "exo_revive");
            perkterminalgive(self, "exo_stabilizer");
            perkterminalgive(self, "exo_slam");
            perkterminalgive(self, "specialty_fastreload");
            perkterminalgive(self, "exo_health");
            break;
        return;
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
        switch(level.getMapName)
        {
        case "mp_zombie_lab":
            perkterminalgive(self, "exo_health");
            perkterminalgive(self, "exo_revive");
            break;
        case "mp_zombie_brg":
            perkterminalgive(self, "exo_health");
            perkterminalgive(self, "exo_revive");
            break;
        case "mp_zombie_ark":
            perkterminalgive(self, "exo_health");
            perkterminalgive(self, "exo_revive");
            break;
        case "mp_zombie_h2o":
            perkterminalgive(self, "exo_health");
            perkterminalgive(self, "exo_revive");
            break;  
        return; 
        }
    }
}

loadout()
{
    if(getDvarInt("loadout") == 0)
        return;

    if(getDvarInt("loadout") == 1) //Default Loadout
    {
    switch(level.getMapName)
    {
        case "mp_zombie_lab":
            loadout = ["iw5_mahemzm_mp", "iw5_exocrossbowzm_mp"]; 
            setweaponlevel( self, loadout[1], 15);
            setweaponlevel( self, loadout[0], 15);
                wait 5;
            self takeweapon( "iw5_titan45zm_mp" );  
            break;

        case "mp_zombie_brg":
            loadout = ["iw5_mahemzm_mp", "iw5_exocrossbowzm_mp"];                 
            setweaponlevel( self, loadout[1], 15);
            setweaponlevel( self, loadout[0], 15);
                wait 5;
            self takeweapon( "iw5_titan45zm_mp" );   
            break;  

        case "mp_zombie_ark":
            loadout = ["iw5_linegunzm_mp", "iw5_fusionzm_mp"];                
            setweaponlevel( self, loadout[1], 15);
            setweaponlevel( self, loadout[0], 15);    
                wait 5;
            self takeweapon( "iw5_titan45zm_mp" );  
            break;      

        case "mp_zombie_h2o":
            loadout = ["iw5_tridentzm_mp", "iw5_dlcgun4zm_mp"];               
            setweaponlevel( self, loadout[1], 15);			
            setweaponlevel( self, loadout[0], 15);  
                wait 5;
            self takeweapon( "iw5_titan45zm_mp" );           
            break;    
        return;                
    }
    wait 5;
    self settacticalweapon( "distraction_drone_zombie_mp" );
    self setweaponammoclip( "distraction_drone_zombie_mp", 3 );

    self setlethalweapon( "contact_grenade_zombies_mp" );
    self setweaponammoclip( "contact_grenade_zombies_mp", 5 );
    }

    if(getDvarInt("loadout") == 2) //First Room Loadout
    {
        switch(level.getMapName)
        {
            
        case "mp_zombie_brg":
            loadout = ["iw5_rhinozm_mp", "iw5_microwavezm_mp"];                 
            setweaponlevel( self, loadout[1], 15);
            setweaponlevel( self, loadout[0], 15);
                wait 5;
            self takeweapon( "iw5_titan45zm_mp" );   
            break;
        case "mp_zombie_h2o":
            loadout = ["iw5_rhinozm_mp", "iw5_dlcgun4zm_mp"];               
            setweaponlevel( self, loadout[1], 15);			
            setweaponlevel( self, loadout[0], 15);  
                wait 5;
            self takeweapon( "iw5_titan45zm_mp" );           
            break;    
        return;     
        }
        self settacticalweapon( "distraction_drone_zombie_mp" );
        self giveweapon( "distraction_drone_zombie_mp" );
        self setweaponammoclip( "distraction_drone_zombie_mp", 2 );
    }
}

//HUD Section

//zombie_hud --- zombie_remaining, has a bug where it breaks past round 75 and it doesnt include nuke kills & Explo Zombies 
//velocity_hud --- prints current player speed
//zone_hud --- prints current zone area

//return mp_zombie_brg due to overflow issues

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
    hud_text.label = &"Strat Tester";
    hud_text.sort = 1000; 
}

