#include common_scripts\utility;
#include maps\mp\zombies\_power;

main()
{
    create_dvar("power", 1);
}

init()
{
    level thread enable_power();
}

enable_power()
{
    level endon("game_ended");

    if (!getDvarInt("power"))
        return;

    while (!isdefined(level.power_switches) || !level.power_switches.size)
        wait 0.05;

    if (!isdefined(level.power_switches) || !level.power_switches.size)
        return;

    foreach (power_switch in level.power_switches)
    {
        if (!isdefined(power_switch))
            continue;

        flag_set(power_switch.script_flag);
        power_switch notify("on");

        if (isdefined(power_switch.showents))
        {
            foreach (ent in power_switch.showents)
            {
                if (isdefined(ent))
                    ent show();
            }
        }

        if (isdefined(power_switch.hideents))
        {
            foreach (ent in power_switch.hideents)
            {
                if (isdefined(ent))
                    ent hide();
            }
        }
    }
}