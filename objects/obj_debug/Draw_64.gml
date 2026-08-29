if (!debug_enabled || !show_overlay) exit;

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
var px = 16;
var py = 16;
var line = 18;
var panel_w = min(500, gui_w - 32);
var panel_h = 16 * line + 24;

draw_set_alpha(0.92);
draw_set_color(c_black);
draw_rectangle(px - 8, py - 8, px + panel_w, py + panel_h, false);
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var title = ["GERAL & ATALHOS", "TEMPO & AMBIENTE", "SISTEMA DE CLIMA", "ÁUDIO DIRETOR"];
draw_text(px, py, "SHINOBI DEBUG | PAG " + string(page + 1) + "/" + string(page_count) + " | " + title[page]);

if (page == 0) // GERAL & ATALHOS
{
    draw_text(px, py + line * 2, "[F5] Ocultar Painel  |  [F6/F7] Trocar Página");
    draw_text(px, py + line * 4, "--- TEMPO ---");
    draw_text(px, py + line * 5, "[F1] Pausar/Despausar  |  [F4] Modo Turbo (x12)");
    draw_text(px, py + line * 6, "[F2] Avançar +1 Hora   |  [F3] Voltar -1 Hora");
    draw_text(px, py + line * 8, "--- CLIMA ---");
    draw_text(px, py + line * 9, "[F8] Limpo    |  [F9] Chuva  |  [F10] Tempestade");
    draw_text(px, py + line * 10, "[F11] Próximo |  [F12] Ligar/Desligar Auto");
    draw_text(px, py + line * 12, "--- ÁUDIO ---");
    draw_text(px, py + line * 13, "[A] Forçar Evento de Áudio Ambiental");
    
    draw_text(px, py + line * 15, "Último Comando: " + string(global.debug_data.last_command));
}
else if (page == 1) // TEMPO & AMBIENTE
{
    if (instance_exists(obj_env))
    {
        var hh = floor(obj_env.time_seconds / 3600);
        var mm = floor((obj_env.time_seconds mod 3600) / 60);
        var ss = floor(obj_env.time_seconds mod 60);
        var clock = string_format(hh, 2, 0) + ":" + string_format(mm, 2, 0) + ":" + string_format(ss, 2, 0);
        
        draw_text(px, py + line * 2, "Dia: " + string(obj_env.time_day) + "  |  Relógio: " + clock);
        draw_text(px, py + line * 3, "Período: " + string(obj_env.time_period));
        draw_text(px, py + line * 4, "Escala: x" + string(obj_env.time_scale) + "  |  Pausado: " + string(obj_env.time_paused));
        
        draw_text(px, py + line * 6, "--- VISUAL ---");
        draw_text(px, py + line * 7, "Night Factor: " + string_format(obj_env.night_factor, 1, 2));
        draw_text(px, py + line * 8, "Ambient Color: " + string(obj_env.ambient_col));
        draw_text(px, py + line * 9, "Stars Alpha: " + string_format(obj_env.stars_alpha, 1, 2));
        draw_text(px, py + line * 10, "Moon Alpha: " + string_format(obj_env.moon_alpha, 1, 2));
        
        draw_text(px, py + line * 12, "--- LUA ---");
        var moon_name = (obj_env.moon_mode == 0) ? "Branca" : ((obj_env.moon_mode == 1) ? "Azul" : "Vermelha");
        draw_text(px, py + line * 13, "Fase Noturna Atual: " + moon_name);
        draw_text(px, py + line * 14, "Noites Normais Acumuladas: " + string(obj_env.moon_normal_nights));
    }
    else { draw_text(px, py + line * 2, "obj_env não encontrado."); }
}
else if (page == 2) // SISTEMA DE CLIMA
{
    if (instance_exists(obj_weather_manager))
    {
        var rn = room_get_name(room);
        var is_indoor = false;
        for (var i = 0; i < array_length(obj_weather_manager.indoor_rooms); i++) {
            if (rn == obj_weather_manager.indoor_rooms[i]) { is_indoor = true; break; }
        }

        draw_text(px, py + line * 2, "Room: " + rn + "  |  Indoor: " + string(is_indoor));
        draw_text(px, py + line * 3, "Modo Automático: " + string(obj_weather_manager.weather_auto));
        draw_text(px, py + line * 4, "Evento Atual: " + obj_weather_manager.weather_event);
        
        draw_text(px, py + line * 6, "--- ESTADOS ---");
        draw_text(px, py + line * 7, "Clima Atual: " + obj_weather_manager.weather_state_name(obj_weather_manager.weather_current));
        draw_text(px, py + line * 8, "Próx. Alvo: " + obj_weather_manager.weather_state_name(obj_weather_manager.weather_target));
        draw_text(px, py + line * 9, "Intensidade: " + string_format(obj_weather_manager.weather_intensity, 1, 2));
        draw_text(px, py + line * 10, "Transição em Curso: " + string(obj_weather_manager.weather_transitioning));
        
        draw_text(px, py + line * 12, "--- ELEMENTOS ---");
        draw_text(px, py + line * 13, "Modo Precipitação: " + string(global.precip_mode));
        draw_text(px, py + line * 14, "Neblina (Fog): " + string(obj_weather_manager.fog_on));
    }
    else { draw_text(px, py + line * 2, "obj_weather_manager não encontrado."); }
}
else if (page == 3) // ÁUDIO DIRETOR
{
    if (instance_exists(obj_weather_manager))
    {
        draw_text(px, py + line * 2, "Sistema de Eventos: " + (obj_weather_manager.audio_env_enabled ? "ATIVADO" : "DESATIVADO"));
        draw_text(px, py + line * 3, "Timer Próx. Evento: " + string_format(obj_weather_manager.audio_env_timer, 1, 1) + "s");
        draw_text(px, py + line * 4, "Último Tocado: " + string(obj_weather_manager.audio_env_last));
        draw_text(px, py + line * 5, "Total de Eventos Hoje: " + string(obj_weather_manager.audio_env_event_count));
        
        draw_text(px, py + line * 7, "--- ATIVOS AGORA ---");
        var insect = (obj_weather_manager.audio_env_last == "INSECT" || obj_weather_manager.audio_env_last == "CICADA");
        var frog = (obj_weather_manager.audio_env_last == "FROG");
        var thunder = (obj_weather_manager.audio_env_last == "THUNDER");
        
        draw_text(px, py + line * 8, "Insetos: " + string(insect) + "  |  Sapos: " + string(frog) + "  |  Trovão: " + string(thunder));

        draw_text(px, py + line * 10, "--- VOLUMES (CHUVAS E AMBIENTE) ---");
        var rain_vol = 0;
        if (obj_weather_manager.h_forest != -1 && audio_is_playing(obj_weather_manager.h_forest)) rain_vol += 0.65;
        if (obj_weather_manager.h_heavy != -1 && audio_is_playing(obj_weather_manager.h_heavy)) rain_vol += 0.45;
        draw_text(px, py + line * 11, "Chuva Base: " + string_format(clamp(rain_vol, 0, 1), 1, 2));

        if (instance_exists(obj_ambiente))
        {
            draw_text(px, py + line * 12, "Pássaros (obj_ambiente): " + string_format(obj_ambiente.vol_birds, 1, 2));
            draw_text(px, py + line * 13, "Corvos (obj_ambiente): " + string_format(obj_ambiente.vol_crows, 1, 2));
            draw_text(px, py + line * 14, "Vento (obj_ambiente): " + string_format(obj_ambiente.vol_vento, 1, 2));
        }
        else
        {
            draw_text(px, py + line * 12, "obj_ambiente não instanciado na room.");
        }
    }
    else { draw_text(px, py + line * 2, "obj_weather_manager não encontrado."); }
}