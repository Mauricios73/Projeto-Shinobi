var nova_musica;

show_debug_message("ALARME 0 EXECUTOU");

// segurança extra: evita empilhamento
if (audio_is_playing(mus_atual)) {
    exit;
}

// evita repetir a mesma música
do {
    nova_musica = musicas[irandom(array_length(musicas) - 1)];
} until (nova_musica != mus_anterior);

// crossfade da música antiga
if (mus_atual != noone && audio_is_playing(mus_atual)) {
    audio_sound_gain(mus_atual, 0, 120);
}

// define nova música
mus_atual = nova_musica;
mus_anterior = nova_musica;

// toca sem loop
audio_play_sound(mus_atual, 1, false);

// fade in
audio_sound_gain(mus_atual, 0, 0);
audio_sound_gain(mus_atual, vol_musica, 3800);

// verifica quando acabar
alarm[1] = room_speed;
