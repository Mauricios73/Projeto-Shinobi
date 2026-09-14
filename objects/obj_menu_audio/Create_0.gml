/// obj_menu_audio - Create
/// Atmosfera sonora do menu.

persistent = true;

rain_handle = -1;
rain_forest_handle = -1;
wind_handle = -1;
music_handle = -1;

wind_gust_timer = random_range(8, 16);

menu_audio_active = true;
menu_fading_out = false;
menu_fade_timer = 0;

rain_volume = 0.22;
rain_forest_volume = 0.10;
wind_volume = 0.075;
music_volume = 0.14;

snd_rain_id = asset_get_index("snd_rain");
snd_rain_forest_id = asset_get_index("snd_rain_forest");

snd_wind_1_id = asset_get_index("snd_wind_1");
snd_wind_2_id = asset_get_index("snd_wind_2");
snd_wind_3_id = asset_get_index("snd_wind_3");

snd_music_id = asset_get_index("snd_lotus_pond");

snd_ui_move = asset_get_index("snd_passo");
snd_ui_confirm = asset_get_index("snd_gulp");
snd_ui_back = asset_get_index("snd_passo");

//// ------------------------------------------------------------
//// MUSIC
//// ------------------------------------------------------------
//if (snd_music_id != -1)
//{
//    music_handle = audio_play_sound(snd_music_id, 1, true);

//    if (music_handle != -1)
//    {
//        var music_gain = music_volume;

//        if (variable_global_exists("vol_music"))
//            music_gain *= global.vol_music;

//        audio_sound_gain(
//            music_handle,
//            clamp(music_gain, 0, 1),
//            900
//        );
//    }
//}

// ------------------------------------------------------------
// RAIN
// ------------------------------------------------------------
//if (snd_rain_id != -1)
//{
//    rain_handle = audio_play_sound(snd_rain_id, 0, true);

//    if (rain_handle != -1)
//    {
//        var gain_rain = rain_volume;

//        if (variable_global_exists("vol_sounds"))
//            gain_rain *= global.vol_sounds;

//        audio_sound_gain(
//            rain_handle,
//            clamp(gain_rain, 0, 1),
//            1000
//        );
//    }
//}

if (snd_rain_forest_id != -1)
{
    rain_forest_handle = audio_play_sound(snd_rain_forest_id, 0, true);

    if (rain_forest_handle != -1)
    {
        var gain_forest = rain_forest_volume;

        if (variable_global_exists("vol_sounds"))
            gain_forest *= global.vol_sounds;

        audio_sound_gain(
            rain_forest_handle,
            clamp(gain_forest, 0, 1),
            1200
        );
    }
}

// ------------------------------------------------------------
// WIND
// ------------------------------------------------------------
if (snd_wind_1_id != -1)
{
    wind_handle = audio_play_sound(snd_wind_1_id, 2, true);

    if (wind_handle != -1)
    {
        var gain_wind = wind_volume;

        if (variable_global_exists("vol_sounds"))
            gain_wind *= global.vol_sounds;

        audio_sound_gain(
            wind_handle,
            clamp(gain_wind, 0, 1),
            1200
        );
    }
}

// ------------------------------------------------------------
// FUNCOES PUBLICAS PARA O OBJ_MENU
// ------------------------------------------------------------
menu_ui_play = function(_kind)
{
    var snd = -1;

    switch (_kind)
    {
        case "move":
            snd = snd_ui_move;
        break;

        case "confirm":
            snd = snd_ui_confirm;
        break;

        case "back":
            snd = snd_ui_back;
        break;
    }

    if (snd == -1)
        return;

    var h = audio_play_sound(snd, 10, false);

    if (h != -1)
    {
        var gain = 0.10;

        if (variable_global_exists("vol_sounds"))
            gain *= global.vol_sounds;

        audio_sound_gain(h, gain, 0);
    }
};
