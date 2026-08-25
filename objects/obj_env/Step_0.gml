///// obj_env - Step

// ====================================================
// TIME SYSTEM
// 24h no jogo = 12 minutos reais.
// ====================================================
if (!variable_instance_exists(id, "moon_type_for_night")) moon_type_for_night = 0;
if (!variable_instance_exists(id, "moon_night_selected")) moon_night_selected = false;
if (!variable_instance_exists(id, "moon_was_red")) moon_was_red = false;
if (!variable_instance_exists(id, "moon_normal_nights")) moon_normal_nights = 0;
if (!variable_instance_exists(id, "time_day_seconds")) time_day_seconds = 12 * 60;
if (!variable_instance_exists(id, "time_scale")) time_scale = 1.0;
if (!variable_instance_exists(id, "time_paused")) time_paused = false;
if (!variable_instance_exists(id, "time_test_speed")) time_test_speed = 12.0;
if (!variable_instance_exists(id, "time_debug")) time_debug = true;
if (!variable_instance_exists(id, "time_debug_overlay")) time_debug_overlay = true;
if (!variable_instance_exists(id, "time_seconds")) time_seconds = 6 * 60 * 60;
if (!variable_instance_exists(id, "time_day")) time_day = 1;
if (!variable_instance_exists(id, "time_period")) time_period = "AMANHECER";
if (!variable_instance_exists(id, "time_prev_period")) time_prev_period = time_period;
if (!variable_instance_exists(id, "time_prev_hour")) time_prev_hour = floor(time_seconds / 3600);
if (!variable_instance_exists(id, "time_dawn_start")) time_dawn_start = 5.0;
if (!variable_instance_exists(id, "time_morning_start")) time_morning_start = 7.0;
if (!variable_instance_exists(id, "time_afternoon_start")) time_afternoon_start = 13.0;
if (!variable_instance_exists(id, "time_sunset_start")) time_sunset_start = 17.0;
if (!variable_instance_exists(id, "time_night_start")) time_night_start = 19.0;
if (!variable_instance_exists(id, "time_midnight")) time_midnight = 0.0;

if (!variable_instance_exists(id, "get_period_from_hours"))
{
    get_period_from_hours = function(_h)
    {
        if (_h >= 0 && _h < time_dawn_start) return "MADRUGADA";
        if (_h >= time_dawn_start && _h < time_morning_start) return "AMANHECER";
        if (_h >= time_morning_start && _h < time_afternoon_start) return "MANHÃ";
        if (_h >= time_afternoon_start && _h < time_sunset_start) return "TARDE";
        if (_h >= time_sunset_start && _h < time_night_start) return "PÔR DO SOL";
        return "NOITE";
    };
}

if (!variable_instance_exists(id, "select_moon_for_night"))
{
    select_moon_for_night = function()
    {
        moon_night_selected = true;
        moon_was_red = false;
        if (moon_normal_nights >= 10 && irandom(99) < 20)
        {
            moon_type_for_night = 2;
            moon_was_red = true;
        }
        else moon_type_for_night = (irandom(1) == 0) ? 0 : 1;
    };
}

time_delta = delta_time / 1000000;
if (time_delta < 0) time_delta = 0;
if (time_delta > 0.25) time_delta = 0.25;

if (time_debug)
{
    if (keyboard_check_pressed(vk_f1)) time_paused = !time_paused;
    if (keyboard_check_pressed(vk_f2)) time_seconds += 60 * 60;
    if (keyboard_check_pressed(vk_f3)) time_seconds -= 60 * 60;
    if (keyboard_check_pressed(vk_f4)) time_scale = (time_scale == 1) ? time_test_speed : 1;
    if (keyboard_check_pressed(vk_f5)) time_debug_overlay = !time_debug_overlay;
}

time_seconds = clamp(time_seconds, 0, 86399.999);
var environment_paused = time_paused;
if (variable_global_exists("pause") && global.pause) environment_paused = true;

