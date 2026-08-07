#include maps\mp\gametypes\zombies;
#include common_scripts\utility;

main()
{
    create_dvar("drop_type", "ammo");
    create_dvar("drop_request", 0);
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
        player thread monitor_drop_dvar();
    }
}

monitor_drop_dvar()
{
    self endon("disconnect");
    level endon("game_ended");

    // Only the host processes the dvar, preventing duplicate drops.
    if (!self isHost())
        return;

    last_request = getDvarInt("drop_request");

    for (;;)
    {
        request = getDvarInt("drop_request");

        if (request != last_request)
        {
            last_request = request;
            drop_type = getDvar("drop_type");

            if (is_valid_drop(drop_type))
            {
                position = self.origin + anglesToForward(self.angles) * 115;
                level maps\mp\gametypes\zombies::createPickup(drop_type, position);
            }
        }

        wait 0.05;
    }
}

is_valid_drop(drop_type)
{
    switch (drop_type)
    {
        case "nuke":
        case "ammo":
        case "insta_kill":
        case "double_points":
        case "fire_sale":
        case "trap":
            return 1;
    }

    return 0;
}