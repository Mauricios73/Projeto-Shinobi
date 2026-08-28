// obj_weather_manager - Draw GUI
// F5 alterna este painel.

if (!debug_popup) exit;

var _w = display_get_gui_width();
var _h = display_get_gui_height();
var _x = 16;
var _y = 16;
var _line = 16;

var _hour = 12;
var _period = "-";
if (instance_exists(obj_env))
{
    _hour = obj_env.time_seconds / 3600;
    _period = obj_env.time_period;
}

var _hh = floor(_hour);
var _mm = floor((_hour - _hh) * 60);
var _hour_text = string_format(_hh, 2, 0) + ":" + string_format(_mm, 2, 0);

var _audio_enabled = audio_env_enabled;
var _audio_timer = audio_env_timer;
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

var _insects = (_audio_last == "INSECT") ? 1 : 0;
var _frogs = (_audio_last == "FROG") ? 1 : 0;
var _thunder = (_audio_last == "THUNDER") ? 1 : 0;

var _box_h = 16 * _line + 28;
var _box_r = min(_w - 12, _x + 360);
var _box_b = min(_h - 12, _y + _box_h);

draw_set_alpha(0.90);
draw_set_color(c_black);
draw_rectangle(_x - 8, _y - 8, _box_r, _box_b, false);
draw_set_alpha(1);
draw_set_color(c_white);

draw_text(_x, _y, "ENV DEBUG");
draw_text(_x, _y + _line, "TIME     " + _hour_text);
draw_text(_x, _y + _line * 2, "PERIOD   " + string(_period));
draw_text(_x, _y + _line * 3, "WEATHER  " + weather_state_name(weather_current));
draw_text(_x, _y + _line * 4, "TARGET   " + weather_state_name(weather_target));
draw_text(_x, _y + _line * 5, "INTENS.  " + string_format(weather_intensity, 1, 2));
draw_text(_x, _y + _line * 6, "ROOM     " + string(room_get_name(room)));
draw_text(_x, _y + _line * 7, "OUTDOOR  " + string(outdoor));
draw_text(_x, _y + _line * 8, "AUDIO    " + string(_audio_enabled));
draw_text(_x, _y + _line * 9, "A-TIMER  " + string_format(_audio_timer, 1, 1) + "s");
draw_text(_x, _y + _line * 10, "LAST     " + string(_audio_last));
draw_text(_x, _y + _line * 11, "EVENTS   " + string(_audio_count));
draw_text(_x, _y + _line * 12, "BIRD     " + string_format(_birds, 1, 2));
draw_text(_x, _y + _line * 13, "CROW     " + string_format(_crows, 1, 2));
draw_text(_x, _y + _line * 14, "WIND     " + string_format(_wind, 1, 2));
draw_text(_x, _y + _line * 15, "RAIN     " + string_format(_rain, 1, 2));
draw_text(_x, _y + _line * 16, "INSECT   " + string(_insects));
draw_text(_x, _y + _line * 17, "FROG     " + string(_frogs));
draw_text(_x, _y + _line * 18, "THUNDER  " + string(_thunder));

draw_set_color(c_white);
draw_text(_x, _box_b - 18, "F5 = fechar debug | A = evento ambiental");
