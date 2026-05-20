#include maps\mp\zombies\_area_invalidation;
#include common_scripts\utility;

main()
{
    replaceFunc(::can_do_breach, ::custom_can_do_breach);
    create_dvar("breach", 0);
}

init()
{
    custom_can_do_breach();
}

custom_can_do_breach()
{
    self endon("disconnect");
    level endon("game_ended");

    if (getDvarInt("breach") == 1)
        return;

    return 0;
}