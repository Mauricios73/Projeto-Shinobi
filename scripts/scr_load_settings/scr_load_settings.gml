function scr_load_settings(){
    if (file_exists("settings.ini")){
        ini_open("settings.ini");
        
        var _mstr = ini_read_real("Audio", "Master", 1);
        var _snd  = ini_read_real("Audio", "Sounds", 1);
        var _mus  = ini_read_real("Audio", "Music", 1);
        var _res  = ini_read_real("Graphics", "Resolution", 2); // Padrão 720p
        var _win  = ini_read_real("Graphics", "WindowMode", 1);
        
        // Aplica os volumes usando sua lógica de Audio Groups
        audio_master_gain(_mstr);
        audio_group_set_gain(audiogroup_soundeffects, _snd, 0);
        audio_group_set_gain(audiogroup_music, _mus, 0);
        
        // Aplica Vídeo
        change_resolution(_res);
        change_window_mode(_win);
        
        // Sincroniza as variáveis do obj_menu se ele existir
        if (instance_exists(obj_menu)){
            obj_menu.ds_menu_audio[# 3, 0] = _mstr;
            obj_menu.ds_menu_audio[# 3, 1] = _snd;
            obj_menu.ds_menu_audio[# 3, 2] = _mus;
            obj_menu.ds_menu_graphics[# 3, 0] = _res;
            obj_menu.ds_menu_graphics[# 3, 1] = _win;
        }
        
        ini_close();
    }
}