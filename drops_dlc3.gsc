#include common_scripts\utility;
#include maps\mp\zombies\_pickups_dlc3;

main()
{
    replacefunc(::canspawnpickup, ::custom_canspawnpickup);
    create_dvar("drops_dlc3", 0);
}

init()
{
    level thread custom_canspawnpickup();
}

custom_canspawnpickup( var_0, var_1, var_2, var_3 )
{
    if(getDvarInt("drops") == 0)
        return 0;
    
    if ( maps\mp\_utility::gameflag( "explosive_touch" ) )
        return 0;

    return 1;
}
