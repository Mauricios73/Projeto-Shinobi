/// obj_env - Create

// -------------------- TIME SYSTEM --------------------
// Um dia completo no jogo dura 12 minutos reais.
time_day_seconds = 12 * 60;
time_game_hours = 24;
time_scale = 1.0;
time_paused = false;
time_debug = true;
time_debug_overlay = true;
time_debug_step_hours = 1;

// Estado inicial: 06:00 (amanhecer).
time_seconds = 6 * 60 * 60;
time_day = 1;
time_period = "AMANHECER";
time_prev_period = time_period;
time_prev_hour = 6;
time_delta = 0;

// Períodos do dia. Os limites são em horas do relógio do jogo.
time_dawn_start = 5.0;
time_morning_start = 7.0;
time_afternoon_start = 13.0;
time_sunset_start = 17.0;
time_night_start = 19.0;
time_midnight = 0.0;
time_dawn_end = 7.0;

// API simples para outros sistemas consultarem o ambiente.
get_time_hours = function() { return time_seconds / 3600; };
get_time_minutes = function() { return (time_seconds / 60) mod 60; };
get_time_seconds = function() { return time_seconds mod 60; };
get_time_day = function() { return time_day; };
get_time_period = function() { return time_period; };

get_time_period_name = function(_p)
{
    switch (_p)
    {
        case "MADRUGADA": return "Madrugada";
        case "AMANHECER": return "Amanhecer";
        case "MANHÃ": return "Manhã";
        case "TARDE": return "Tarde";
        case "PÔR DO SOL": return "Pôr do sol";
        case "NOITE": return "Noite";
    }
    return string(_p);
};

get_period_from_hours = function(_h)
{
    if (_h >= 0 && _h < time_dawn_start) return "MADRUGADA";
    if (_h >= time_dawn_start && _h < time_morning_start) return "AMANHECER";
    if (_h >= time_morning_start && _h < time_afternoon_start) return "MANHÃ";
    if (_h >= time_afternoon_start && _h < time_sunset_start) return "TARDE";
    if (_h >= time_sunset_start && _h < time_night_start) return "PÔR DO SOL";
    return "NOITE";
};

// -------------------- LUA / EVENTOS NOTURNOS --------------------
// A lua é sorteada uma vez por noite e não troca de cor durante o percurso.
// Normal: branca ou azul, 50/50.
// Após 10 noites normais, a próxima noite tem 20% de chance de lua vermelha.
moon_normal_nights = 0;
moon_type_for_night = 0; // 0 branca, 1 azul, 2 vermelha
moon_night_selected = false;
moon_was_red = false;

select_moon_for_night = function()
{
    moon_night_selected = true;
    moon_was_red = false;

    if (moon_normal_nights >= 10 && irandom(99) < 20)
    {
        moon_type_for_night = 2;
        moon_was_red = true;
    }
    else
    {
        moon_type_for_night = (irandom(1) == 0) ? 0 : 1;
    }
};

// -------------------- EVENTOS GLOBAIS --------------------
if (!variable_global_exists("environment")) global.environment = {};
global.environment.time = {};
global.environment.time.day = time_day;
global.environment.time.seconds = time_seconds;
global.environment.time.hours = 6;
global.environment.time.minutes = 0;
global.environment.time.period = time_period;
global.environment.time.scale = time_scale;
global.environment.time.paused = time_paused;
global.environment.time.event = "INIT";
global.environment.time.moon_type = moon_type_for_night;
global.environment.time.moon_normal_nights = moon_normal_nights;

// -------------------- CONFIGURAÇÕES DE TESTE --------------------
time_test_speed = 12.0;

// -------------------- CONFIGURAÇÃO DA LUA --------------------
moon_scale = 0.45;

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

col_day = make_color_rgb(255,255,255);
col_dusk = make_color_rgb(200,180,255);
col_night = make_color_rgb(140,160,220);
col_deep = make_color_rgb(110,120,190);
ambient_col = col_day;

// -------------------- ASSETS --------------------
sprSkyDay = spr_sky_day;
sprSkySunset = spr_sky_sunset;
sprSkyDusk = spr_sky_dusk;
sprSkyNight = spr_sky_night;
sprStarsA = spr_stars_sparse;
sprStarsB = spr_stars_dense;
sprMoonWhite = spr_moon_white;
sprMoonBlue = spr_moon_blue;
sprMoonRed = spr_moon_red;
sprCloudHighDay = spr_clouds_high_day_1;
sprCloudHighSun = spr_clouds_high_sunset_1;
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