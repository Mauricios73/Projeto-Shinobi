/// obj_env - Create

// -------------------- CONFIG BÁSICA --------------------
time_speed = 2 / (60 * 240); // 4 min em 60fps
t = 0.15; // 0..1 (começa de manhã)

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

// Nuvens (corrigi ; faltando)
sprCloudHighDay   = spr_clouds_high_day_1;      // dia
sprCloudHighSun   = spr_clouds_high_sunset_1;   // pôr do sol
sprCloudHighNight = spr_clouds_high_night_22;   // noite

// OBS: aqui você tinha "low" apontando para "high". Se for isso mesmo, ok.
// Se você tiver um sprite real de nuvem baixa/horizonte, use ele aqui:
sprCloudLowA = spr_clouds_low_4;    // horizonte / nuvem baixa principal
sprCloudLowB = spr_clouds_high_day_2; // opcional (segunda variação)

// -------------------- CONFIG VISUAL (AJUSTÁVEL) --------------------
// Linha do chão/água na TELA (percentual da câmera)
// Use isso para manter o horizonte acima
ground_cut_ratio = 0.52; // 0.50~0.60

// Alturas na tela (percentuais)
clouds_high_ratio = 0.08; // nuvem alta (mais perto do topo)
horizon_offset_px = 120;  // quanto acima do chão a faixa do horizonte fica

// Fundo distante (Kingdom-like)
sprLandscapeFar = spr_landscape_far; // <- crie esse sprite
land_far_px = 0.02;                  // parallax bem baixo (quase parado)
land_far_alpha = 0.85;               // visível mas distante
land_far_y_ratio = 0.22;             // altura na tela (horizonte)

// Haze (neblina) distante
far_haze_alpha = 0.20;               // força da névoa
far_haze_height_ratio = 0.55;        // até onde a névoa desce na tela

// ---- Landscape 2 (mais distante, pode repetir) ----
sprLandscapeFar2 = spr_landscape_far2; // importe e defina esse sprite
land2_px = 0.01;                       // mais distante (menos parallax)
land2_alpha = 0.70;                    // mais fraca
land2_y_ratio = 0.20;                  // mais alta na tela
land2_tint = true;                     // usa ambient_col (opcional)
land2_offx = 0;                        // se quiser micro drift, senão fica 0
