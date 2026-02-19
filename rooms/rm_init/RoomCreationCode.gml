show_debug_message("ENTROU NO RM_INIT (room=" + room_get_name(room) + ")");

// aqui você pode criar objetos persistentes se precisar
if (!instance_exists(obj_pause)) instance_create_layer(0, 0, "Instances", obj_pause);
// se tiver controller/settings:
if (!instance_exists(obj_game_controller)) instance_create_layer(0, 0, "Instances", obj_game_controller);

//room_goto(rm_menu);
