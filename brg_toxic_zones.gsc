#include maps\mp\mp_zombie_brg;
#include common_scripts\utility;

main()
{
    replaceFunc(::toxicgaszoneevent, ::custom_toxicgaszoneevent);
    create_dvar("toxic_round", 0);
}

init()
{
    custom_toxicgaszoneevent();
}

custom_toxicgaszoneevent()
{
    self endon("disconnect");
    level endon("game_ended");

    if(getDvarInt("toxic_round") == 0)
        return;

    var_0 = [ "Atlas", "BurgerTown", "GasStation" ];

    for (;;)
    {
        level waittill( "zombie_round_countdown_started" );

        if ( level.roundtype == "civilian" )
            continue;

        if ( level.wavecounter >= level.nexttoxicgasround )
        {
            var_1 = [];
            var_2 = maps\mp\zombies\_zombies_zone_manager::getcurrentplayeroccupiedzones();

            if ( var_2.size <= 0 )
                continue;

            foreach ( var_4 in var_2 )
            {
                foreach ( var_6 in var_0 )
                {
                    if ( !common_scripts\utility::array_contains( level.toxiczones[var_6].zones, var_4 ) )
                        continue;

                    if ( !common_scripts\utility::array_contains( var_1, level.toxiczones[var_6].zonename ) )
                        var_1 = common_scripts\utility::array_add( var_1, level.toxiczones[var_6].zonename );
                }
            }

            thread activatetoxiczones( var_1, var_0 );

            if ( level.wavecounter >= 30 )
                level.special_mutators["emz"][1] = 1;

            calculatenexttoxicgasround();
        }
    }
}