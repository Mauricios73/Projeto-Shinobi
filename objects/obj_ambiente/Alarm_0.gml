var snd = sons_birds[irandom(array_length(sons_birds) - 1)];
bird_voice = audio_play_sound(snd, 1, false);

var mult = 1.0;
if (variable_global_exists("ambient_mult")) mult = global.ambient_mult;

// fade in
audio_sound_gain(bird_voice, 0, 0);
audio_sound_gain(bird_voice, vol_birds * mult, 60);

// duration before fade out
alarm[5] = room_speed * irandom_range(3, 6);
