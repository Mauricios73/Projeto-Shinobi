persistent = true;
debug_enabled = true;
show_overlay = true;
page = 0;
page_count = 4; 

// 0 = Geral/Teclas, 1 = Tempo/Luz, 2 = Clima, 3 = Áudio Diretor
key_help = true;

// Mudamos de "debug" para "debug_data" para evitar conflito com 'false/0'
if (!variable_global_exists("debug_data")) global.debug_data = {};
global.debug_data.enabled = debug_enabled;
global.debug_data.show = show_overlay;
global.debug_data.page = page;
global.debug_data.last_command = "INIT";
global.debug_data.command_count = 0;

// API central de comandos
debug_command = function(_command)
{
    global.debug_data.last_command = _command;
    global.debug_data.command_count += 1;

    // Comandos de Tempo
    if (instance_exists(obj_env))
    {
        if (_command == "TIME_PAUSE") obj_env.time_paused = !obj_env.time_paused;
        if (_command == "TIME_HOUR_PLUS") obj_env.time_seconds += 3600;
        if (_command == "TIME_HOUR_MINUS") obj_env.time_seconds -= 3600;
        if (_command == "TIME_SPEED") obj_env.time_scale = (obj_env.time_scale == 1) ? obj_env.time_test_speed : 1;
    }

    // Comandos de Clima
    if (instance_exists(obj_weather_manager))
    {
        if (_command == "WEATHER_CLEAR") { obj_weather_manager.weather_set_target(obj_weather_manager.WEATHER_CLEAR, "DEBUG_CLEAR"); obj_weather_manager.weather_auto = false; }
        if (_command == "WEATHER_RAIN") { obj_weather_manager.weather_set_target(obj_weather_manager.WEATHER_RAIN, "DEBUG_RAIN"); obj_weather_manager.weather_auto = false; }
        if (_command == "WEATHER_STORM") { obj_weather_manager.weather_set_target(obj_weather_manager.WEATHER_STORM, "DEBUG_STORM"); obj_weather_manager.weather_auto = false; }
        if (_command == "WEATHER_NEXT")
        {
            var _next = obj_weather_manager.WEATHER_CLEAR;
            if (obj_weather_manager.weather_current == obj_weather_manager.WEATHER_CLEAR) _next = obj_weather_manager.WEATHER_CLOUDY;
            else if (obj_weather_manager.weather_current == obj_weather_manager.WEATHER_CLOUDY) _next = obj_weather_manager.WEATHER_RAIN;
            else if (obj_weather_manager.weather_current == obj_weather_manager.WEATHER_RAIN) _next = obj_weather_manager.WEATHER_STORM;
            obj_weather_manager.weather_set_target(_next, "DEBUG_NEXT");
            obj_weather_manager.weather_auto = false;
        }
        if (_command == "WEATHER_AUTO") obj_weather_manager.weather_auto = !obj_weather_manager.weather_auto;
        if (_command == "AUDIO_EVENT") obj_weather_manager.audio_env_trigger_event();
    }
};