#include maps\mp\zombies\killstreaks\_zombie_killstreaks;
#include common_scripts\utility;

main()
{
    replacefunc(::roundlogic, ::custom_roundlogic);
    create_dvar("supply_drops", 0);
}

init()
{
    level thread custom_roundlogic();
}

custom_roundlogic()
{
    if(getDvarInt("supply_drops") == 0)
        return;

    level.zmcarepackagelandingspots = common_scripts\utility::getstructarray( "carepackageDropPosition", "targetname" );

    if ( level.zmcarepackagelandingspots.size == 0 )
        return;

    level.zmusedcarepackagelandingspots = [];
    level.getcratefordroptype = ::getcrate;
    level.zmkillstreakcrateprevo = 0;
    level.zmkillstreakcratereactvo = 0;
    level.zmkillstreakcratefirstvo = 0;
    thread setupdroppositions();
    thread schedulescorestreaks();
    thread schedulemoneydrops();
    var_0 = randomintrange( 3, 5 );

    for (;;)
    {
        level waittill( "zombie_wave_started" );

        if ( maps\mp\zombies\_util::is_true( level.disablecarepackagedrops ) )
            continue;

        while ( level.wavecounter >= var_0 )
        {
            var_1 = randomfloatrange( 20, 30 );
            var_2 = level common_scripts\utility::waittill_notify_or_timeout_return( "zombie_wave_ended", var_1 );

            if ( !isdefined( var_2 ) || var_2 != "timeout" )
                continue;

            if ( level.currentgen && isdefined( level.numzombierewarddrops ) && level.numzombierewarddrops >= 4 )
                continue;

            if ( isdefined( level.nodroppodpenalty ) && level.nodroppodpenalty == 1 )
                continue;

            if ( maps\mp\zombies\_util::is_true( level.disablecarepackagedrops ) )
                continue;

            var_2 = dropcarepackage();

            if ( isdefined( var_2 ) )
            {
                if ( isdefined( level.roundsupplydrops ) )
                    level.roundsupplydrops[level.roundsupplydrops.size] = var_2;

                if ( level.players.size == 4 )
                {
                    var_2 = dropcarepackage();

                    if ( isdefined( var_2 ) && isdefined( level.roundsupplydrops ) )
                        level.roundsupplydrops[level.roundsupplydrops.size] = var_2;
                }

                var_0 = var_0 + randomintrange( 2, 4 );
            }
        }

        level waittill( "zombie_wave_ended" );
    }
}