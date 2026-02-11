if (vento_id != noone) {
    audio_sound_gain(vento_id, 0, fade_out_tempo);
}

// espera o fade acabar
alarm[4] = ceil(fade_out_tempo / 1000 * room_speed);
	