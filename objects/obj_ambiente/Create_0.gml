persistent = true;

// Avoid duplicates
if (instance_number(obj_ambiente) > 1) { instance_destroy(); exit; }

vento_ativo = false;

// CONFIG
fade_in_ms  = 4000;
fade_out_ms = 4000;

vento_min_s = 10;
vento_max_s = 60;

// base volumes (before group gain)
vol_birds = 0.15;
vol_crows = 0.15;
vol_vento = 0.22;

// sound pools (direct refs => compiler marks them used)
sons_birds = [snd_bird, snd_bird1, snd_bird2];
sons_crows = [snd_crow, snd_raven];
sons_vento = [snd_wind_1, snd_wind_2, snd_wind_3];

// voice handles (-1 = none)
bird_voice  = -1;
crow_voice  = -1;
vento_voice = -1;

// initial schedule
alarm[0] = room_speed * irandom_range(6, 12);  // birds
alarm[1] = room_speed * irandom_range(10, 20); // crows
alarm[2] = room_speed * irandom_range(8, 15);  // wind
