#include maps\mp\gametypes\zombies;

main()
{
    setdvar("g_useholdtime", 0);
}

init()
{
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    
    for(;;)
    {
        self waittill("spawned_player");
        self freezeControls(false);
        self resetmoney(7777777);
        // self thread give_player_assets();
    }
}