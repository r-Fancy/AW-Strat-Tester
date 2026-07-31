#include maps\mp\zombies\_util;
#include common_scripts\utility;

main()
{
    replaceFunc(::isspecialround, ::custom_isspecialround);
    create_dvar("special_round", 0);
}

custom_isspecialround(var_0)
{
    if ( getdvar("special_round") == "0" )
        return 0;

    if ( !isdefined( var_0 ) )
        var_0 = level.wavecounter;

    if ( var_0 == level.specialroundnumber )
        return 1;

    return 0;
}
