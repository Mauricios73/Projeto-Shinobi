var snd = sons_crows[irandom(array_length(sons_crows) - 1)];
crow_id = audio_play_sound(snd, 0, false);

// fade in
audio_sound_gain(crow_id, 0, 0);
audio_sound_gain(crow_id, vol_crows, 80);

// duração
alarm[6] = room_speed * irandom_range(4, 7);
