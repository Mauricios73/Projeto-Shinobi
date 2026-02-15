function start_game() {
    global.pause = false;

    // se o menu rm_menu não for overlay, só troca de room
    room_goto(Room1);
}