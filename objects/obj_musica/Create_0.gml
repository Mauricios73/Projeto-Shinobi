persistent = true;

var rn_music = room_get_name(room);
if (rn_music == "rm_init" || rn_music == "rm_menu")
{
    instance_destroy();
    exit;
}

musica_ativa = false;
pause_min = 20;
pause_max = 60;

music_start_cycle = function()
{
    if (musica_ativa) exit;

    musicas = [
        snd_senya_itachi,
        snd_lotus_pond,
        Amos_Roddy___Kingdom_Two_Crowns_OST___01_Into_the_Green_Vale,
        Amos_Roddy___Kingdom_Two_Crowns_OST___02_Driftwood,
        Amos_Roddy___Kingdom_Two_Crowns_OST___03_Kodama_Sunset,
        Amos_Roddy___Kingdom_Two_Crowns_OST___04_Kami_of_the_Dust,
        Amos_Roddy___Kingdom_Two_Crowns_OST___05_Kojin,
        Amos_Roddy___Kingdom_Two_Crowns_OST___06_Vellum,
        Amos_Roddy___Kingdom_Two_Crowns_OST___07_Bushi
    ];

    mus_atual = noone;
    mus_anterior = noone;
    vol_musica = 0.20;

    alarm[0] = room_speed * irandom_range(pause_min, pause_max);
    musica_ativa = true;
}

music_start_cycle();
