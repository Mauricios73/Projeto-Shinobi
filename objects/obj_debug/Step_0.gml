if (!debug_enabled) exit;

// Alternar Interface
if (keyboard_check_pressed(vk_f5)) show_overlay = !show_overlay;

if (show_overlay)
{
    // Navegação de páginas
    if (keyboard_check_pressed(vk_f6)) page = (page + page_count - 1) mod page_count;
    if (keyboard_check_pressed(vk_f7)) page = (page + 1) mod page_count;
}

// Atalhos de Tempo (F1 a F4)
if (keyboard_check_pressed(vk_f1)) debug_command("TIME_PAUSE");
if (keyboard_check_pressed(vk_f2)) debug_command("TIME_HOUR_PLUS");
if (keyboard_check_pressed(vk_f3)) debug_command("TIME_HOUR_MINUS");
if (keyboard_check_pressed(vk_f4)) debug_command("TIME_SPEED");

// Atalhos de Clima (F8 a F12)
if (keyboard_check_pressed(vk_f8)) debug_command("WEATHER_CLEAR");
if (keyboard_check_pressed(vk_f9)) debug_command("WEATHER_RAIN");
if (keyboard_check_pressed(vk_f10)) debug_command("WEATHER_STORM");
if (keyboard_check_pressed(vk_f11)) debug_command("WEATHER_NEXT");
if (keyboard_check_pressed(vk_f12)) debug_command("WEATHER_AUTO");

// Evento Manual
if (keyboard_check_pressed(ord("A"))) debug_command("AUDIO_EVENT");

global.debug_data.show = show_overlay;
global.debug_data.page = page;