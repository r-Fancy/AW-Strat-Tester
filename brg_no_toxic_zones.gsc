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

    if(getDvarInt("toxic_round") == 1)
        return;

    return;
}