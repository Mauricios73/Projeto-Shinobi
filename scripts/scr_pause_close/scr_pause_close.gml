function scr_pause_close() {
    if (!global.pause) return;

    global.pause = false;
    global.menu_mode = "game";

    // fecha menu
    if (instance_exists(obj_menu)) instance_destroy(obj_menu);

    // reativa geral
    instance_activate_all();

    // garante persistentes
    instance_activate_object(obj_pause);
    if (object_exists(obj_musica)) instance_activate_object(obj_musica);

    // lock anti "tecla vazando"
    global.pause_lock_frames = 8;
}
