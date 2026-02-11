var snd = sons_birds[irandom(array_length(sons_birds) - 1)];
bird_id = audio_play_sound(snd, 0, false);

// fade in REAL
audio_sound_gain(bird_id, 0, 0);
audio_sound_gain(bird_id, vol_birds, 60);

// duração do som
alarm[5] = room_speed * irandom_range(3, 6);

