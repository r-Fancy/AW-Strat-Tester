#include common_scripts\utility;
#include maps\mp\zombies\_doors;
#include maps\mp\_utility;

main()
{
    level.getMapName = getMapName();
    create_dvar("doors", 1);
}

init()
{
    level thread doors();
}

doors()
{   
    level endon( "game_ended" );
    self endon( "disconnect" );

    wait 1;

    if(getDvarInt("doors") == 0)
        return;
        
    flag_init("door_opened");
    if (!isdefined(level.doorhintstrings))
    {
        level.doorhintstrings = [];
    }
    if (!isdefined(level.zombiedoors))
    {
        level.zombiedoors = getstructarray("door", "targetname");
        array_thread(level.zombiedoors, ::init_door);
    }
    wait(1);
    
    doorFlags = undefined;
    switch(level.getMapName)
    {
        case "mp_zombie_lab":
            doorFlags = [
                "courtyard_to_roundabout",
                "roundabout_to_lab",
                "roundabout_to_military",
                "courtyard_to_administration",
                "administration_to_lab", 
                //"lab_to_experimentation",
                "military_to_experimentation"
            ];
            break;

        case "mp_zombie_brg":
            doorFlags = [
                "warehouse_to_gas_station",
                "warehouse_to_atlas",
                "gas_station_interior", 
                "gas_station_to_sewer",
                "atlas_command",
                "atlas_to_sewer",  
                "sewertrans_to_sewertunnel",
                "sewermain_to_sewercave",
                "sewer_to_burgertown", 
                "burgertown_storage"  
            ];
            break;
        case "mp_zombie_ark":
            doorFlags = [
                "sidebay_to_armory", 
                "rearbay_to_armory", 
                "cargo_elevator_to_cargo_bay",
                "biomed_to_cargo_bay", 
                "armory_to_biomed", 
                "armory_to_cargo_elevator",
                "medical_to_biomed", 
                "moonpool_to_cargo_elevator", 
                "sidebay_to_medical", 
                "rearbay_to_moonpool"
            ];
            break;
        case "mp_zombie_h2o":
            doorFlags = [
                "start_to_zone_01", 
                "start_to_zone_02", 
                "zone_01_to_atrium",
                "zone_01_to_zone_01a",
                "zone_02_to_zone_01", 
                "zone_02_to_zone_02a",
                "zone_02a_to_venthall", 
                "venthall_to_zone_03", 
                "venthall_to_atrium", 
                "atrium_to_zone_04"
            ];
            break;
    }

    foreach(door_flag in doorFlags)
    {
        foreach(door in level.zombiedoors)
        {
            if(isdefined(door.script_flag) && door.script_flag == door_flag)
            {
                door notify("open", undefined);
                if(isdefined(level.doorbitmaskarray[door_flag]))
                {
                    level.doorsopenedbitmask |= level.doorbitmaskarray[door_flag];
                }
            }
        }
    }

    if (!isdefined(doorFlags))
        return;
    
    flag_set("door_opened");
}