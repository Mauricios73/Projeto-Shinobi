function scr_sync_menu_from_globals()
{
    var m = instance_find(obj_menu, 0);
    if (m == noone) return;

    // defaults
    if (!variable_global_exists("vol_master")) global.vol_master = 1;
    if (!variable_global_exists("vol_sounds")) global.vol_sounds = 1;
    if (!variable_global_exists("vol_music"))  global.vol_music  = 1;
    if (!variable_global_exists("resolution_index")) global.resolution_index = 2;
    if (!variable_global_exists("window_mode"))      global.window_mode      = 1;
    if (!variable_global_exists("difficulty_enemies")) global.difficulty_enemies = 1;
    if (!variable_global_exists("difficulty_allies"))  global.difficulty_allies  = 1;

    // audio
    if (variable_instance_exists(m, "ds_menu_audio"))
    {
        m.ds_menu_audio[# 3, 0] = global.vol_master;
        m.ds_menu_audio[# 3, 1] = global.vol_sounds;
        m.ds_menu_audio[# 3, 2] = global.vol_music;
    }

    // graphics
    if (variable_instance_exists(m, "ds_menu_graphics"))
    {
        m.ds_menu_graphics[# 3, 0] = global.resolution_index;
        m.ds_menu_graphics[# 3, 1] = global.window_mode;
    }

    // difficulty (se existir)
    if (variable_instance_exists(m, "ds_menu_difficulty"))
    {
        m.ds_menu_difficulty[# 3, 0] = global.difficulty_enemies;
        m.ds_menu_difficulty[# 3, 1] = global.difficulty_allies;
    }
}
