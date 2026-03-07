function scr_save_settings()
{
    // garante defaults
    if (!variable_global_exists("vol_master")) global.vol_master = 1;
    if (!variable_global_exists("vol_sounds")) global.vol_sounds = 1;
    if (!variable_global_exists("vol_music"))  global.vol_music  = 1;

    if (!variable_global_exists("resolution_index")) global.resolution_index = 2;
    if (!variable_global_exists("window_mode"))      global.window_mode      = 1;

    if (!variable_global_exists("difficulty_enemies")) global.difficulty_enemies = 1;
    if (!variable_global_exists("difficulty_allies"))  global.difficulty_allies  = 1;

    ini_open("settings.ini");

    // audio
    ini_write_real("Audio", "Master", global.vol_master);
    ini_write_real("Audio", "Sounds", global.vol_sounds);
    ini_write_real("Audio", "Music",  global.vol_music);

    // graphics
    ini_write_real("Graphics", "Resolution", global.resolution_index);
    ini_write_real("Graphics", "WindowMode", global.window_mode);

    // difficulty
    ini_write_real("Difficulty", "Enemies", global.difficulty_enemies);
    ini_write_real("Difficulty", "Allies",  global.difficulty_allies);

    // controls (se existirem)
    if (variable_global_exists("key_up"))     ini_write_real("Controls", "Up",     global.key_up);
    if (variable_global_exists("key_down"))   ini_write_real("Controls", "Down",   global.key_down);
    if (variable_global_exists("key_left"))   ini_write_real("Controls", "Left",   global.key_left);
    if (variable_global_exists("key_right"))  ini_write_real("Controls", "Right",  global.key_right);
    if (variable_global_exists("key_enter"))  ini_write_real("Controls", "Enter",  global.key_enter);
    if (variable_global_exists("key_revert")) ini_write_real("Controls", "Revert", global.key_revert);

    if (variable_global_exists("key_ataque"))  ini_write_real("Controls", "Attack", global.key_ataque);
    if (variable_global_exists("key_dash"))    ini_write_real("Controls", "Dash",   global.key_dash);
    if (variable_global_exists("key_chidori")) ini_write_real("Controls", "Chidori",global.key_chidori);
    if (variable_global_exists("key_fire"))    ini_write_real("Controls", "Fire",   global.key_fire);
    if (variable_global_exists("key_chakra"))  ini_write_real("Controls", "Chakra", global.key_chakra);
    if (variable_global_exists("key_pause"))   ini_write_real("Controls", "Pause",  global.key_pause);

    ini_close();

    if (variable_global_exists("debug") && global.debug)
        show_debug_message("Configurações Salvas!");
}
