function scr_pause_open() {
    if (global.pause) return;

    global.pause = true;
    global.menu_mode = "pause";

    if (variable_global_exists("pause_surface") && surface_exists(global.pause_surface))
    {
        surface_free(global.pause_surface);
    }

    global.pause_surface = -1;

    if (surface_exists(application_surface))
    {
        var sw = surface_get_width(application_surface);
        var sh = surface_get_height(application_surface);

        global.pause_surface = surface_create(sw, sh);
        surface_set_target(global.pause_surface);
        draw_clear_alpha(c_black, 0);
        draw_surface(application_surface, 0, 0);
        surface_reset_target();
    }

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
