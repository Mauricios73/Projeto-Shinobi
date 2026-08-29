/// obj_debug - Create
persistent = true;
debug_enabled = true;
show_overlay = true;
page = 0;
page_count = 4;

// 0=geral, 1=tempo, 2=clima/audio, 3=visual/IA
key_help = true;

if (!variable_global_exists("debug")) global.debug = {};
global.debug.enabled = debug_enabled;
global.debug.show = show_overlay;
global.debug.page = page;
global.debug.last_command = "INIT";
global.debug.command_count = 0;

// API central de comandos. Os sistemas podem consultar global.debug.
debug_command = function(_command)
{
    global.debug.last_command = _command;
    global.debug.command_count += 1;

    if (_command == "TIME_PAUSE" && instance_exists(obj_env)) obj_env.time_paused = !obj_env.time_paused;
    if (_command == "TIME_HOUR_PLUS" && instance_exists(obj_env)) obj_env.time_seconds += 3600;
    if (_command == "TIME_HOUR_MINUS" && instance_exists(obj_env)) obj_env.time_seconds -= 3600;
    if (_command == "TIME_SPEED" && instance_exists(obj_env)) obj_env.time_scale = (obj_env.time_scale == 1) ? obj_env.time_test_speed : 1;

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
