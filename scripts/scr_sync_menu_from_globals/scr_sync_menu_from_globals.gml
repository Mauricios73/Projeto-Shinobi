function scr_sync_menu_from_globals() {
    if (!instance_exists(obj_menu)) return;

    // garante defaults caso load ainda não tenha rodado
    if (!variable_global_exists("vol_master")) global.vol_master = 1;
    if (!variable_global_exists("vol_sounds")) global.vol_sounds = 1;
    if (!variable_global_exists("vol_music"))  global.vol_music  = 1;

    if (!variable_global_exists("resolution_index")) global.resolution_index = 2;
    if (!variable_global_exists("window_mode"))      global.window_mode      = 1;

    if (!variable_global_exists("key_up"))    global.key_up    = vk_up;
    if (!variable_global_exists("key_down"))  global.key_down  = vk_down;
    if (!variable_global_exists("key_left"))  global.key_left  = vk_left;
    if (!variable_global_exists("key_right")) global.key_right = vk_right;

    // audio
    obj_menu.ds_menu_audio[# 3, 0] = global.vol_master;
    obj_menu.ds_menu_audio[# 3, 1] = global.vol_sounds;
    obj_menu.ds_menu_audio[# 3, 2] = global.vol_music;

    // graphics
    obj_menu.ds_menu_graphics[# 3, 0] = global.resolution_index;
    obj_menu.ds_menu_graphics[# 3, 1] = global.window_mode;

    // controls
    obj_menu.ds_menu_controls[# 3, 0] = global.key_up;
    obj_menu.ds_menu_controls[# 3, 1] = global.key_left;
    obj_menu.ds_menu_controls[# 3, 2] = global.key_right;
    obj_menu.ds_menu_controls[# 3, 3] = global.key_down;
}
