// obj_weather_manager - Create

if (instance_exists(obj_fog)) show_debug_message("FOG DEPTH=" + string(obj_fog.depth));
if (instance_number(obj_weather_manager) > 1) { instance_destroy(); exit; }
persistent = true;

menu_rooms = ["rm_init", "rm_menu"];
indoor_rooms = ["Room2"];
fog_in_indoor = true;

WEATHER_CLEAR = 0;
WEATHER_CLOUDY = 1;
WEATHER_RAIN = 2;
WEATHER_STORM = 3;
WEATHER_SNOW = 4;

weather_current = WEATHER_CLEAR;
weather_target = WEATHER_CLEAR;
weather_intensity = 0.0;
weather_target_intensity = 0.0;
weather_transition_speed = 0.35;
weather_state_time = 90;
weather_transitioning = false;
weather_auto = true;
weather_event = "INIT";
weather_min_duration = 45;
weather_max_duration = 120;
weather_next_change = irandom_range(weather_min_duration, weather_max_duration);

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

_last_precip = -1;
_last_fog = -1;

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

// ====================================================
// AUDIO DIRECTOR
// Eventos pontuais usam os novos assets adicionados ao projeto.
// O loop da chuva continua separado para preservar o sistema atual.
// ====================================================
audio_env_enabled = true;
audio_env_timer = random_range(3, 8);
audio_env_min = 4;
audio_env_max = 11;
audio_env_last = "-";
audio_env_event_count = 0;
audio_env_last_handle = -1;

audio_pool_insects = [snd_cicada, snd_cricket_1, snd_cricket_2];
audio_pool_frogs = [snd_frog];
audio_pool_thunder = [snd_thunder_dark01, snd_thunder_dark02, snd_thunder_loud_dark_01];

audio_env_pick = function(_pool)
{
    return _pool[irandom(array_length(_pool) - 1)];
};

audio_env_play = function(_snd, _volume)
{
    if (!audio_env_enabled || _snd == -1) return false;
    audio_env_last_handle = audio_play_sound(_snd, 5, false);
    audio_sound_gain(audio_env_last_handle, clamp(_volume, 0, 1), 0);
    audio_env_event_count += 1;
    return true;
};

audio_env_trigger_event = function()
{
    if (!audio_env_enabled) return false;

    var _outdoor = true;
    if (variable_global_exists("environment") && variable_struct_exists(global.environment, "weather"))
        _outdoor = !global.environment.weather.indoor;
    if (!_outdoor) return false;

    var _hour = 12;
    var _period = "MANHÃ";
    if (instance_exists(obj_env))
    {
        _hour = obj_env.time_seconds / 3600;
        _period = obj_env.time_period;
    }

    var _roll = irandom(99);
    var _weather = weather_current;

    // Tempestade: trovão é o evento prioritário.
    if (_weather == WEATHER_STORM && _roll < 42)
    {
        audio_env_play(audio_env_pick(audio_pool_thunder), random_range(0.65, 0.9));
        audio_env_last = "THUNDER";
        return true;
    }

    // Chuva comum: fauna reduzida, mas sapos podem aparecer.
    if ((_weather == WEATHER_RAIN || _weather == WEATHER_STORM) && _roll < 28)
    {
        if (_hour >= 18 || _hour < 7)
        {
            audio_env_play(audio_env_pick(audio_pool_frogs), random_range(0.35, 0.60));
            audio_env_last = "FROG";
            return true;
        }
    }

    // Noite/madrugada: grilos e cigarras dominam.
    if (_hour >= 18 || _hour < 6)
    {
        if (_roll < 68)
        {
            audio_env_play(audio_env_pick(audio_pool_insects), random_range(0.25, 0.50));
            audio_env_last = "INSECT";
            return true;
        }
    }

    // Manhã/tarde: cigarras podem aparecer como evento pontual.
    if (_hour >= 7 && _hour < 18 && _roll < 38)
    {
        audio_env_play(snd_cicada, random_range(0.20, 0.42));
        audio_env_last = "CICADA";
        return true;
    }

    // Sem evento neste ciclo. O scheduler tenta novamente depois.
    audio_env_last = "NONE";
    return false;
};

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
