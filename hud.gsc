#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\zombies\zombies_spawn_manager;
#include maps\mp\gametypes\zombies;
#include common_scripts\_createfx;

main()
{
    create_dvar("zombie_hud", 0);
    create_dvar("velocity_hud", 0);
    create_dvar("zone_hud", 0);
}

init()
{
    self thread onPlayerConnect();
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
        self hud_init();
    }
}

hud_init()
{
    self endon("disconnect");
    level endon("game_ended");

    self thread cleanupHUD();
    
    if (getDvarInt("zombie_hud") == 1)
        self thread zombie_hud();
    if (getDvarInt("velocity_hud") == 1)
        self thread velocity_hud();
    if (getDvarInt("zone_hud") == 1)
        self thread zone_hud();
}

cleanupHUD()
{
    level endon("game_ended");   
    self waittill("disconnect");
    
    if(isDefined(self.zT_hud)) 
        self.zT_hud destroy();
    if(isDefined(self.vel_hud)) 
        self.vel_hud destroy();
    if(isDefined(self.zone_hud)) 
        self.zone_hud destroy();
    if(isDefined(self.hud_text)) 
        self.hud_text destroy();
}

zombie_hud()
{
    if (level.getMapName == "mp_zombie_brg")
        return;

    self.zT_hud = newClientHudElem(self);
    self.zT_hud.alignx = "right";
    self.zT_hud.aligny = "top";
    self.zT_hud.horzalign = "user_left";
    self.zT_hud.vertalign = "user_top";
    self.zT_hud.x += 20;
    self.zT_hud.y += 80;
    self.zT_hud.fontscale = 1;
    self.zT_hud.hidewheninmenu = 1;
    self.zT_hud.label = &"Zombies remaining: ";
    self.zT_hud.alpha = 1;
    
    lastCount = -1;
    
    while(true)
    {
        currentCount = self thread calculateZombieCount();
        if(currentCount != lastCount) 
        {
            self.zT_hud setvalue(currentCount);
            lastCount = currentCount;
        }
        wait 0.25;
    }
}

calculateZombieCount()
{
    totalAI = maps\mp\zombies\zombies_spawn_manager::calculatetotalai();
    killsThisRound = int(self.kills) - int(self.killsatroundstart);
    return totalAI - killsThisRound;
}

velocity_hud()
{
    if (level.getMapName == "mp_zombie_brg")
        return;

    self.vel_hud = newClientHudElem(self);
    self.vel_hud.alignx = "right";
    self.vel_hud.aligny = "top";
    self.vel_hud.horzalign = "user_left";
    self.vel_hud.vertalign = "user_top";
    self.vel_hud.x += 20;
    self.vel_hud.y += 70;
    self.vel_hud.fontscale = 1.0;
    self.vel_hud.hidewheninmenu = 1;
    self.vel_hud.label = &"Velocity: ";
    self.vel_hud.alpha = 1;

    lastVel = -1;
    
    while(true)
    {
        velocity = self getvelocity();
        currentVel = floor(sqrt(float(velocity[0] * velocity[0]) + float(velocity[1] * velocity[1])));
        
        if(currentVel != lastVel) 
        {
            self.vel_hud setvalue(currentVel);
            lastVel = currentVel;
        }
        wait 0.1;
    }
}

zone_hud()
{
    if (level.getMapName == "mp_zombie_brg")
        return;

    self.zone_hud = newClientHudElem(self);
    self.zone_hud.alignx = "right";
    self.zone_hud.aligny = "top";
    self.zone_hud.horzalign = "user_left";
    self.zone_hud.vertalign = "user_top";
    self.zone_hud.x += 20;
    self.zone_hud.y += 60;
    self.zone_hud.fontscale = 1.0;
    self.zone_hud.hidewheninmenu = 1;
    self.zone_hud.alpha = 1;

    lastZone = "";
    
    while(true)
    {
        if (isDefined(self.currentzone) && self.currentzone != lastZone)
        {
            self.zone_hud setText(self.currentzone);
            lastZone = self.currentzone;
        }
        wait 0.2;
    }
}