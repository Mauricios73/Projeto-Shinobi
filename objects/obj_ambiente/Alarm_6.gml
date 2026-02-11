if (crow_id != -1 && audio_is_playing(crow_id)) {
    audio_sound_gain(crow_id, 0, fade_out_tempo);
} else {
    crow_id = -1;
}
// próximo
alarm[1] = room_speed * irandom_range(12, 25);
