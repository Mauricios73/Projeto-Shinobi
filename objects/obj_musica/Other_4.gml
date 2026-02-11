show_debug_message("ROOM START - OBJ_MUSICA");

// se já tem música ativa, NÃO reinicia nada
if (musica_ativa) {
    exit;
}

// ======================
// LISTA DE MÚSICAS
// ======================
musicas = [
    snd_senya_itachi,
    snd_lotus_pond
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