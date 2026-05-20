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
    level endon( "game_ended" );
    self endon( "disconnect" );

    wait 10;
    level.waitbs = getDvarInt("delay");

    maps\mp\zombies\_util::pausezombiespawning(1);

    while(level.waitbs > -1)
    {
        level.waithud setText(level.waitbs);
        wait 1;
        level.waitbs--;
    }

    level notify("round_start");

    maps\mp\zombies\_util::pausezombiespawning(0);
    level.waithud destroy();
}