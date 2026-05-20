#include common_scripts\utility;
#include maps\mp\zombies\_power;

main()
{
    create_dvar("power", 1);
}

init()
{
    level thread power(); 
}

power()
{
    self endon("disconnect");
    level endon("game_ended");

    if(getDvarInt("power") == 0)
        return;

    wait 1;

    if (!isDefined(level.power_switches) || level.power_switches.size == 0)
        return;

    foreach (power_switch in level.power_switches)
    {
        if (!isDefined(power_switch)) continue;
        
        flag_set(power_switch.script_flag);
        power_switch notify("on");

        if (isDefined(power_switch.showents))
        {
            foreach (ent in power_switch.showents)
                if (isDefined(ent)) ent show();
        }
        
        if (isDefined(power_switch.hideents))
        {
            foreach (ent in power_switch.hideents)
                if (isDefined(ent)) ent hide();
        }
    }
}
