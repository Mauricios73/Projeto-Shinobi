if (bird_id != -1 && audio_is_playing(bird_id)) {
    audio_sound_gain(bird_id, 0, fade_out_tempo);
} else {
    bird_id = -1;
}
// agenda próxima aparição
alarm[0] = room_speed * irandom_range(8, 15);