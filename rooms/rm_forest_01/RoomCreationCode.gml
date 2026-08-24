show_debug_message("ENTROU NA ROOM DO JOGO (room=" + room_get_name(room) + ")");
if (!instance_exists(obj_game_controller)) instance_create_depth(0, 0, -10000000, obj_game_controller);
global.just_resumed = false;
