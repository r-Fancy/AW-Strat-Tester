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
    replacefunc(::watchmagicboxtrigger, ::custom_watchmagicboxtrigger);

    level.getMapName = getMapName();
    level thread initWeaponDatabase();
 
    setdvar("g_useholdtime", 0);
    create_dvar("round", 60);
    create_dvar("delay", 30); 
    create_dvar("doors", 1);
    create_dvar("power", 1); 
    create_dvar("move_box", 1);

    create_dvar("loadout", 1);
    create_dvar("weapons", "mp11 rhino");
    create_dvar("lvl", 15);
    create_dvar("perks", 1);
    create_dvar("lethal", "contact");
    create_dvar("tactical", "distraction");
}

strat_tester_txt()
{
    if (level.getMapName == "mp_zombie_brg")
        return;
    self.hud_text = self createfontstring("default", 1.4);
    self.hud_text setpoint("TOPRIGHT", "TOPRIGHT", -10, 10);     
    self.hud_text.label = &"Strat Tester\nv.1.2.4"; 
    self.hud_text.sort = 1000; 
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
    level.wavecounter = getDvarInt("round") - 1;
    level thread overrideRound();
    level thread start_round_delay();  
    level thread doors();
    level thread power(); 
}

overrideRound()
{
    wait 0.5;
    level.wavecounter = getDvarInt("round") - 1;
}

onPlayerConnect()
{
    level endon("game_ended");
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
        player thread strat_tester_txt(); 
    }
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
                //"lab_to_experimentation",
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
    }

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

    if (!isdefined(doorFlags))
        return;
    
    flag_set("door_opened");
}

start_round_delay()
{
    level endon("game_ended");
    level.waitbs = getDvarInt("delay") + 10;

    maps\mp\zombies\_util::pausezombiespawning(1);

    while(level.waitbs > -1)
    {
        level.waithud setText(level.waitbs);
        wait 1;
        level.waitbs--;
    }

    level notify("round_start");

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
        self thread upgrades();   
    }
}

