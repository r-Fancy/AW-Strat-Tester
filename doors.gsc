#include common_scripts\utility;
#include maps\mp\zombies\_doors;
#include maps\mp\_utility;

main()
{
    level.getMapName = getMapName();
    create_dvar("doors", 1); 

    door_flags = get_door_flags();

    foreach (door_flag in door_flags)
        create_dvar("door_" + door_flag, 1);
}

init()
{
    level thread open_configured_doors();
}

open_configured_doors()
{
    level endon("game_ended");

    if (!getDvarInt("doors"))
        return;

    door_flags = get_door_flags();

    if (!door_flags.size)
        return;

    while (!isdefined(level.zombiedoors))
        wait 0.05;

    foreach (door_flag in door_flags)
    {
    if (!getDvarInt("door_" + door_flag))
        continue;

    foreach (door_struct in level.zombiedoors)
        {
        if (!isdefined(door_struct) || door_struct.script_flag != door_flag)
            continue;

        while (!isdefined(door_struct.triggers) || !isdefined(door_struct.movers))
            wait 0.05;

        waitframe();

        if (!isdefined(door_struct.open) || !door_struct.open)
            door_struct notify("open", undefined);
        }
    }
}

get_door_flags()
{
    switch (level.getMapName)
    {
        case "mp_zombie_lab":
            return [
                "courtyard_to_roundabout",
                "courtyard_to_administration",
                "roundabout_to_lab",
                "roundabout_to_military",
                "administration_to_lab",
                "military_to_experimentation",
                "lab_to_experimentation"
            ];

        case "mp_zombie_brg":
            return [
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
        
        case "mp_zombie_ark":
            return [
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

        case "mp_zombie_h2o":
            return [
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
    }

    return [];
}
