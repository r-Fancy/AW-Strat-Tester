#include common_scripts\utility;
#include maps\mp\zombies\_terminals;

main()
{
    create_dvar("perks", 1);
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
        self thread exo_upgrades();
        self thread exo_upgrades_on_revive();
    }
}

exo_upgrades()
{
    self endon("disconnect");
    level endon("game_ended");

    if(getDvarInt("perks") == 0)
        return;

    wait 5;   
    if (level.getMapName == "mp_zombie_lab" || level.getMapName == "mp_zombie_brg")
    {
            perkterminalgive(self, "exo_suit");
            perkterminalgive(self, "exo_revive");
            perkterminalgive(self, "exo_stabilizer");
            perkterminalgive(self, "exo_slam");
            perkterminalgive(self, "specialty_fastreload");
            perkterminalgive(self, "exo_health");
    }

    if (level.getMapName == "mp_zombie_ark" || level.getMapName == "mp_zombie_h2o")
    {
            perkterminalgive(self, "exo_suit");
            perkterminalgive(self, "exo_tacticalArmor");
            perkterminalgive(self, "exo_revive");
            perkterminalgive(self, "exo_stabilizer");
            perkterminalgive(self, "exo_slam");
            perkterminalgive(self, "specialty_fastreload");
            perkterminalgive(self, "exo_health");
    }
}

exo_upgrades_on_revive()
{
    self endon("disconnect");
    level endon("game_ended");

    if(getDvarInt("perks") == 0)
        return;

    wait 2;
    while(1)
    {
        self waittill("revive_trigger");
        self thread exo_upgrades();   
    }
}