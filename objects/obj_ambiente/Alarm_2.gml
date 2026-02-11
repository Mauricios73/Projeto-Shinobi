if (vento_ativo) exit;

var snd = sons_vento[irandom(array_length(sons_vento) - 1)];

vento_id = audio_play_sound(snd, 0, true);
vento_ativo = true;

// começa totalmente mudo
audio_sound_gain(vento_id, 0, 0);

// fade in longo
audio_sound_gain(vento_id, vol_vento, fade_in_tempo);

// tempo total do vento cheio
var duracao = irandom_range(vento_min, vento_max);

// agenda fade out
alarm[3] = room_speed * duracao;
