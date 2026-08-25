///// obj_env - Step

// ====================================================
// TIME SYSTEM
// 24h no jogo = 12 minutos reais.
// ====================================================
time_delta = delta_time / 1000000;
if (time_delta < 0) time_delta = 0;
if (time_delta > 0.25) time_delta = 0.25;

// Debug do Time System: F1 pausa, F2/F3 avançam uma hora,
// F4 alterna x1/x12, F5 mostra/oculta overlay.
if (time_debug)
{
    if (keyboard_check_pressed(vk_f1)) time_paused = !time_paused;
    if (keyboard_check_pressed(vk_f2)) time_seconds += 60 * 60;
    if (keyboard_check_pressed(vk_f3)) time_seconds -= 60 * 60;
    if (keyboard_check_pressed(vk_f4)) time_scale = (time_scale == 1) ? time_test_speed : 1;
    if (keyboard_check_pressed(vk_f5)) time_debug_overlay = !time_debug_overlay;

    time_seconds = clamp(time_seconds, 0, 86399.999);
}

// O pause geral do jogo também pausa o relógio ambiental.
var environment_paused = time_paused;
if (variable_global_exists("pause") && global.pause) environment_paused = true;

if (!environment_paused)
{
    // 12 minutos reais -> 24 horas no jogo = 120 segundos de jogo por segundo real.
    var game_seconds_per_real_second = (24 * 60 * 60) / time_day_seconds;
    time_seconds += time_delta * game_seconds_per_real_second * time_scale;
}

// Virada de dia.
while (time_seconds >= 86400)
{
    time_seconds -= 86400;
    time_day += 1;
    global.environment.time.event = "DAY_CHANGED";
}
while (time_seconds < 0)
{
    time_seconds += 86400;
    time_day = max(1, time_day - 1);
}

var time_hours_now = time_seconds / 3600;
var time_hour_now = floor(time_seconds / 3600);
var time_minute_now = floor((time_seconds mod 3600) / 60);
var time_second_now = floor(time_seconds mod 60);
var new_period = get_period_from_hours(time_hours_now);
var time_event = "";

if (new_period != time_prev_period)
{
    time_event = "PERIOD_CHANGED";
    time_prev_period = new_period;
}
else if (time_hour_now != time_prev_hour)
{
    time_event = "HOUR_CHANGED";
}

time_period = new_period;
time_prev_hour = time_hour_now;

// Estado público do Environment System.
global.environment.time.day = time_day;
global.environment.time.seconds = time_seconds;
global.environment.time.hours = time_hours_now;
global.environment.time.hour = time_hour_now;
global.environment.time.minutes = time_minute_now;
global.environment.time.seconds_display = time_second_now;
global.environment.time.period = time_period;
global.environment.time.scale = time_scale;
global.environment.time.paused = environment_paused;
if (time_event != "") global.environment.time.event = time_event;
else if (global.environment.time.event == "DAY_CHANGED") global.environment.time.event = "";
else if (global.environment.time.event == "INIT") global.environment.time.event = "";

// ====================================================
// VISUAL ENVIRONMENT — usa o mesmo relógio.
// ====================================================
function smooth01(x) { x = clamp(x,0,1); return x*x*(3 - 2*x); }
function lerp_color(c1,c2,a) { return merge_color(c1,c2, clamp(a,0,1)); }

// Pontos do ciclo convertidos para horas reais do jogo.
var H_SUNSET = 17.0;
var H_DUSK   = 18.5;
var H_NIGHT  = 20.0;
var H_DAWN   = 5.0;
var H_MORNING = 7.0;

// 1) night_factor com transições contínuas.
var night_rise = 1 - smooth01((time_hours_now - H_DUSK) / (H_NIGHT - H_DUSK));
var night_fall = smooth01((time_hours_now - H_DAWN) / (H_MORNING - H_DAWN));

if (time_hours_now >= H_NIGHT || time_hours_now < H_DAWN)
{
    if (time_hours_now < H_DAWN) night_factor = 1 - night_fall;
    else night_factor = 1;
}
else if (time_hours_now >= H_DUSK)
{
    night_factor = smooth01((time_hours_now - H_DUSK) / (H_NIGHT - H_DUSK));
}
else
{
    night_factor = 0;
}

// 2) Cor ambiental.
if (time_hours_now < H_SUNSET && time_hours_now >= H_MORNING)
{
    ambient_col = col_day;
}
else if (time_hours_now >= H_SUNSET && time_hours_now < H_DUSK)
{
    var sunset_a = smooth01((time_hours_now - H_SUNSET) / (H_DUSK - H_SUNSET));
    ambient_col = lerp_color(col_day, col_dusk, sunset_a);
}
else if (time_hours_now >= H_DUSK && time_hours_now < H_NIGHT)
{
    var dusk_a = smooth01((time_hours_now - H_DUSK) / (H_NIGHT - H_DUSK));
    ambient_col = lerp_color(col_dusk, col_night, dusk_a);
}
else if (time_hours_now >= H_NIGHT || time_hours_now < H_DAWN)
{
    ambient_col = col_deep;
}
else
{
    var dawn_a = smooth01((time_hours_now - H_DAWN) / (H_MORNING - H_DAWN));
    ambient_col = lerp_color(col_deep, col_day, dawn_a);
}

// 3) Estrelas e lua.
var stars_in = smooth01((time_hours_now - 18.0) / 1.5);
var stars_out = 1 - smooth01((time_hours_now - 5.0) / 2.0);
if (time_hours_now < 5.0) stars_alpha = 1;
else if (time_hours_now < 6.5) stars_alpha = stars_out;
else if (time_hours_now >= 18.0) stars_alpha = stars_in;
else stars_alpha = 0;

stars_alpha = clamp(stars_alpha, 0, 1);
moon_alpha = stars_alpha;
moon_mode = 0;
if (time_hours_now >= 0.0 && time_hours_now < 4.0) moon_mode = 1;
if (time_hours_now >= 23.0 || time_hours_now < 1.0) moon_mode = 2;

// Atualiza posição de referência para os sistemas futuros.
global.environment.time.night_factor = night_factor;
global.environment.time.ambient_col = ambient_col;
