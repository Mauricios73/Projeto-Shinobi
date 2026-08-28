// obj_weather_manager - Draw GUI
// PAINEL DE DEBUG DO ENVIRONMENT SYSTEM
// F5 e controlado pelo obj_env. Este evento apenas desenha o painel.

if (!instance_exists(obj_env)) exit;
if (!obj_env.time_debug_overlay) exit;

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
var gui_x = 16;
var gui_y = 16;
var gui_line = 17;
var panel_w = min(520, gui_w - 32);
var panel_h = 27 * gui_line + 24;

var hh = floor(obj_env.time_seconds / 3600);
var mm = floor((obj_env.time_seconds mod 3600) / 60);
var ss = floor(obj_env.time_seconds mod 60);
var clock_text = string_format(hh, 2, 0) + ":" + string_format(mm, 2, 0) + ":" + string_format(ss, 2, 0);

var weather_name = "-";
var weather_target_name = "-";
var weather_intensity = 0;
var weather_transition = false;
var weather_event = "-";
var weather_auto = false;

if (variable_global_exists("environment") && variable_struct_exists(global.environment, "weather"))
{
    var weather_data = global.environment.weather;
    if (variable_struct_exists(weather_data, "name")) weather_name = string(weather_data.name);
    if (variable_struct_exists(weather_data, "target_name")) weather_target_name = string(weather_data.target_name);
    if (variable_struct_exists(weather_data, "intensity")) weather_intensity = weather_data.intensity;
    if (variable_struct_exists(weather_data, "transitioning")) weather_transition = weather_data.transitioning;
    if (variable_struct_exists(weather_data, "event")) weather_event = string(weather_data.event);
    if (variable_struct_exists(weather_data, "auto")) weather_auto = weather_data.auto;
}

var room_name = room_get_name(room);
var is_indoor = false;
if (variable_instance_exists(obj_weather_manager, "indoor_rooms"))
{
    for (var room_index = 0; room_index < array_length(obj_weather_manager.indoor_rooms); room_index++)
    {
        if (room_name == obj_weather_manager.indoor_rooms[room_index])
        {
            is_indoor = true;
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

var birds_volume = 0;
var crows_volume = 0;
var wind_volume = 0;
if (instance_exists(obj_ambiente))
{
    birds_volume = obj_ambiente.vol_birds;
    crows_volume = obj_ambiente.vol_crows;
    wind_volume = obj_ambiente.vol_vento;
}

var rain_volume = 0;
if (variable_instance_exists(obj_weather_manager, "h_forest"))
{
    if (obj_weather_manager.h_forest != -1 && audio_is_playing(obj_weather_manager.h_forest)) rain_volume += 0.65;
}
if (variable_instance_exists(obj_weather_manager, "h_heavy"))
{
    if (obj_weather_manager.h_heavy != -1 && audio_is_playing(obj_weather_manager.h_heavy)) rain_volume += 0.45;
}
rain_volume = clamp(rain_volume, 0, 1);

var insect_active = (audio_last == "INSECT" || audio_last == "CICADA");
var frog_active = (audio_last == "FROG");
var thunder_active = (audio_last == "THUNDER");

// Fundo do painel.
draw_set_alpha(0.92);
draw_set_color(c_black);
draw_rectangle(gui_x - 8, gui_y - 8, gui_x + panel_w, min(gui_h - 8, gui_y + panel_h), false);
draw_set_alpha(1);
draw_set_color(c_white);

draw_text(gui_x, gui_y, "ENVIRONMENT DEBUG");
draw_text(gui_x, gui_y + gui_line * 1, "TIME       Dia " + string(obj_env.time_day) + "  " + clock_text);
draw_text(gui_x, gui_y + gui_line * 2, "PERIOD     " + string(obj_env.time_period));
draw_text(gui_x, gui_y + gui_line * 3, "TIME SCALE x" + string(obj_env.time_scale) + "  PAUSED=" + string(obj_env.time_paused));
draw_text(gui_x, gui_y + gui_line * 4, "ROOM       " + room_name);
draw_text(gui_x, gui_y + gui_line * 5, "INDOOR     " + string(is_indoor));
draw_text(gui_x, gui_y + gui_line * 6, "WEATHER    " + weather_name);
draw_text(gui_x, gui_y + gui_line * 7, "TARGET     " + weather_target_name);
draw_text(gui_x, gui_y + gui_line * 8, "INTENSITY  " + string_format(weather_intensity, 1, 2));
draw_text(gui_x, gui_y + gui_line * 9, "TRANSITION " + string(weather_transition));
draw_text(gui_x, gui_y + gui_line * 10, "W-EVENT    " + weather_event);
draw_text(gui_x, gui_y + gui_line * 11, "AUTO       " + string(weather_auto));
draw_text(gui_x, gui_y + gui_line * 12, "PRECIP     " + string(global.precip_mode));
draw_text(gui_x, gui_y + gui_line * 13, "AUDIO      " + string(audio_enabled));
draw_text(gui_x, gui_y + gui_line * 14, "A-TIMER    " + string_format(audio_timer, 1, 1) + "s");
draw_text(gui_x, gui_y + gui_line * 15, "LAST EVENT " + audio_last);
draw_text(gui_x, gui_y + gui_line * 16, "EVENTS     " + string(audio_events));
draw_text(gui_x, gui_y + gui_line * 17, "BIRDS      " + string_format(birds_volume, 1, 2));
draw_text(gui_x, gui_y + gui_line * 18, "CROWS      " + string_format(crows_volume, 1, 2));
draw_text(gui_x, gui_y + gui_line * 19, "WIND       " + string_format(wind_volume, 1, 2));
draw_text(gui_x, gui_y + gui_line * 20, "RAIN       " + string_format(rain_volume, 1, 2));
draw_text(gui_x, gui_y + gui_line * 21, "INSECT     " + string(insect_active));
draw_text(gui_x, gui_y + gui_line * 22, "FROG       " + string(frog_active));
draw_text(gui_x, gui_y + gui_line * 23, "THUNDER    " + string(thunder_active));
draw_text(gui_x, gui_y + gui_line * 24, "MOON       " + string(obj_env.moon_mode));
draw_text(gui_x, gui_y + gui_line * 25, "MOON NORM  " + string(obj_env.moon_normal_nights));
draw_text(gui_x, gui_y + gui_line * 26, "F5 = abrir/fechar debug   A = evento ambiental");

draw_set_alpha(1);
draw_set_color(c_white);
