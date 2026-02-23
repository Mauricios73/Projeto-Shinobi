/*/// obj_env - Create

// -------------------- CONFIG BÁSICA --------------------
time_speed = 1 / (60 * 240); 
// tempo de ciclo: 240s (4 min) em 60fps. Ajuste se quiser.
// Ex: 60 * 600 = 10 minutos.

t = 0.15; // 0..1 (começa de manhã)

camx = 0;
camy = 0;
camw = room_width;
camh = room_height;

clouds_offx = 0;
clouds_low_offx = 0;
stars_alpha = 0;
moon_alpha = 0;
moon_mode = 0;

// Camera: vamos ler do view/camera ativa
use_camera = true;

// Tamanho base para tile (se seus backgrounds são grandes, pode manter)
tile_w = 0; // 0 = usa sprite_width
tile_h = 0; // 0 = usa sprite_height

// -------------------- PALETAS DE LUZ (dia/noite) --------------------
// Quanto maior night_factor, mais escuro fica o mundo/ambiente.
night_factor = 0;

// Cores ambiente (você pode ajustar fino depois)
col_day   = make_color_rgb(255,255,255);
col_dusk  = make_color_rgb(200,180,255);
col_night = make_color_rgb(140,160,220);
col_deep  = make_color_rgb(110,120,190);

ambient_col = col_day;

// -------------------- ASSETS (substitua pelos nomes reais) --------------------
sprSkyDay      = spr_sky_day;
sprSkySunset   = spr_sky_sunset;
sprSkyDusk     = spr_sky_dusk;
sprSkyNight    = spr_sky_night;

sprStarsA      = spr_stars_sparse;
sprStarsB      = spr_stars_dense;

sprMoonWhite   = spr_moon_white;
sprMoonBlue    = spr_moon_blue;
sprMoonRed     = spr_moon_red;

// Exemplos de nuvens (coloque os seus)
sprCloudHighDay   = spr_clouds_high_day_1; // nuvens altas dia
sprCloudHighSun   = spr_clouds_high_sunset_1  // nuvens altas pôr do sol
sprCloudHighNight = spr_clouds_high_night_22;   // nuvens altas noite

sprCloudLowA      = spr_clouds_high_day_2;        // massa baixa/horizonte
sprCloudLowB      = spr_clouds_low_4;

// -------------------- PARALLAX LAYERS (data-driven) --------------------
// Cada layer é um struct com:
// sprite, depthTag, parallaxX, parallaxY, offsetX, offsetY, driftX, driftY, alphaMul, tintMode
//
// tintMode:
// 0 = sem tint
// 1 = tint por ambient_col (multiplicando alpha leve)

// Lista de camadas (ordem de desenho: do fundo pro frente)
layers = array_create(0);

// Função local para adicionar layer
function add_layer(_spr, _px, _py, _ox, _oy, _dx, _dy, _a, _tintMode) {
    var L = {
        spr: _spr,
        px: _px,
        py: _py,
        ox: _ox,
        oy: _oy,
        dx: _dx,
        dy: _dy,
        a: _a,
        tintMode: _tintMode
    };
    array_push(layers, L);
}

// --- Camadas base (você pode ajustar parallax depois)
add_layer(sprSkyDay,      0.02, 0.00, 0, 0,  0.00, 0.00, 1.00, 0); // Céu (troca por sistema)
add_layer(sprStarsA,      0.03, 0.00, 0, 0,  0.00, 0.00, 0.00, 0); // Estrelas (alpha controlado)
add_layer(sprMoonWhite,   0.05, 0.00, 0, 0,  0.00, 0.00, 0.00, 0); // Lua (alpha controlado)
add_layer(sprCloudHighDay,0.10, 0.00, 0, 0,  0.15, 0.00, 0.75, 0); // Nuvens altas (drift)
add_layer(sprCloudLowA,   0.20, 0.00, 0, 0,  0.05, 0.00, 0.90, 1); // Horizonte/massa baixa (tint leve)

// Se você quiser futuramente: florestas distantes/médias podem ser desenhadas por objetos/tiles.
// Aqui deixei só céu/nuvens/estrelas/lua/horizonte.
*/
/// obj_env - Create

// -------------------- CONFIG BÁSICA --------------------
time_speed = 1 / (60 * 240); // 4 min em 60fps
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