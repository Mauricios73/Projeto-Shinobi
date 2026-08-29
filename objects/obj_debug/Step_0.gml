/// obj_debug - Step
if (!debug_enabled) exit;

// Todos os atalhos de teste ficam centralizados aqui.
if (keyboard_check_pressed(vk_f5)) show_overlay = !show_overlay;
if (keyboard_check_pressed(vk_f6)) page = (page + page_count - 1) mod page_count;
if (keyboard_check_pressed(vk_f7)) page = (page + 1) mod page_count;

if (keyboard_check_pressed(vk_f1)) debug_command("TIME_PAUSE");
if (keyboard_check_pressed(vk_f2)) debug_command("TIME_HOUR_PLUS");
if (keyboard_check_pressed(vk_f3)) debug_command("TIME_HOUR_MINUS");
if (keyboard_check_pressed(vk_f4)) debug_command("TIME_SPEED");

if (keyboard_check_pressed(vk_f8)) debug_command("WEATHER_CLEAR");
if (keyboard_check_pressed(vk_f9)) debug_command("WEATHER_RAIN");
if (keyboard_check_pressed(vk_f10)) debug_command("WEATHER_STORM");
if (keyboard_check_pressed(vk_f11)) debug_command("WEATHER_NEXT");
if (keyboard_check_pressed(vk_f12)) debug_command("WEATHER_AUTO");
if (keyboard_check_pressed(ord("A"))) debug_command("AUDIO_EVENT");

if (keyboard_check_pressed(ord("F"))) key_help = !key_help;

global.debug.enabled = debug_enabled;
global.debug.show = show_overlay;
global.debug.page = page;
global.debug.last_command = global.debug.last_command;
