persistent = true;
vento_ativo = false;

// ======================
// CONFIGURAÇÃO DO VENTO
// ======================
fade_in_tempo  = 4000;
fade_out_tempo = 4000;

vento_min = 10;
vento_max = 60;

// ======================
// VOLUMES
// ======================
vol_birds = 0.15;
vol_crows = 0.15;
vol_vento = 0.22;

// ======================
// ARRAYS DE SONS
// ======================
sons_birds = [snd_bird, snd_bird1, snd_bird2];
sons_crows = [snd_crow, snd_raven];
sons_vento = [snd_wind_1, snd_wind_2, snd_wind_3];

// ======================
// IDS DE SOM
// ======================
bird_id  = noone;
crow_id  = noone;
vento_id = noone;

// ======================
// AGENDA INICIAL
// ======================
alarm[0] = room_speed * irandom_range(6, 12); // birds
alarm[1] = room_speed * irandom_range(10, 20); // crows
alarm[2] = room_speed * irandom_range(8, 15); // wind

