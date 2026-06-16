/// obj_env - Create

// -------------------- CONFIG BÁSICA & TESTES --------------------
is_testing = false; // TRUE: Tempo voa para testes | FALSE: Tempo realista de jogo

// Definição das velocidades (Ciclo completo = 24 horas no jogo)
time_speed_normal = 1 / (60 * 60 * 15); // Lento: Um ciclo dura cerca de 15 minutos reais
time_speed_test   = 4 / (60 * 120);     // Rápido: O tempo voa para testar transições

time_speed = is_testing ? time_speed_test : time_speed_normal;
t = 0.15; // 0..1 (começa de manhã)

// ---- CONFIGURAÇÃO DA LUA ----
moon_scale = 0.45; // Reduz o tamanho da lua (0.5 = metade do tamanho original, altere como quiser)

// Camera vars (instância, para o Draw enxergar)
camx = 0;
camy = 0;
camw = room_width;
camh = room_height;

use_camera = true;

// Offsets de movimento
clouds_offx = 0;
clouds_low_offx = 0;

// Alpha controlado pelo Step
stars_alpha = 0;
moon_alpha = 0;
moon_mode = 0;

// -------------------- PALETAS DE LUZ (dia/noite) --------------------
night_factor = 0;

col_day   = make_color_rgb(255,255,255);
col_dusk  = make_color_rgb(200,180,255);
col_night = make_color_rgb(140,160,220);
col_deep  = make_color_rgb(110,120,190);

ambient_col = col_day;

// -------------------- ASSETS --------------------
sprSkyDay    = spr_sky_day;
sprSkySunset = spr_sky_sunset;
sprSkyDusk   = spr_sky_dusk;
sprSkyNight  = spr_sky_night;

sprStarsA = spr_stars_sparse;
sprStarsB = spr_stars_dense;

sprMoonWhite = spr_moon_white;
sprMoonBlue  = spr_moon_blue;
sprMoonRed   = spr_moon_red;

sprCloudHighDay   = spr_clouds_high_day_1;
sprCloudHighSun   = spr_clouds_high_sunset_1;

sprCloudLowB = spr_clouds_high_day_2;

// -------------------- CONFIG VISUAL (AJUSTÁVEL) --------------------
ground_cut_ratio = 0.52; 
clouds_high_ratio = 0.08; 
horizon_offset_px = 120;  

sprLandscapeFar = spr_landscape_far2; 
land_far_px = 0.02;  
land_far_alpha = 0.85;  
land_far_y_ratio = 0.22;  

far_haze_alpha = 0.20;  
far_haze_height_ratio = 0.55;  

sprLandscapeFar2 = spr_landscape_far2; 
land2_px = 0.01;  
land2_alpha = 0.70;  
land2_y_ratio = 0.20;  
land2_tint = true;  
land2_offx = 0;