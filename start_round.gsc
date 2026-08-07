#include common_scripts\utility;

main()
{
    create_dvar("round", 64);
}

init()
{
    level thread override_round();
}

override_round()
{
    level endon("game_ended");

    wait 0.5;

    round = getDvarInt("round");

    if (round < 1)
        round = 1;

    level.wavecounter = round - 1;
}