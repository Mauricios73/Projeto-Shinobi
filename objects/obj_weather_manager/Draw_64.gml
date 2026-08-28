// obj_weather_manager - Draw GUI
// Painel unico de diagnostico do Environment / Weather / Audio.
// Usa a mesma chave F5 do Time System: time_debug_overlay.

if (!instance_exists(obj_env)) exit;
if (!obj_env.time_debug_overlay) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _line = 18;
var _x = 16;
var _y = 16;
var _w = min(470, _gw - 32);
var _h = 24 * _line + 24;

// ====================================================
// TIME
// ====================================================
var _day = obj_env.time_day;
var _hours = obj_env.time_seconds / 3600;
var _hh = floor(_hours);
var _mm = floor((_hours - _hh) * 60);
var _ss = floor(obj_env.time_seconds mod 60);
var _clock = string_format(_hh, 2, 0) + ":" + string_format(_mm, 2, 0) + ":" + string_format(_ss, 2, 0);
var _period = obj_env.time_period;
var _paused = obj_env.time_paused;
var _scale = obj_env.time_scale;

// ====================================================
// ROOM / WEATHER
// ====================================================
var _room = room_get_name(room);
var _indoor = false;
if (variable_instance_exists(id, "indoor_rooms"))
{
    for (var _ri = 0; _ri < array_length(indoor_rooms); _ri++)
    {
        if (_room == indoor_rooms[_ri])
        {
            _indoor = true;
            break;
        }
    }
}

var _weather_name = "-";
var _weather_target = "-";
var _weather_intensity = 0;
var _weather_transition = false;
var _weather_event = "-";
if (variable_global_exists("environment") && variable_struct_exists(global.environment, "weather"))
{
    var _we = global.environment.weather;
    if (variable_struct_exists(_we, "name")) _weather_name = _we.name;
    if (variable_struct_exists(_we, "target_name")) _weather_target = _we.target_name;
    if (variable_struct_exists(_we, "intensity")) _weather_intensity = _we.intensity;
    if (variable_struct_exists(_we, "transitioning")) _weather_transition = _we.transitioning;
    if (variable_struct_exists(_we, "event")) _weather_event = _we.event;
}

// ====================================================
// AUDIO DIRECTOR
// ====================================================
var _audio_enabled = false;
var _audio_timer = 0;
var _audio_last = "-";
var _audio_count = 0;
if (variable_instance_exists(id, "audio_env_enabled")) _audio_enabled = audio_env_enabled;
if (variable_instance_exists(id, "audio_env_timer")) _audio_timer = max(0, audio_env_timer);
if (variable_instance_exists(id, "audio_env_last")) _audio_last = audio_env_last;
if (variable_instance_exists(id, "audio_env_event_count")) _audio_count = audio_env_event_count;

var _birds = 0;
var _crows = 0;
var _wind = 0;
if (instance_exists(obj_ambiente))
{
    _birds = obj_ambiente.vol_birds;
    _crows = obj_ambiente.vol_crows;
    _wind = obj_ambiente.vol_vento;
}

var _rain = 0;
if (variable_instance_exists(id, "h_forest") && h_forest != -1 && audio_is_playing(h_forest)) _rain += 0.65;
if (variable_instance_exists(id, "h_heavy") && h_heavy != -1 && audio_is_playing(h_heavy)) _rain += 0.45;
_rain = clamp(_rain, 0, 1);

var _insect = (_audio_last == "INSECT" || _audio_last == "CICADA");
var _frog = (_audio_last == "FROG");
var _thunder = (_audio_last == "THUNDER");

// ====================================================
// PAINEL
// ====================================================
var _box_b = min(_gh - 12, _y + _h);
draw_set_alpha(0.90);
draw_set_color(c_black);
draw_rectangle(_x - 8, _y - 8, _x + _w, _box_b, false);
draw_set_alpha(1);
draw_set_color(c_white);

draw_text(_x, _y, "ENV DEBUG");
draw_text(_x, _y + _line * 1, "TIME       Dia " + string(_day) + "  " + _clock);
draw_text(_x, _y + _line * 2, "PERIOD     " + string(_period));
draw_text(_x, _y + _line * 3, "PAUSED     " + string(_paused) + "  x" + string(_scale));
draw_text(_x, _y + _line * 4, "ROOM       " + _room);
draw_text(_x, _y + _line * 5, "INDOOR     " + string(_indoor));
draw_text(_x, _y + _line * 6, "WEATHER    " + string(_weather_name));
draw_text(_x, _y + _line * 7, "TARGET     " + string(_weather_target));
draw_text(_x, _y + _line * 8, "INTENSITY  " + string_format(_weather_intensity, 1, 2));
draw_text(_x, _y + _line * 9, "TRANSITION " + string(_weather_transition));
draw_text(_x, _y + _line * 10, "W-EVENT    " + string(_weather_event));
draw_text(_x, _y + _line * 11, "AUDIO      " + string(_audio_enabled));
draw_text(_x, _y + _line * 12, "A-TIMER    " + string_format(_audio_timer, 1, 1) + "s");
draw_text(_x, _y + _line * 13, "LAST       " + string(_audio_last));
draw_text(_x, _y + _line * 14, "EVENTS     " + string(_audio_count));
draw_text(_x, _y + _line * 15, "BIRDS      " + string_format(_birds, 1, 2));
draw_text(_x, _y + _line * 16, "CROWS      " + string_format(_crows, 1, 2));
draw_text(_x, _y + _line * 17, "WIND       " + string_format(_wind, 1, 2));
draw_text(_x, _y + _line * 18, "RAIN       " + string_format(_rain, 1, 2));
draw_text(_x, _y + _line * 19, "INSECT     " + string(_insect));
draw_text(_x, _y + _line * 20, "FROG       " + string(_frog));
draw_text(_x, _y + _line * 21, "THUNDER    " + string(_thunder));
draw_text(_x, _y + _line * 22, "MOON       " + string(obj_env.moon_mode));
draw_text(_x, _y + _line * 23, "F5 = fechar debug | A = forcar evento");

draw_set_alpha(1);
draw_set_color(c_white);
