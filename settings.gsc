#include maps\mp\gametypes\zombies;

main()
{
    setdvar("g_useholdtime", 0);
}

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
        player thread on_player_spawned();
    }
}

on_player_spawned()
{
    self endon("disconnect");
    level endon("game_ended");

    for (;;)
    {
        self waittill("spawned_player");
        self freezecontrols(false);
        self resetmoney(7777777);
    }
}