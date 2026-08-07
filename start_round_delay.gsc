#include common_scripts\utility;
#include maps\mp\zombies\_util;

main()
{
    create_dvar("delay", 30);
}

init()
{
    level thread start_round_delay();
}

start_round_delay()
{
    level endon("game_ended");

    wait 10;

    delay = getDvarInt("delay");

    if (delay < 0)
        delay = 0;

    maps\mp\zombies\_util::pausezombiespawning(1);

    while (delay > 0)
    {
        if (isdefined(level.waithud))
            level.waithud setText(delay);

        wait 1;
        delay--;
    }

    if (isdefined(level.waithud))
    {
        level.waithud setText(0);
        level.waithud destroy();
    }

    level notify("round_start");
    maps\mp\zombies\_util::pausezombiespawning(0);
}