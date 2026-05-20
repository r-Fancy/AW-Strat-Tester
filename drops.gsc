#include common_scripts\utility;
#include maps\mp\zombies\_util;

main()
{
    replacefunc(::arepickupsdisabled, ::custom_arepickupsdisabled);
    create_dvar("drops", 0);
}

init()
{
    level thread custom_arepickupsdisabled();
}

custom_arepickupsdisabled()
{
    if(getDvarInt("drops") == 0)
        return true;

    return isdefined( level.disablepickups ) && level.disablepickups > 0;
}
