function scr_save_settings(){
    if (!instance_exists(obj_menu)) exit;

    ini_open("settings.ini");
    
    // Acessando as grids do seu obj_menu
    var g_audio = obj_menu.ds_menu_audio;
    var g_video = obj_menu.ds_menu_graphics;
    
    // Salvando os valores da coluna index 3 (onde ficam os valores reais)
    ini_write_real("Audio", "Master", g_audio[# 3, 0]);
    ini_write_real("Audio", "Sounds", g_audio[# 3, 1]);
    ini_write_real("Audio", "Music",  g_audio[# 3, 2]);
    
    ini_write_real("Graphics", "Resolution", g_video[# 3, 0]);
    ini_write_real("Graphics", "WindowMode", g_video[# 3, 1]);
    
    ini_close();
    show_debug_message("Configurações Salvas!");
}