#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\zombies\zombies_spawn_manager;
#include maps\mp\gametypes\zombies;
#include common_scripts\_createfx;
#include maps\mp\zombies\_mutators;

main()
{
    replaceFunc(::mutatorexploder_explode, ::custom_mutatorexploder_explode);
    create_dvar("zombie_hud", 0);
    create_dvar("velocity_hud", 0);
    create_dvar("zone_hud", 0);
    create_dvar("sph_hud", 0);
}

custom_mutatorexploder_explode( var_0, var_1, var_2 )
{
    self.hasexploded = 1;

    if ( var_2 )
    {
        var_3 = level._effect["mut_exp_explosion_lg"];

        if ( isdefined( self.detonatelargefxoverride ) )
            var_3 = self.detonatelargefxoverride;

        playfx( var_3, var_1 );
        self notify( "stopWarningSound" );
        playsoundatpos( var_1, "zmb_exploder_explode" );
        radiusdamage( var_1 + ( 0, 0, 60 ), 180, 45, 15, var_0, "MOD_EXPLOSIVE", "exploder_zm_large_mp", 1 );
    }
    else
    {
        var_3 = level._effect["mut_exp_explosion_sm"];

        if ( isdefined( self.detonatesmallfxoverride ) )
            var_3 = self.detonatesmallfxoverride;

        playfx( var_3, var_1 );
        self notify( "stopWarningSound" );
        playsoundatpos( var_1, "zmb_exploder_explode_small" );
        radiusdamage( var_1 + ( 0, 0, 60 ), 120, 1, 1, var_0, "MOD_EXPLOSIVE", "exploder_zm_small_mp", 1 );
    }

    if ( isalive( self ) )
    {
        trymutilate( undefined, "exploder_zm_large_mp", "MOD_EXPLOSIVE", 1.0, self, undefined );
        if ( var_2 )
        {
          if ( !isdefined( level.exploderSelfKills ) )
            level.exploderSelfKills = 0;
            level.exploderSelfKills++;
        }
        self suicide();
    }
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

        if (level.getMapName == "mp_zombie_brg")
            continue;

        player thread init_player_huds();
    }
}

init_player_huds()
{
    self endon("disconnect");
    level endon("game_ended");

    if (level.getMapName == "mp_zombie_brg")
        return;

    if (getDvarInt("zombie_hud"))
        self thread zombie_hud();

    if (getDvarInt("velocity_hud"))
        self thread velocity_hud();

    if (getDvarInt("zone_hud"))
        self thread zone_hud();

    if (getDvarInt("sph_hud"))
        self thread sph_hud();

    self waittill("disconnect");
    self cleanup_huds();
}

cleanup_huds()
{
    if (isdefined(self.zT_hud))
        self.zT_hud destroy();

    if (isdefined(self.vel_hud))
        self.vel_hud destroy();

    if (isdefined(self.zone_hud))
        self.zone_hud destroy();

    if (isdefined(self.sph_hud))
        self.sph_hud destroy();
}

calculateZombieCount()
{
    totalAI = maps\mp\zombies\zombies_spawn_manager::calculatetotalai();

    if ( !isdefined( totalAI ) )
        totalAI = 0;

    killsThisRound = 0;

    if ( isdefined( self.kills ) )
        killsThisRound = int( self.kills );

    if ( isdefined( self.killsatroundstart ) )
        killsThisRound -= int( self.killsatroundstart );

    if ( !isdefined( level.exploderSelfKills ) )
        level.exploderSelfKills = 0;

    if ( !isdefined( self.exploderSelfKillsAtRoundStart ) )
    {
        self.exploderSelfKillsAtRoundStart = level.exploderSelfKills;
        self.exploderKillsRoundStartKills = self.killsatroundstart;
    }
    else if ( isdefined( self.killsatroundstart ) &&
              self.exploderKillsRoundStartKills != self.killsatroundstart )
    {
        self.exploderSelfKillsAtRoundStart = level.exploderSelfKills;
        self.exploderKillsRoundStartKills = self.killsatroundstart;
    }

    exploderSelfKillsThisRound = level.exploderSelfKills - self.exploderSelfKillsAtRoundStart;

    if ( exploderSelfKillsThisRound < 0 )
        exploderSelfKillsThisRound = 0;

    return totalAI - killsThisRound - exploderSelfKillsThisRound;
}

