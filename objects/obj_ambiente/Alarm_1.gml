var snd = sons_crows[irandom(array_length(sons_crows) - 1)];
crow_voice = audio_play_sound(snd, 1, false);

var mult = 1.0;
if (variable_global_exists("ambient_mult")) mult = global.ambient_mult;

audio_sound_gain(crow_voice, 0, 0);
audio_sound_gain(crow_voice, vol_crows * mult, 80);

alarm[6] = room_speed * irandom_range(4, 7);
