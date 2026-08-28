// obj_weather_manager - Draw GUI
// Painel de diagnostico do Environment / Weather / Audio.
// F5 alterna o painel.

if (!debug_popup) exit;

var _w = display_get_gui_width();
var _h = display_get_gui_height();
var _line = 16;
var _x = 12;
var _y = 12;

// ====================================================
// TIME
// ====================================================
var _hour = 0;
var _period = "-";
if (instance_exists(obj_env))
{
    _hour = obj_env.time_seconds / 3600;
    _period = obj_env.time_period;
}

_hour = clamp(_hour, 0, 23.9999);
var _hh = floor(_hour);
var _mm = floor((_hour - _hh) * 60);
var _hour_text = string_format(_hh, 2, 0) + ":" + string_format(_mm, 2, 0);

// ====================================================
// ROOM / WEATHER
// ====================================================
var _room_name = room_get_name(room);
var _indoor = false;
for (var _ri = 0; _ri < array_length(indoor_rooms); _ri++)
{
    if (_room_name == indoor_rooms[_ri])
    {
        _indoor = true;
        break;
    }
}
var _outdoor = !_indoor;

// ====================================================
// AUDIO
// ====================================================
var _audio_enabled = audio_env_enabled;
var _audio_timer = max(0, audio_env_timer);
var _audio_last = audio_env_last;
var _audio_count = audio_env_event_count;

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
if (h_forest != -1 && audio_is_playing(h_forest)) _rain += audio_sound_get_gain(h_forest);
if (h_heavy != -1 && audio_is_playing(h_heavy)) _rain += audio_sound_get_gain(h_heavy);
_rain = clamp(_rain, 0, 1);

var _insect_active = (_audio_last == "INSECT" || _audio_last == "CICADA");
var _frog_active = (_audio_last == "FROG");
var _thunder_active = (_audio_last == "THUNDER");

// ====================================================
// PANEL
// ====================================================
var _lines = 20;
var _box_w = min(370, _w - 24);
var _box_h = _lines * _line + 28;
var _box_r = _x + _box_w;
var _box_b = min(_h - 8, _y + _box_h);

// Fundo com leve transparencia.
draw_set_alpha(0.88);
draw_set_color(c_black);
draw_rectangle(_x - 6, _y - 6, _box_r, _box_b, false);
draw_set_alpha(1);

draw_set_color(c_white);
draw_text(_x, _y, "ENV DEBUG");
draw_text(_x, _y + _line * 1, "TIME     " + _hour_text);
draw_text(_x, _y + _line * 2, "PERIOD   " + string(_period));
draw_text(_x, _y + _line * 3, "WEATHER  " + weather_state_name(weather_current));
draw_text(_x, _y + _line * 4, "TARGET   " + weather_state_name(weather_target));
draw_text(_x, _y + _line * 5, "INTENS.  " + string_format(weather_intensity, 1, 2));
draw_text(_x, _y + _line * 6, "ROOM     " + _room_name);
draw_text(_x, _y + _line * 7, "OUTDOOR  " + string(_outdoor));
draw_text(_x, _y + _line * 8, "AUDIO    " + string(_audio_enabled));
draw_text(_x, _y + _line * 9, "A-TIMER  " + string_format(_audio_timer, 1, 1) + "s");
draw_text(_x, _y + _line * 10, "LAST     " + string(_audio_last));
draw_text(_x, _y + _line * 11, "EVENTS   " + string(_audio_count));
draw_text(_x, _y + _line * 12, "BIRD     " + string_format(_birds, 1, 2));
draw_text(_x, _y + _line * 13, "CROW     " + string_format(_crows, 1, 2));
draw_text(_x, _y + _line * 14, "WIND     " + string_format(_wind, 1, 2));
draw_text(_x, _y + _line * 15, "RAIN     " + string_format(_rain, 1, 2));
draw_text(_x, _y + _line * 16, "INSECT   " + string(_insect_active));
draw_text(_x, _y + _line * 17, "FROG     " + string(_frog_active));
draw_text(_x, _y + _line * 18, "THUNDER  " + string(_thunder_active));

draw_set_alpha(0.75);
draw_text(_x, _box_b - 16, "F5 = fechar | A = evento ambiental");
draw_set_alpha(1);
draw_set_color(c_white);
