#include maps\mp\zombies\_area_invalidation;
#include common_scripts\utility;

main()
{
    replaceFunc(::can_do_breach, ::custom_can_do_breach);
    create_dvar("breach", 0);
}

init()
{
    level thread custom_can_do_breach();
}

custom_can_do_breach()
{
    self endon("disconnect");
    level endon("game_ended");

    if (getDvarInt("breach") == 0)
        return 0;

    if ( level.roundtype == "zombie_host" )
        return 0;

    if ( maps\mp\agents\_agent_utility::getactiveagentsoftype( "zombie_melee_goliath" ).size > 0 )
        return 0;

    var_0 = get_breached_zones();

    if ( var_0.size != 0 )
        return 0;

    var_1 = get_contaminated_zones();

    if ( var_1.size >= 3 )
        return 0;

    var_2 = level.totalaispawned / level.totaldesiredai;

    if ( var_2 >= 0.8 )
        return 0;

    return 1;
}