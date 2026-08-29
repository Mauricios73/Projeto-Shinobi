/// obj_debug - Draw GUI
if (!debug_enabled || !show_overlay) exit;

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
var px = 12;
var py = 12;
var line = 16;
var panel_w = min(500, gui_w - 24);
var panel_h = min(gui_h - 24, 25 * line + 20);

draw_set_alpha(0.90);
draw_set_color(c_black);
draw_rectangle(px - 6, py - 6, px + panel_w, py + panel_h, false);
draw_set_alpha(1);
draw_set_color(c_white);

draw_text(px, py, "SHINOBI DEBUG | PAGINA " + string(page + 1) + "/" + string(page_count));

if (page == 0)
{
    draw_text(px, py + line * 2, "F5  abrir/fechar debug");
    draw_text(px, py + line * 3, "F6/F7 trocar pagina");
    draw_text(px, py + line * 4, "F1 pausa | F2 +1h | F3 -1h | F4 velocidade");
    draw_text(px, py + line * 5, "F8 limpar | F9 chuva | F10 tempestade");
    draw_text(px, py + line * 6, "F11 proximo clima | F12 auto clima | A audio");
    draw_text(px, py + line * 8, "ULTIMO COMANDO: " + string(global.debug.last_command));
    draw_text(px, py + line * 9, "COMANDOS: " + string(global.debug.command_count));
}
else if (page == 1)
{
    if (instance_exists(obj_env))
    {
        var hh = floor(obj_env.time_seconds / 3600);
        var mm = floor((obj_env.time_seconds mod 3600) / 60);
        var ss = floor(obj_env.time_seconds mod 60);
        var clock = string_format(hh, 2, 0) + ":" + string_format(mm, 2, 0) + ":" + string_format(ss, 2, 0);
        draw_text(px, py + line * 2, "TIME");
        draw_text(px, py + line * 3, "Dia: " + string(obj_env.time_day));
        draw_text(px, py + line * 4, "Relogio: " + clock);
        draw_text(px, py + line * 5, "Periodo: " + string(obj_env.time_period));
        draw_text(px, py + line * 6, "Escala: x" + string(obj_env.time_scale));
        draw_text(px, py + line * 7, "Pausado: " + string(obj_env.time_paused));
        draw_text(px, py + line * 8, "Night factor: " + string_format(obj_env.night_factor, 1, 2));
        draw_text(px, py + line * 9, "Lua: " + string(obj_env.moon_mode));
        draw_text(px, py + line * 10, "Noites normais: " + string(obj_env.moon_normal_nights));
    }
}
else if (page == 2)
{
    if (instance_exists(obj_weather_manager))
    {
        draw_text(px, py + line * 2, "WEATHER / AUDIO");
        draw_text(px, py + line * 3, "Clima: " + obj_weather_manager.weather_state_name(obj_weather_manager.weather_current));
        draw_text(px, py + line * 4, "Alvo: " + obj_weather_manager.weather_state_name(obj_weather_manager.weather_target));
        draw_text(px, py + line * 5, "Intensidade: " + string_format(obj_weather_manager.weather_intensity, 1, 2));
        draw_text(px, py + line * 6, "Transicao: " + string(obj_weather_manager.weather_transitioning));
        draw_text(px, py + line * 7, "Auto: " + string(obj_weather_manager.weather_auto));
        draw_text(px, py + line * 8, "Precipitacao: " + string(global.precip_mode));
        draw_text(px, py + line * 9, "Ultimo audio: " + string(obj_weather_manager.audio_env_last));
        draw_text(px, py + line * 10, "Eventos audio: " + string(obj_weather_manager.audio_env_event_count));
        draw_text(px, py + line * 11, "Timer audio: " + string_format(obj_weather_manager.audio_env_timer, 1, 1));
    }
}
else
{
    draw_text(px, py + line * 2, "VISUAL / SYSTEM");
    if (instance_exists(obj_env))
    {
        draw_text(px, py + line * 3, "Ambient color: " + string(obj_env.ambient_col));
        draw_text(px, py + line * 4, "Night factor: " + string_format(obj_env.night_factor, 1, 2));
        draw_text(px, py + line * 5, "Stars alpha: " + string_format(obj_env.stars_alpha, 1, 2));
        draw_text(px, py + line * 6, "Moon alpha: " + string_format(obj_env.moon_alpha, 1, 2));
    }
    if (instance_exists(obj_weather_manager))
    {
        draw_text(px, py + line * 8, "Fog: " + string(obj_weather_manager.fog_on));
        draw_text(px, py + line * 9, "Weather event: " + string(obj_weather_manager.weather_event));
    }
}

draw_set_alpha(1);
draw_set_color(c_white);
