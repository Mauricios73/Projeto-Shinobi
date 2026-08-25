// obj_weather_manager - Step

var rn = room_get_name(room);
var is_menu = false;
for (var i = 0; i < array_length(menu_rooms); i++) if (rn == menu_rooms[i]) { is_menu = true; break; }
var dt = 1 / room_speed;

if (debug_keys)
{
    if (keyboard_check_pressed(vk_f6)) { fog_on = !fog_on; fog_left = 15; alarm[0] = 1; }
    if (keyboard_check_pressed(vk_f7)) { weather_set_target(WEATHER_RAIN, "DEBUG_RAIN"); weather_auto = false; }
    if (keyboard_check_pressed(vk_f8)) { weather_set_target(WEATHER_RAIN, "DEBUG_LIGHT_RAIN"); weather_auto = false; }
    if (keyboard_check_pressed(vk_f9)) { weather_set_target(WEATHER_SNOW, "DEBUG_SNOW"); weather_auto = false; }
    if (keyboard_check_pressed(vk_f10)) { weather_set_target(WEATHER_CLEAR, "DEBUG_CLEAR"); weather_auto = false; }
    if (keyboard_check_pressed(vk_f11))
    {
        weather_auto = !weather_auto;
        if (weather_auto) weather_event = "AUTO_ON";
        else weather_event = "AUTO_OFF";
    }
    if (keyboard_check_pressed(vk_f12))
    {
        weather_auto = false;
        var next_debug = WEATHER_CLEAR;
        if (weather_current == WEATHER_CLEAR) next_debug = WEATHER_CLOUDY;
        else if (weather_current == WEATHER_CLOUDY) next_debug = WEATHER_RAIN;
        else if (weather_current == WEATHER_RAIN) next_debug = WEATHER_STORM;
        else next_debug = WEATHER_CLEAR;
        weather_set_target(next_debug, "DEBUG_NEXT");
    }
}

// Menu
if (is_menu)
{
    weather_set_target(WEATHER_CLEAR, "MENU");
    weather_auto = false;
    precip_mode = 0;
    fog_on = false;
    global.precip_mode = 0;
    if (instance_exists(obj_chuva)) with (obj_chuva) instance_destroy();
    if (instance_exists(obj_neve)) with (obj_neve) instance_destroy();
    if (h_forest != -1) audio_sound_gain(h_forest, 0, rain_fade_ms);
    if (h_heavy != -1) audio_sound_gain(h_heavy, 0, rain_fade_ms);
    alarm[0] = 1;
    exit;
}

// Weather transition
if (weather_auto)
{
    weather_next_change -= dt;
    if (weather_next_change <= 0 && !weather_transitioning) weather_pick_next();
}

if (weather_transitioning)
{
    weather_intensity = lerp(weather_intensity, weather_target_intensity, clamp(weather_transition_speed * dt, 0, 1));
    if (abs(weather_intensity - weather_target_intensity) < 0.01)
    {
        weather_intensity = weather_target_intensity;
        weather_current = weather_target;
        weather_transitioning = false;
        weather_state_time = 0;
        weather_event = "STATE_CHANGED";
        weather_next_change = irandom_range(weather_min_duration, weather_max_duration);
    }
}
else
{
    weather_intensity = weather_target_intensity;
    weather_state_time += dt;
}

// Conversao: 0 nada | 1 neve | 2 chuva forte | 3 chuva fraca
if (weather_current == WEATHER_SNOW) precip_mode = 1;
else if (weather_current == WEATHER_STORM) precip_mode = 2;
else if (weather_current == WEATHER_RAIN) precip_mode = 3;
else precip_mode = 0;

if (weather_transitioning)
{
    if (weather_target == WEATHER_STORM)
    {
        if (weather_intensity > 0.40) precip_mode = 2;
        else precip_mode = 3;
    }
    else if (weather_target == WEATHER_RAIN) precip_mode = 3;
    else if (weather_current == WEATHER_STORM || weather_current == WEATHER_RAIN)
    {
        if (weather_intensity > 0.78) precip_mode = 2;
        else precip_mode = 3;
    }
    else if (weather_target == WEATHER_SNOW) precip_mode = 1;
}