zombie_hud()
{
    self.zT_hud = newClientHudElem(self);
    self.zT_hud.alignx = "right";
    self.zT_hud.aligny = "top";
    self.zT_hud.horzalign = "user_left";
    self.zT_hud.vertalign = "user_top";
    self.zT_hud.x += 20;
    self.zT_hud.y += 70;
    self.zT_hud.fontscale = 1;
    self.zT_hud.hidewheninmenu = 1;
    self.zT_hud.label = &"Zombies remaining: ";
    self.zT_hud.alpha = 1;
    
    lastCount = -1;

    level waittill( "zombie_wave_started" );
    while(true)
    {
        currentCount = self calculateZombieCount();
        if (!isDefined(currentCount))
            currentCount = 0;
        currentCount = int(currentCount);

        if(currentCount != lastCount)
        {
            self.zT_hud setvalue(currentCount);
            lastCount = currentCount;
        }
        wait 0.25;
    }
}

velocity_hud()
{
    self.vel_hud = newClientHudElem(self);
    self.vel_hud.alignx = "right";
    self.vel_hud.aligny = "top";
    self.vel_hud.horzalign = "user_left";
    self.vel_hud.vertalign = "user_top";
    self.vel_hud.x += 20;
    self.vel_hud.y += 85;
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
    self.zone_hud = newClientHudElem(self);
    self.zone_hud.alignx = "right";
    self.zone_hud.aligny = "top";
    self.zone_hud.horzalign = "user_left";
    self.zone_hud.vertalign = "user_top";
    self.zone_hud.x += 20;
    self.zone_hud.y += 100;
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

set_sph_frozen(hud, sph)
{
    hud setValue(sph);
    level waittill("zombie_wave_started");
}

sph_hud() 
{
	self endon("disconnect");
	sph_hud = newClientHudElem(self);
	sph_hud.alignx = "right";
	sph_hud.aligny = "top";
	sph_hud.horzalign = "user_left";
	sph_hud.vertalign = "user_top";
	sph_hud.x += 20;
	sph_hud.y += 55; 
	sph_hud.fontscale = 1;
	sph_hud.hidewheninmenu = 1;
	sph_hud.label = &"SPH: ";
	
    level waittill( "zombie_wave_started" );
	zombies_in_round = self calculateZombieCount();
    // start_time = int(gettime() / 1000);
    tyme = 0;
	
    while(1)
    {
		zombie_count = self calculateZombieCount();
		zombie_killed = zombies_in_round - zombie_count; 
		zombie_killed = zombie_killed / 24;
		
		// current_time = int(gettime() / 1000) - start_time;
		wait 1; 
		tyme++;

        if (zombie_killed > 0)
            round_seconds_per_horde = tyme / zombie_killed;
        else
            round_seconds_per_horde = 0;
		
		round_seconds_per_horde = tyme / zombie_killed;
		
		if(zombie_count == 0) 
		{
			set_sph_frozen(sph_hud, round_seconds_per_horde); 
			
			zombies_killed = 0; // resets var
			zombies_in_round = self calculateZombieCount();

			tyme = 0; 
			if(level.wavecounter == 0)
			{
				tyme = 10;
			}
		}
        
        while (calculateZombieCount() >= zombies_in_round)
        {
            wait 0.5;
        }
		sph_hud setValue(round_seconds_per_horde);

        if(zombie_count == 0) 
        {
            sph_hud setValue(round_seconds_per_horde);
        }
    }
}