if (bird_voice != -1 && audio_is_playing(bird_voice)) {
    audio_sound_gain(bird_voice, 0, fade_out_ms);
}
bird_voice = -1;
alarm[0] = room_speed * irandom_range(8, 15);