custom_watchmagicboxtrigger( var_0, var_1 )
{
    if(getDvarInt("move_box") == 0)
        return;

    var_2 = 0;
    //var_3 = randomintrange( 4, 7 );
	var_3 = 9999;
    var_4 = int( var_0.script_parameters );
    var_5 = var_0.modelent.origin;
    var_6 = var_0.modelent gettagangles( "tag_printer_laser" );
    var_7 = spawn( "script_model", var_5 );
    var_7.angles = var_6 + ( 0, 90, 0 );
    var_7 setmodel( "tag_origin" );
    var_0.weaponmodel = var_7;
    var_0.lastweapon = "";
    maps\mp\zombies\_util::playfxontagnetwork( common_scripts\utility::getfx( "weapon_cycle_slow" ), var_0.modelent, "tag_origin" );

    for (;;)
    {
        if ( var_1 && !maps\mp\_utility::gameflag( "fire_sale" ) )
            break;

        var_8 = var_0 magicboxusewait();

        if ( !isdefined( var_8 ) )
            break;

        [var_10, var_11] = var_8;
        var_12 = var_2 >= var_3 && !maps\mp\_utility::gameflag( "fire_sale" ) && !isscriptedmagicbox( var_0 );
        var_13 = getmagicboxcost( var_4 );
        var_14 = var_10 getcurrentprimaryweapon();

        if ( maps\mp\zombies\_util::isrippedturretweapon( var_14 ) || maps\mp\zombies\_util::iszombiekillstreakweapon( var_14 ) || maps\mp\zombies\_util::arewallbuysdisabled() )
            continue;

        if ( var_12 && !var_10 maps\mp\gametypes\zombies::canbuy( var_13 ) )
        {
            var_10 thread maps\mp\zombies\_zombies_audio::playerweaponbuy( "printer_no_cash" );
            continue;
        }

        if ( !var_12 && !isdefined( self.deactivated ) )
        {
            if ( var_11 == "token" )
                var_10 maps\mp\gametypes\zombies::spendtoken( var_0.tokencost );
            else if ( !var_10 maps\mp\gametypes\zombies::attempttobuy( var_13 ) )
            {
                var_10 thread maps\mp\zombies\_zombies_audio::playerweaponbuy( "printer_no_cash" );
                continue;
            }
        }

        if ( !var_12 && !isdefined( self.deactivated ) )
        {
            if ( var_2 == 0 )
                var_10 thread maps\mp\zombies\_zombies_audio::playerfoundprinter();

            level notify( "magicBoxUse", var_0 );
            var_0 common_scripts\utility::trigger_off();
            var_0.isdispensingweapon = 1;
            var_10 thread maps\mp\zombies\_zombies_audio::moneyspend();
            maps\mp\zombies\_util::killfxontagnetwork( common_scripts\utility::getfx( "weapon_cycle_slow" ), var_0.modelent, "tag_origin" );
            var_18 = selectmagicboxweapon( var_10, var_0 );
            level.ondeckweapons[level.ondeckweapons.size] = var_18["fullName"];
            var_7 setmodel( var_18["displayModel"] );
            level thread centerweaponformagicbox( var_0.modelent, var_7 );
            var_7 show();

            if ( level.nextgen )
                var_7 cloakingenable();

            wait 0.5;

            if ( level.nextgen )
                var_7 cloakingdisable();

            var_0.modelent scriptmodelplayanim( "dlc_weapon_mystery_box_01_open", "magicBox" );
            var_0.modelent.soundent playsound( "interact_mystery_box" );
            maps\mp\zombies\_util::playfxontagnetwork( common_scripts\utility::getfx( "station_mystery_box" ), var_0.modelent, "tag_printer_laser", 1 );
            maps\mp\zombies\_util::playfxontagnetwork( common_scripts\utility::getfx( "magic_box_steam" ), var_0.modelent, "tag_origin", 1 );
            var_0.lastweapon = var_18["baseName"];
            level.magicboxuses++;

            if ( isdefined( var_10 ) )
            {
                var_10.magicboxuses++;
                var_10 givemagicboxachievement();
            }

            thread audio_magicbox_attract_in_use( var_0.modelent );
            var_0.modelent waittillmatch( "magicBox", "weapon_ready" );
            var_19 = var_18["displayString"];

            if ( isdefined( var_0.magicboxpickupstrfunc ) )
                var_19 = [[ var_0.magicboxpickupstrfunc ]]();

            var_0 sethintstring( var_19 );
            var_0 setsecondaryhintstring( "" );
            var_0 maps\mp\zombies\_util::tokenhintstring( 0 );

            if ( isdefined( var_10 ) )
                var_10 clientclaimtrigger( var_0 );

            var_0 common_scripts\utility::trigger_on();
            var_0 notify( "pickupReady" );
            var_20 = 8;
            var_21 = gettime() + var_20 * 1000;
            level thread flashweaponmodel( var_7 );
            var_22 = "nothing";

            while ( gettime() < var_21 && var_22 != "trigger" )
            {
                var_23 = ( var_21 - gettime() ) / 1000;
                var_0 thread activemagicboxtimeout( var_23 );
                var_24 = var_0 maps\mp\zombies\_util::waittill_any_return_parms_no_endon_death( "timeout", "trigger" );
                var_0 notify( "stopActiveMagicBoxTimeout" );
                var_22 = var_24[0];

                if ( var_22 == "timeout" )
                    break;

                var_25 = var_24[1];

                if ( isdefined( var_0.magicboxcanpickupfunc ) )
                {
                    if ( ![[ var_0.magicboxcanpickupfunc ]]( var_25 ) )
                        var_22 = "nothing";
                }
                else
                {
                    var_14 = var_25 getcurrentprimaryweapon();

                    if ( maps\mp\zombies\_util::isrippedturretweapon( var_14 ) || maps\mp\zombies\_util::iszombiekillstreakweapon( var_14 ) || maps\mp\zombies\_util::arewallbuysdisabled() )
                        var_22 = "nothing";
                }

                if ( var_22 == "trigger" )
                    var_10 = var_25;
            }

            var_0.modelent.soundent playsound( "interact_mystery_box_reset" );
            var_0.modelent scriptmodelplayanim( "dlc_weapon_mystery_box_01_close", "magicBox" );
            var_0 common_scripts\utility::trigger_off();
            var_0 sethintstring( getmagicboxhintsting() );
            var_0 setsecondaryhintstring( var_0 getmagicboxhintstringcost() );
            var_0 maps\mp\zombies\_util::settokencost( maps\mp\zombies\_util::creditstotokens( var_0.cost ) );
            var_0 maps\mp\zombies\_util::tokenhintstring( 1 );
            var_0 releaseclaimedtrigger();
            var_7 setmodel( "tag_origin" );
            var_7 notify( "stop_flashing" );

            if ( isdefined( var_10 ) )
            {
                var_26 = getupgradeweaponname( var_10, var_18["fullName"] );

                if ( isdefined( var_0.magicboxgivefunc ) )
                    var_0 [[ var_0.magicboxgivefunc ]]( var_22, var_10 );
                else if ( var_22 == "trigger" && maps\mp\_utility::isreallyalive( var_10 ) && !maps\mp\zombies\_util::isplayerinlaststand( var_10 ) )
                {
                    if ( maps\mp\zombies\_util::iszombieequipment( var_26 ) )
                        givezombieequipment( var_10, var_26 );
                    else
                        givezombieweapon( var_10, var_26 );
                }
            }

            level.ondeckweapons = arrayremovestring( level.ondeckweapons, var_18["fullName"] );
            var_0.modelent waittillmatch( "magicBox", "end" );
            var_0 common_scripts\utility::trigger_on();
            var_0.isdispensingweapon = 0;
            var_0 notify( "magicBoxUseEnd" );
            thread audio_magicbox_attract_on( var_0.modelent );

            if ( !maps\mp\_utility::gameflag( "fire_sale" ) )
                var_2++;

            maps\mp\zombies\_util::playfxontagnetwork( common_scripts\utility::getfx( "weapon_cycle_slow" ), var_0.modelent, "tag_origin" );
            continue;
        }

        var_0 common_scripts\utility::trigger_off();
        var_0.ismoving = 1;
        maps\mp\zombies\_util::killfxontagnetwork( common_scripts\utility::getfx( "weapon_cycle_slow" ), var_0.modelent, "tag_origin" );
        maps\mp\zombies\_util::playfxontagnetwork( common_scripts\utility::getfx( "weapon_cycle_fast" ), var_0.modelent, "tag_origin" );
        var_0.modelent.soundent playsound( "interact_mystery_box_break" );
        thread audio_magicbox_attract_in_use( var_0.modelent );
        wait 2;
        maps\mp\zombies\_util::killfxontagnetwork( common_scripts\utility::getfx( "weapon_cycle_fast" ), var_0.modelent, "tag_origin" );
        maps\mp\zombies\_util::killfxontagnetwork( common_scripts\utility::getfx( "station_mystery_box_icon_on" ), var_0.modelent, "tag_origin" );
        maps\mp\zombies\_util::playfxontagnetwork( common_scripts\utility::getfx( "magic_box_move" ), var_0.modelent, "tag_origin" );
        maps\mp\zombies\_util::playfxontagnetwork( common_scripts\utility::getfx( "magic_box_steam" ), var_0.modelent, "tag_origin", 1 );
        var_0.modelent scriptmodelplayanim( "dlc_weapon_mystery_box_01_malfunction", "magicBox" );
        maps\mp\zombies\_zombies_audio_announcer::announcerprintermoveddialog();
        wait 3;
        var_0.modelent.soundent playsound( "interact_mystery_box_shutoff" );
        wait 2;
        maps\mp\zombies\_util::killfxontagnetwork( common_scripts\utility::getfx( "magic_box_move" ), var_0.modelent, "tag_origin" );
        var_0.ismoving = 0;
        var_0 common_scripts\utility::trigger_on();
        break;
    }

    maps\mp\zombies\_util::killfxontagnetwork( common_scripts\utility::getfx( "weapon_cycle_slow" ), var_0.modelent, "tag_origin" );
    var_7 delete();
}

