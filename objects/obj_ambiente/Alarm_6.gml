if (crow_voice != -1 && audio_is_playing(crow_voice)) {
    audio_sound_gain(crow_voice, 0, fade_out_ms);
}
crow_voice = -1;
alarm[1] = room_speed * irandom_range(12, 25);
