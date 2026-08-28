// obj_weather_manager - Draw GUI
// PAINEL DE DEBUG DO ENVIRONMENT SYSTEM
// F5 e controlado pelo obj_env. Este evento apenas desenha o painel.

if (!instance_exists(obj_env)) exit;
if (!obj_env.time_debug_overlay) exit;

var gw = display_get_gui_width();
var gh = display_get_gui_height();
var x = 16;
var y = 16;
var line = 17;
var panel_w = min(520, gw - 32);
var panel_h = 27 * line + 24;

var hh = floor(obj_env.time_seconds / 3600);
var mm = floor((obj_env.time_seconds mod 3600) / 60);
var ss = floor(obj_env.time_seconds mod 60);
var clock = string_format(hh, 2, 0) + ":" + string_format(mm, 2, 0) + ":" + string_format(ss, 2, 0);

var weather_name = "-";
var weather_target_name = "-";
var weather_intensity = 0;
var weather_transition = false;
var weather_event = "-";
var weather_auto = false;

if (variable_global_exists("environment") && variable_struct_exists(global.environment, "weather"))
{
    var w = global.environment.weather;
    if (variable_struct_exists(w, "name")) weather_name = string(w.name);
    if (variable_struct_exists(w, "target_name")) weather_target_name = string(w.target_name);
    if (variable_struct_exists(w, "intensity")) weather_intensity = w.intensity;
    if (variable_struct_exists(w, "transitioning")) weather_transition = w.transitioning;
    if (variable_struct_exists(w, "event")) weather_event = string(w.event);
    if (variable_struct_exists(w, "auto")) weather_auto = w.auto;
}

var room_name = room_get_name(room);
var indoor = false;
if (variable_instance_exists(obj_weather_manager, "indoor_rooms"))
{
    for (var i = 0; i < array_length(obj_weather_manager.indoor_rooms); i++)
    {
        if (room_name == obj_weather_manager.indoor_rooms[i])
        {
            indoor = true;
            break;
        }
    }
}

var audio_enabled = false;
var audio_timer = 0;
var audio_last = "-";
var audio_events = 0;
if (variable_instance_exists(obj_weather_manager, "audio_env_enabled")) audio_enabled = obj_weather_manager.audio_env_enabled;
if (variable_instance_exists(obj_weather_manager, "audio_env_timer")) audio_timer = max(0, obj_weather_manager.audio_env_timer);
if (variable_instance_exists(obj_weather_manager, "audio_env_last")) audio_last = string(obj_weather_manager.audio_env_last);
if (variable_instance_exists(obj_weather_manager, "audio_env_event_count")) audio_events = obj_weather_manager.audio_env_event_count;

var birds = 0;
var crows = 0;
var wind = 0;
if (instance_exists(obj_ambiente))
{
    birds = obj_ambiente.vol_birds;
    crows = obj_ambiente.vol_crows;
    wind = obj_ambiente.vol_vento;
}

var rain = 0;
if (variable_instance_exists(obj_weather_manager, "h_forest"))
{
    if (obj_weather_manager.h_forest != -1 && audio_is_playing(obj_weather_manager.h_forest)) rain += 0.65;
}
if (variable_instance_exists(obj_weather_manager, "h_heavy"))
{
    if (obj_weather_manager.h_heavy != -1 && audio_is_playing(obj_weather_manager.h_heavy)) rain += 0.45;
}
rain = clamp(rain, 0, 1);

var insect = (audio_last == "INSECT" || audio_last == "CICADA");
var frog = (audio_last == "FROG");
var thunder = (audio_last == "THUNDER");

// Fundo e borda.
draw_set_alpha(0.92);
draw_set_color(c_black);
draw_rectangle(x - 8, y - 8, x + panel_w, min(gh - 8, y + panel_h), false);
draw_set_alpha(1);
draw_set_color(c_white);

draw_text(x, y, "ENVIRONMENT DEBUG");
draw_text(x, y + line * 1, "TIME       Dia " + string(obj_env.time_day) + "  " + clock);
draw_text(x, y + line * 2, "PERIOD     " + string(obj_env.time_period));
draw_text(x, y + line * 3, "TIME SCALE x" + string(obj_env.time_scale) + "  PAUSED=" + string(obj_env.time_paused));
draw_text(x, y + line * 4, "ROOM       " + room_name);
draw_text(x, y + line * 5, "INDOOR     " + string(indoor));
draw_text(x, y + line * 6, "WEATHER    " + weather_name);
draw_text(x, y + line * 7, "TARGET     " + weather_target_name);
draw_text(x, y + line * 8, "INTENSITY  " + string_format(weather_intensity, 1, 2));
draw_text(x, y + line * 9, "TRANSITION " + string(weather_transition));
draw_text(x, y + line * 10, "W-EVENT    " + weather_event);
draw_text(x, y + line * 11, "AUTO       " + string(weather_auto));
draw_text(x, y + line * 12, "PRECIP     " + string(global.precip_mode));
draw_text(x, y + line * 13, "AUDIO      " + string(audio_enabled));
draw_text(x, y + line * 14, "A-TIMER    " + string_format(audio_timer, 1, 1) + "s");
draw_text(x, y + line * 15, "LAST EVENT " + audio_last);
draw_text(x, y + line * 16, "EVENTS     " + string(audio_events));
draw_text(x, y + line * 17, "BIRDS      " + string_format(birds, 1, 2));
draw_text(x, y + line * 18, "CROWS      " + string_format(crows, 1, 2));
draw_text(x, y + line * 19, "WIND       " + string_format(wind, 1, 2));
draw_text(x, y + line * 20, "RAIN       " + string_format(rain, 1, 2));
draw_text(x, y + line * 21, "INSECT     " + string(insect));
draw_text(x, y + line * 22, "FROG       " + string(frog));
draw_text(x, y + line * 23, "THUNDER    " + string(thunder));
draw_text(x, y + line * 24, "MOON       " + string(obj_env.moon_mode));
draw_text(x, y + line * 25, "MOON NORM  " + string(obj_env.moon_normal_nights));
draw_text(x, y + line * 26, "F5 = abrir/fechar debug   A = evento ambiental");

draw_set_alpha(1);
draw_set_color(c_white);
