function scr_load_settings()
{
    // Defaults (first run safe)
    if (!variable_global_exists("vol_master")) global.vol_master = 1;
    if (!variable_global_exists("vol_sounds")) global.vol_sounds = 1;
    if (!variable_global_exists("vol_music"))  global.vol_music  = 1;

    if (!variable_global_exists("resolution_index")) global.resolution_index = 2; // 720p
    if (!variable_global_exists("window_mode"))      global.window_mode      = 1; // windowed

    if (!variable_global_exists("difficulty_enemies")) global.difficulty_enemies = 1;
    if (!variable_global_exists("difficulty_allies"))  global.difficulty_allies  = 1;

    if (!variable_global_exists("key_up"))     global.key_up     = vk_up;
    if (!variable_global_exists("key_down"))   global.key_down   = vk_down;
    if (!variable_global_exists("key_left"))   global.key_left   = vk_left;
    if (!variable_global_exists("key_right"))  global.key_right  = vk_right;
    if (!variable_global_exists("key_enter"))  global.key_enter  = vk_enter;
    if (!variable_global_exists("key_revert")) global.key_revert = ord("X");

    if (!variable_global_exists("key_fire"))    global.key_fire    = ord("F");
    if (!variable_global_exists("key_chakra"))  global.key_chakra  = ord("R");
    if (!variable_global_exists("key_dash"))    global.key_dash    = ord("L");
    if (!variable_global_exists("key_chidori")) global.key_chidori = ord("J");
    if (!variable_global_exists("key_ataque"))  global.key_ataque  = ord("K");
    if (!variable_global_exists("key_pause"))   global.key_pause   = vk_escape;

    // Load INI
    if (file_exists("settings.ini"))
    {
        ini_open("settings.ini");

        global.vol_master = ini_read_real("Audio", "Master", global.vol_master);
        global.vol_sounds = ini_read_real("Audio", "Sounds", global.vol_sounds);
        global.vol_music  = ini_read_real("Audio", "Music",  global.vol_music);

        global.resolution_index = ini_read_real("Graphics", "Resolution", global.resolution_index);
        global.window_mode      = ini_read_real("Graphics", "WindowMode", global.window_mode);

        global.difficulty_enemies = ini_read_real("Difficulty", "Enemies", global.difficulty_enemies);
        global.difficulty_allies  = ini_read_real("Difficulty", "Allies",  global.difficulty_allies);

        global.key_up     = ini_read_real("Controls", "Up",     global.key_up);
        global.key_down   = ini_read_real("Controls", "Down",   global.key_down);
        global.key_left   = ini_read_real("Controls", "Left",   global.key_left);
        global.key_right  = ini_read_real("Controls", "Right",  global.key_right);
        global.key_enter  = ini_read_real("Controls", "Enter",  global.key_enter);
        global.key_revert = ini_read_real("Controls", "Revert", global.key_revert);

        global.key_ataque  = ini_read_real("Controls", "Attack", global.key_ataque);
        global.key_dash    = ini_read_real("Controls", "Dash",   global.key_dash);
        global.key_chidori = ini_read_real("Controls", "Chidori",global.key_chidori);
        global.key_fire    = ini_read_real("Controls", "Fire",   global.key_fire);
        global.key_chakra  = ini_read_real("Controls", "Chakra", global.key_chakra);
        global.key_pause   = ini_read_real("Controls", "Pause",  global.key_pause);

        ini_close();
    }

    // Apply audio
    audio_master_gain(global.vol_master);
    audio_group_set_gain(audiogroup_soundeffects, global.vol_sounds, 0);
    audio_group_set_gain(audiogroup_music, global.vol_music, 0);

    // Apply video directly
    switch (global.resolution_index)
    {
        case 0: window_set_size(640, 360); break;
        case 1: window_set_size(854, 480); break;
        case 2: window_set_size(1280, 720); break;
        case 3: window_set_size(1440, 900); break;
        case 4: window_set_size(1920, 1080); break;
    }
    window_set_fullscreen(global.window_mode == 0);

    // Apply difficulty multipliers now
    change_difficulty(global.difficulty_enemies, 0);
    change_difficulty(global.difficulty_allies,  1);
}
