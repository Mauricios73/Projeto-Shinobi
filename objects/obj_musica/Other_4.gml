show_debug_message("ROOM START - OBJ_MUSICA");
if (instance_number(obj_weather_manager) == 0)
{
    var inst = instance_create_depth(0, 0, -10000000, obj_weather_manager);
    inst.persistent = true; // opcional (mantém entre rooms)
    show_debug_message("CRIOU OBJ_WEATHER (room=" + room_get_name(room) + ")");
}

// se já tem música ativa, NÃO reinicia nada
if (musica_ativa) {
    exit;
}

// ======================
// LISTA DE MÚSICAS
// ======================
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

// pausa entre músicas
pause_min = 20;
pause_max = 60;

// agenda música
alarm[0] = room_speed * irandom_range(pause_min, pause_max);

musica_ativa = true;