#include common_scripts\utility;
#include maps\mp\zombies\_terminals;

main()
{
    create_dvar("perks", 1);
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
        player thread setup_player_perks();
    }
}

setup_player_perks()
{
    self endon("disconnect");
    level endon("game_ended");

    self thread perks_on_revive();

    for (;;)
    {
        self waittill("spawned_player");

        self.perk_spawn_id++;
        self thread give_perks_after_delay(5, self.perk_spawn_id);
    }
}

perks_on_revive()
{
    self endon("disconnect");
    level endon("game_ended");

    for (;;)
    {
        self waittill("revive_trigger");
        self thread give_perks_after_delay(0, self.perk_spawn_id);
    }
}

give_perks_after_delay(delay, spawn_id)
{
    self endon("disconnect");
    level endon("game_ended");

    wait delay;

    // Do not apply perks from an old spawn thread.
    if (self.perk_spawn_id != spawn_id || !isalive(self))
        return;

    if (!getDvarInt("perks"))
        return;

    map = level.getMapName;

    perkterminalgive(self, "exo_suit");
    perkterminalgive(self, "exo_revive");
    perkterminalgive(self, "exo_stabilizer");
    perkterminalgive(self, "exo_slam");
    perkterminalgive(self, "specialty_fastreload");
    perkterminalgive(self, "exo_health");

    if (map == "mp_zombie_ark" || map == "mp_zombie_h2o")
        perkterminalgive(self, "exo_tacticalArmor");
}