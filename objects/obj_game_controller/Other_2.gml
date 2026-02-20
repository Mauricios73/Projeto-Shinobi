//game_over = false;
//valor = 0;
//contador = 0;
//global.vel_mult = 1; // Reseta a velocidade do jogo

// Só cria se não existir nenhum obj_weather
//if (instance_number(obj_weather_manager) == 0)
//{
//    var wth = instance_create_depth(0, 0, -10000000, obj_weather_manager);
//    wth.persistent = true; // opcional (se quiser manter entre rooms)
//    show_debug_message("CRIOU OBJ_WEATHER (room=" + room_get_name(room) + ")");
//}

if (room == Room1) {
    if (!instance_exists(obj_lake_v2)) instance_create_depth(0, 0, 0, obj_lake_v2);
} else {
    with (obj_lake_v2) instance_destroy();
}
