/// ========================================================
/// OBJ_DEBUG - CREATE
/// Sistema central de debug/testes
/// ========================================================

persistent = true;
debug_enabled = true;
show_overlay = true;
page = 0;
page_count = 5;

// 0 = Geral
// 1 = Tempo / Ambiente
// 2 = Clima
// 3 = Áudio Diretor
// 4 = Visual Environment

key_help = true;
visual_test = "NONE";
debug_wind_override = false;
debug_wind_strength = 0;
debug_weather_override = false;
debug_weather_saved = -1;

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
	// ====================================================
	// COMANDOS VISUAIS - FASE 4
	// ====================================================

	if (_command == "VISUAL_SNOW")
	{
	    visual_test = "SNOW";

	    if (instance_exists(obj_weather_manager))
	    {
	        obj_weather_manager.weather_set_target(
	            obj_weather_manager.WEATHER_SNOW,
	            "DEBUG_SNOW"
	        );

	        obj_weather_manager.weather_auto = false;
	    }
	}


	if (_command == "VISUAL_FOG")
	{
	    visual_test = "FOG";

	    if (instance_exists(obj_weather_manager))
	    {
	        obj_weather_manager.fog_on = true;
	        obj_weather_manager.fog_left = 999999;
	    }
	}


	if (_command == "VISUAL_WIND_LOW")
	{
	    visual_test = "WIND LOW";

	    debug_wind_override = true;
	    debug_wind_strength = 25;
	}


	if (_command == "VISUAL_WIND_HIGH")
	{
	    visual_test = "WIND HIGH";

	    debug_wind_override = true;
	    debug_wind_strength = 80;
	}


	if (_command == "VISUAL_LEAF")
	{
	    visual_test = "LEAF";

	    if (instance_exists(obj_particle_system))
	    {
	        particle_emit(
	            camera_get_view_x(view_camera[0]) +
	            camera_get_view_width(view_camera[0]) * 0.5,

	            camera_get_view_y(view_camera[0]) +
	            camera_get_view_height(view_camera[0]) * 0.5,

	            obj_particle_system.PARTICLE_LEAF,
	            10
	        );
	    }
	}


	if (_command == "VISUAL_DUST")
	{
	    visual_test = "DUST";

	    if (instance_exists(obj_particle_system))
	    {
	        particle_emit(
	            camera_get_view_x(view_camera[0]) +
	            camera_get_view_width(view_camera[0]) * 0.5,

	            camera_get_view_y(view_camera[0]) +
	            camera_get_view_height(view_camera[0]) * 0.5,

	            obj_particle_system.PARTICLE_DUST,
	            15
	        );
	    }
	}


	if (_command == "VISUAL_SPARK")
	{
	    visual_test = "SPARK";

	    if (instance_exists(obj_particle_system))
	    {
	        particle_emit(
	            camera_get_view_x(view_camera[0]) +
	            camera_get_view_width(view_camera[0]) * 0.5,

	            camera_get_view_y(view_camera[0]) +
	            camera_get_view_height(view_camera[0]) * 0.5,

	            obj_particle_system.PARTICLE_SPARK,
	            15
	        );
	    }
	}


	if (_command == "VISUAL_SMOKE")
	{
	    visual_test = "SMOKE";

	    if (instance_exists(obj_particle_system))
	    {
	        particle_emit(
	            camera_get_view_x(view_camera[0]) +
	            camera_get_view_width(view_camera[0]) * 0.5,

	            camera_get_view_y(view_camera[0]) +
	            camera_get_view_height(view_camera[0]) * 0.5,

	            obj_particle_system.PARTICLE_SMOKE,
	            8
	        );
	    }
	}


	if (_command == "VISUAL_RESET")
	{
	    visual_test = "NONE";

	    debug_wind_override = false;
	    debug_wind_strength = 0;

	    if (instance_exists(obj_weather_manager))
	    {
	        obj_weather_manager.fog_on = false;
	        obj_weather_manager.fog_left = 0;

	        obj_weather_manager.weather_set_target(
	            obj_weather_manager.WEATHER_CLEAR,
	            "DEBUG_RESET"
	        );

	        obj_weather_manager.weather_auto = false;
	    }
	}
};