global.menu_mode = "main";
global.pause = false;

if (!instance_exists(obj_game_controller)) instance_create_depth(0, 0, -10000000, obj_game_controller);



var prev = room_previous;
if (is_undefined(prev) || prev < 0) {
    show_debug_message("Veio de: (primeira room / sem previous)");
} else {
    show_debug_message("Veio de: " + room_get_name(prev));
}
