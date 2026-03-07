if (vento_voice != -1) {
    audio_sound_gain(vento_voice, 0, fade_out_ms);
}
alarm[4] = ceil(fade_out_ms / 1000 * room_speed);