// Room atual
var is_indoor = false;
for (var j = 0; j < array_length(indoor_rooms); j++) if (rn == indoor_rooms[j]) { is_indoor = true; break; }
var outdoor = !is_menu && !is_indoor;

// Mantem o clima global mesmo dentro da casa.
global.precip_mode = precip_mode;
global.environment.weather = {
    current: weather_current,
    target: weather_target,
    intensity: weather_intensity,
    transitioning: weather_transitioning,
    event: weather_event,
    name: weather_state_name(weather_current),
    target_name: weather_state_name(weather_target),
    auto: weather_auto,
    indoor: is_indoor
};

// ====================================================
// CHUVA VISUAL - FONTE UNICA DE VERDADE
// O Alarm_0 nao decide mais quando criar/destruir a chuva.
// A cada Step, a room atual e o clima determinam a instancia.
// ====================================================
var rain_visual = (precip_mode == 2 || precip_mode == 3);

if (outdoor && rain_visual)
{
    if (!instance_exists(obj_chuva))
        instance_create_depth(0, 0, 0, obj_chuva);
    else
        obj_chuva.depth = 0;
}
else
{
    if (instance_exists(obj_chuva)) with (obj_chuva) instance_destroy();
}

// Neve segue a mesma regra.
if (outdoor && precip_mode == 1)
{
    if (!instance_exists(obj_neve))
        instance_create_depth(0, 0, 0, obj_neve);
    else
        obj_neve.depth = 0;
}
else
{
    if (instance_exists(obj_neve)) with (obj_neve) instance_destroy();
}

// Fog
if (fog_left > 0) fog_left -= dt;
if (fog_left <= 0 && !weather_transitioning)
{
    fog_on = (weather_current == WEATHER_CLOUDY || weather_current == WEATHER_STORM) && irandom(99) < 35;
    fog_left = irandom_range(fog_min, fog_max);
    alarm[0] = 1;
}

// Neve
if (!variable_global_exists("snow_amount")) global.snow_amount = 0;
if (weather_current == WEATHER_SNOW) global.snow_amount = clamp(global.snow_amount + snow_accum_speed * dt, 0, 1);
else global.snow_amount = clamp(global.snow_amount - snow_melt_speed * dt, 0, 1);

// Audio da chuva
rain_wobble_t -= dt;
if (rain_wobble_t <= 0)
{
    rain_wobble_t = random_range(0.7, 1.4);
    rain_wobble_goal = random_range(0.92, 1.08);
}
rain_wobble = lerp(rain_wobble, rain_wobble_goal, 0.02);

var rain_active = (precip_mode == 2 || precip_mode == 3);
var target_forest = 0;
var target_heavy = 0;
if (rain_active)
{
    target_forest = lerp(0, 0.65, clamp(weather_intensity, 0, 1));
    target_heavy = lerp(0, 0.45, clamp((weather_intensity - 0.45) / 0.55, 0, 1));
}
target_forest *= rain_wobble;
target_heavy *= rain_wobble;

if (target_forest > 0 && outdoor)
{
    h_forest = ensure_loop(h_forest, snd_forest);
    audio_sound_gain(h_forest, clamp(target_forest, 0, 1), rain_fade_ms);
}
else if (h_forest != -1) audio_sound_gain(h_forest, 0, rain_fade_ms);

if (target_heavy > 0 && outdoor)
{
    h_heavy = ensure_loop(h_heavy, snd_heavy);
    audio_sound_gain(h_heavy, clamp(target_heavy, 0, 1), rain_fade_ms);
}
else if (h_heavy != -1) audio_sound_gain(h_heavy, 0, rain_fade_ms);

if (!rain_active || !outdoor)
{
    if (!rain_stop_armed && (h_forest != -1 || h_heavy != -1))
    {
        rain_stop_armed = true;
        alarm[1] = ceil((rain_fade_ms / 1000) * room_speed) + 1;
    }
}
else rain_stop_armed = false;
