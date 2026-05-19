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
    if (getDvarInt("breach") == 1)
        return;

    return 0;
}