if (!environment_paused)
{
    var game_seconds_per_real_second = 86400 / time_day_seconds;
    time_seconds += time_delta * game_seconds_per_real_second * time_scale;
}

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
else if (time_hour_now != time_prev_hour) time_event = "HOUR_CHANGED";
time_period = new_period;
time_prev_hour = time_hour_now;

// ====================================================
// LUA — uma escolha por noite.
// ====================================================
if (time_hours_now >= time_night_start && !moon_night_selected)
    select_moon_for_night();

if (time_hours_now >= time_dawn_start && time_hours_now < time_night_start)
    moon_night_selected = false;

moon_mode = moon_type_for_night;
if (!moon_night_selected) moon_mode = 0;

if (new_period == "MADRUGADA" && time_event == "PERIOD_CHANGED")
{
    if (moon_was_red) moon_normal_nights = 0;
    else moon_normal_nights += 1;
    global.environment.time.moon_event = moon_was_red ? "RED_MOON" : "NORMAL_MOON";
    moon_was_red = false;
}

global.environment.time.day = time_day;
global.environment.time.seconds = time_seconds;
global.environment.time.hours = time_hours_now;
global.environment.time.hour = time_hour_now;
global.environment.time.minutes = time_minute_now;
global.environment.time.seconds_display = time_second_now;
global.environment.time.period = time_period;
global.environment.time.scale = time_scale;
global.environment.time.paused = environment_paused;
global.environment.time.moon_type = moon_mode;
global.environment.time.moon_normal_nights = moon_normal_nights;
if (!variable_struct_exists(global.environment.time, "moon_event")) global.environment.time.moon_event = "";
if (time_event != "") global.environment.time.event = time_event;
else if (global.environment.time.event == "DAY_CHANGED" || global.environment.time.event == "INIT") global.environment.time.event = "";

// ====================================================
// VISUAL ENVIRONMENT — transicoes continuas.
// ====================================================
function smooth01(x) { x = clamp(x, 0, 1); return x * x * (3 - 2 * x); }
function lerp_color(c1, c2, a) { return merge_color(c1, c2, clamp(a, 0, 1)); }

var H_SUNSET = 17.0;
var H_DUSK = 18.5;
var H_NIGHT = 20.0;
var H_DAWN = 5.0;
var H_MORNING = 7.0;

if (time_hours_now >= H_NIGHT || time_hours_now < H_DAWN) night_factor = 1;
else if (time_hours_now >= H_DUSK) night_factor = smooth01((time_hours_now - H_DUSK) / (H_NIGHT - H_DUSK));
else if (time_hours_now >= H_DAWN && time_hours_now < H_MORNING) night_factor = 1 - smooth01((time_hours_now - H_DAWN) / (H_MORNING - H_DAWN));
else night_factor = 0;

if (time_hours_now < H_SUNSET && time_hours_now >= H_MORNING)
    ambient_col = col_day;
else if (time_hours_now >= H_SUNSET && time_hours_now < H_DUSK)
    ambient_col = lerp_color(col_day, col_dusk, smooth01((time_hours_now - H_SUNSET) / (H_DUSK - H_SUNSET)));
else if (time_hours_now >= H_DUSK && time_hours_now < H_NIGHT)
    ambient_col = lerp_color(col_dusk, col_night, smooth01((time_hours_now - H_DUSK) / (H_NIGHT - H_DUSK)));
else if (time_hours_now >= H_NIGHT || time_hours_now < H_DAWN)
    ambient_col = col_deep;
else
    ambient_col = lerp_color(col_deep, col_day, smooth01((time_hours_now - H_DAWN) / (H_MORNING - H_DAWN)));

var stars_in = smooth01((time_hours_now - 18.0) / 1.5);
var stars_out = 1 - smooth01((time_hours_now - 5.0) / 2.0);
if (time_hours_now < 5.0) stars_alpha = 1;
else if (time_hours_now < 7.0) stars_alpha = stars_out;
else if (time_hours_now >= 18.0) stars_alpha = stars_in;
else stars_alpha = 0;
stars_alpha = clamp(stars_alpha, 0, 1);
moon_alpha = stars_alpha;

global.environment.time.night_factor = night_factor;
global.environment.time.ambient_col = ambient_col;
