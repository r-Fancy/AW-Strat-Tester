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
    if(getDvarInt("toxic_round") == 1)
        return;

    return;
}