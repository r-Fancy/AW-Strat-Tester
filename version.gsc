#include maps\mp\gametypes\_hud_util;

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
        player thread strat_tester_txt(); 
    }
}

strat_tester_txt()
{
    self endon("disconnect");
    level endon("game_ended");

    if (level.getMapName == "mp_zombie_brg")
        return;
    self.hud_text = self createfontstring("default", 1.4);
    self.hud_text setpoint("TOPRIGHT", "TOPRIGHT", -10, 10);     
    self.hud_text.label = &"Strat Tester\nv.1.2.5"; 
    self.hud_text.sort = 1000; 
}