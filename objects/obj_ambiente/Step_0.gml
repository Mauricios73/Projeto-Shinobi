// obj_ambiente - Step

if (room_get_name(room) == "rm_init" || room_get_name(room) == "rm_menu") exit;

var _hour = 12;
if (instance_exists(obj_env)) _hour = obj_env.time_seconds / 3600;

var _weather = 0;
var _weather_intensity = 0;
var _indoor = false;
if (variable_global_exists("environment") && variable_struct_exists(global.environment, "weather"))
{
    _weather = global.environment.weather.current;
    _weather_intensity = global.environment.weather.intensity;
    _indoor = global.environment.weather.indoor;
}

// ====================================================
// MIX POR HORARIO
// ====================================================
var _birds = 1.0;
var _crows = 0.35;
var _wind = 1.0;

if (_hour < 5)
{
    _birds = 0.03;
    _crows = 0.45;
}
else if (_hour < 7)
{
    _birds = 0.55;
    _crows = 0.30;
}
else if (_hour < 16)
{
    _birds = 1.0;
    _crows = 0.10;
}
else if (_hour < 19)
{
    _birds = 0.65;
    _crows = 0.55;
}
else
{
    _birds = 0.04;
    _crows = 0.65;
}

// ====================================================
// CLIMA
// ====================================================
if (_weather == 1)
{
    _birds *= 0.75;
    _wind *= 1.15;
}
else if (_weather == 2)
{
    _birds *= 0.18;
    _crows *= 0.35;
    _wind *= 1.25;
}
else if (_weather == 3)
{
    _birds *= 0.04;
    _crows *= 0.10;
    _wind *= 1.65;
}

if (_indoor)
{
    _birds *= 0.15;
    _crows *= 0.10;
    _wind *= 0.35;
}

var _rain_mask = clamp(_weather_intensity * 0.45, 0, 0.45);
_birds *= 1 - _rain_mask;
_crows *= 1 - _rain_mask;

global.ambient_mult = _indoor ? 0.45 : 1.0;

if (bird_voice != -1 && audio_is_playing(bird_voice))
    audio_sound_gain(bird_voice, vol_birds * _birds * global.ambient_mult, fade_in_ms);

if (crow_voice != -1 && audio_is_playing(crow_voice))
    audio_sound_gain(crow_voice, vol_crows * _crows * global.ambient_mult, fade_in_ms);

if (vento_voice != -1 && audio_is_playing(vento_voice))
    audio_sound_gain(vento_voice, vol_vento * _wind * global.ambient_mult, fade_in_ms);
