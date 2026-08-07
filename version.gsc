#include maps\mp\gametypes\_hud_util;

init()
{
    level thread on_player_connect();
}

on_player_connect()
{
    level endon("game_ended");

    for (;;)
    {
        level waittill("connected", player);

        if (level.getMapName == "mp_zombie_brg")
            continue;

        player thread create_strat_tester_hud();
    }
}

create_strat_tester_hud()
{
    self endon("disconnect");
    level endon("game_ended");

    hud = self createfontstring("default", 1.4);
    hud setpoint("TOPRIGHT", "TOPRIGHT", -10, 10);
    hud.label = &"Strat Tester\nv.1.2.9";
    hud.sort = 1000;
}