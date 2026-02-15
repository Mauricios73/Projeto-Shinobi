function scr_pause_open() {
    if (global.pause) return;

    global.pause = true;
    global.menu_mode = "pause";

    if (!instance_exists(obj_menu)) {
        var lyr = layer_get_id("GUI");
        if (lyr == -1) lyr = layer_get_id("Instances");
        if (lyr == -1) instance_create_layer(x, y, layer, obj_menu);
        else           instance_create_layer(0, 0, lyr, obj_menu);
    }

    instance_deactivate_all(true);

    instance_activate_object(obj_pause);
    instance_activate_object(obj_menu);
    if (object_exists(obj_musica)) instance_activate_object(obj_musica);

    global.pause_lock_frames = 8;
}
