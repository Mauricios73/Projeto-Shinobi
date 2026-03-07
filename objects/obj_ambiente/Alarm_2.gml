if (vento_ativo) exit;

var snd = sons_vento[irandom(array_length(sons_vento) - 1)];
vento_voice = audio_play_sound(snd, 1, true);
vento_ativo = true;

var mult = 1.0;
if (variable_global_exists("ambient_mult")) mult = global.ambient_mult;

audio_sound_gain(vento_voice, 0, 0);
audio_sound_gain(vento_voice, vol_vento * mult, fade_in_ms);

// schedule fade out
var duracao = irandom_range(vento_min_s, vento_max_s);
alarm[3] = room_speed * duracao;
