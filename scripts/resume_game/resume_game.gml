/*function resume_game() {
    show_debug_message("resume game (room atual=" + room_get_name(room) + ")");
    global.pause = false;

    // fecha o menu (evita ele ficar rodando e reabrir pause)
    if (instance_exists(obj_menu)) instance_destroy(obj_menu);

    // vá para a room real do jogo:
    room_goto(Room1); // EXEMPLO: use o nome real, tipo rm_fase1 / rm_game etc.
}*/
function resume_game() {
    scr_pause_close();
}
