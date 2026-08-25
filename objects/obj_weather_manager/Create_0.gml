// obj_weather_manager - Create

if (instance_exists(obj_fog)) show_debug_message("FOG DEPTH=" + string(obj_fog.depth));
if (instance_number(obj_weather_manager) > 1) { instance_destroy(); exit; }
persistent = true;

menu_rooms = ["rm_init", "rm_menu"];
indoor_rooms = ["Room2"];
fog_in_indoor = true;

// ====================================================
// WEATHER SYSTEM
// CLEAR -> CLOUDY -> RAIN -> STORM
// A transicao usa current/target + intensidade contínua.
// ====================================================
WEATHER_CLEAR = 0;
WEATHER_CLOUDY = 1;
WEATHER_RAIN = 2;
WEATHER_STORM = 3;
WEATHER_SNOW = 4; // legado/especial, fora do ciclo principal

weather_current = WEATHER_CLEAR;
weather_target = WEATHER_CLEAR;
weather_intensity = 0.0;
weather_target_intensity = 0.0;
weather_transition_speed = 0.35;
weather_state_time = 90;
weather_transitioning = false;
weather_auto = true;
weather_event = "INIT";

// duracoes automaticas do clima
weather_min_duration = 45;
weather_max_duration = 120;
weather_next_change = irandom_range(weather_min_duration, weather_max_duration);

// ===== compatibilidade com sistema antigo =====
precip_min = 30;
precip_max = 60;
fog_min = 200;
fog_max = 300;
snow_accum_speed = 0.015;
snow_melt_speed = 0.005;
chance_none = 85;
chance_snow = 5;
chance_rain_light = 5;
chance_rain_heavy = 5;

precip_mode = 0;
fog_on = false;
precip_left = 0;
fog_left = 0;
global.precip_mode = 0;

// ===== DEBUG =====
debug_keys = true;
debug_popup = false;
_last_precip = -1;
_last_fog = -1;

// ===== SOM CHUVA =====
rain_fade_ms = 500;
snd_forest = snd_rain_forest;
snd_heavy = snd_rain;
h_forest = -1;
h_heavy = -1;
rain_wobble = 1.0;
rain_wobble_t = 0;
rain_wobble_goal = 1.0;
rain_stop_armed = false;
_volume = 0;

ensure_loop = function(_h, _snd)
{
    if (_h == -1 || !audio_is_playing(_h))
    {
        _h = audio_play_sound(_snd, 0, true);
        audio_sound_gain(_h, 0, 0);
    }
    return _h;
};

weather_state_name = function(_state)
{
    switch (_state)
    {
        case WEATHER_CLEAR: return "LIMPO";
        case WEATHER_CLOUDY: return "NUBLADO";
        case WEATHER_RAIN: return "CHUVA";
        case WEATHER_STORM: return "TEMPESTADE";
        case WEATHER_SNOW: return "NEVE";
    }
    return "?";
};

weather_intensity_for = function(_state)
{
    switch (_state)
    {
        case WEATHER_CLEAR: return 0.0;
        case WEATHER_CLOUDY: return 0.25;
        case WEATHER_RAIN: return 0.65;
        case WEATHER_STORM: return 1.0;
        case WEATHER_SNOW: return 0.65;
    }
    return 0.0;
};

weather_set_target = function(_state, _reason)
{
    _state = clamp(_state, WEATHER_CLEAR, WEATHER_SNOW);
    weather_target = _state;
    weather_target_intensity = weather_intensity_for(_state);
    weather_transitioning = (weather_current != weather_target || abs(weather_intensity - weather_target_intensity) > 0.01);
    weather_event = _reason;
    weather_next_change = irandom_range(weather_min_duration, weather_max_duration);
};

weather_pick_next = function()
{
    // Clima muda gradualmente apenas entre estados vizinhos.
    switch (weather_current)
    {
        case WEATHER_CLEAR:
            weather_set_target(irandom(1) == 0 ? WEATHER_CLEAR : WEATHER_CLOUDY, "AUTO_CHANGE");
        break;
        case WEATHER_CLOUDY:
            var r = irandom(99);
            if (r < 45) weather_set_target(WEATHER_CLEAR, "AUTO_CHANGE");
            else if (r < 80) weather_set_target(WEATHER_RAIN, "AUTO_CHANGE");
            else weather_set_target(WEATHER_CLOUDY, "AUTO_CHANGE");
        break;
        case WEATHER_RAIN:
            var r2 = irandom(99);
            if (r2 < 35) weather_set_target(WEATHER_CLOUDY, "AUTO_CHANGE");
            else if (r2 < 70) weather_set_target(WEATHER_RAIN, "AUTO_CHANGE");
            else weather_set_target(WEATHER_STORM, "AUTO_CHANGE");
        break;
        case WEATHER_STORM:
            weather_set_target(irandom(99) < 70 ? WEATHER_RAIN : WEATHER_CLOUDY, "AUTO_CHANGE");
        break;
        default:
            weather_set_target(WEATHER_CLEAR, "AUTO_RESET");
        break;
    }
};
