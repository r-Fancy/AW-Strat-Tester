#include common_scripts\utility;

main()
{
    create_dvar("infinite_ammo", 0);
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
        player thread infinite_ammo_loop();
    }
}

infinite_ammo_loop()
{
    self endon("disconnect");
    level endon("game_ended");

    for (;;)
    {
        if (getDvarInt("infinite_ammo"))
        {
            weapon = self getCurrentWeapon();

            if (isdefined(weapon) && weapon != "none")
            {
                self setWeaponAmmoClip(weapon, 999);
                self setWeaponAmmoClip(weapon, 999, "left");
                self setWeaponAmmoClip(weapon, 999, "right");
            }
        }

        wait 0.1;
    }
}