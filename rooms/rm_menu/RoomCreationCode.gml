global.menu_mode = "main";
global.pause = false;



var prev = room_previous;
if (is_undefined(prev) || prev < 0) {
    show_debug_message("Veio de: (primeira room / sem previous)");
} else {
    show_debug_message("Veio de: " + room_get_name(prev));
}
