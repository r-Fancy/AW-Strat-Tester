#include maps\mp\zombies\_wall_buys;
#include common_scripts\utility;

main()
{
	replacefunc(::watchmagicboxtrigger, ::custom_watchmagicboxtrigger);
    create_dvar("move_box", 0);
}

custom_watchmagicboxtrigger( var_0, var_1 )
{
    self endon("disconnect");
    level endon("game_ended");

    if (getDvarInt("move_box") == 1)
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