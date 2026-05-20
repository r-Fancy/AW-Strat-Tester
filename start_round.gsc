#include common_scripts\utility;

main()
{
    create_dvar("round", 64);
}

init()
{
    level thread overrideRound();
}

overrideRound()
{   
    level endon( "game_ended" );
    self endon( "disconnect" );

    wait 0.5;
    level.wavecounter = getDvarInt("round") - 1;
}
