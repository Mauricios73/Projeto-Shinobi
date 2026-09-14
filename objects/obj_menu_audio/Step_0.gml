/// obj_menu_audio - Step

var rn = room_get_name(room);

if (rn != "rm_menu")
{
    if (!menu_fading_out)
    {
        menu_fading_out = true;
        menu_fade_timer = room_speed * 0.35;
    }

    var fade_t = clamp(menu_fade_timer / max(1, room_speed * 0.35), 0, 1);

    if (audio_is_playing(rain_handle))
        audio_sound_gain(rain_handle, rain_volume * fade_t, 0);

    if (audio_is_playing(rain_forest_handle))
        audio_sound_gain(rain_forest_handle, rain_forest_volume * fade_t, 0);

    if (audio_is_playing(wind_handle))
        audio_sound_gain(wind_handle, wind_volume * fade_t, 0);

    if (audio_is_playing(music_handle))
        audio_sound_gain(music_handle, music_volume * fade_t, 0);

    menu_fade_timer -= 1;

    if (menu_fade_timer <= 0)
    {
        if (audio_is_playing(rain_handle)) audio_stop_sound(rain_handle);
        if (audio_is_playing(rain_forest_handle)) audio_stop_sound(rain_forest_handle);
        if (audio_is_playing(wind_handle)) audio_stop_sound(wind_handle);
        if (audio_is_playing(music_handle)) audio_stop_sound(music_handle);

        instance_destroy();
    }

    exit;
}

// ------------------------------------------------------------
// GUSTOS DE VENTO
// ------------------------------------------------------------
wind_gust_timer -= 1 / room_speed;

if (wind_gust_timer <= 0)
{
    wind_gust_timer = random_range(10, 20);

    var gust_snd = snd_wind_2_id;

    if (irandom(1) == 1)
        gust_snd = snd_wind_3_id;

    if (gust_snd != -1)
    {
        var h = audio_play_sound(gust_snd, 3, false);

        if (h != -1)
        {
            var gust_gain = random_range(0.045, 0.085);

            if (variable_global_exists("vol_sounds"))
                gust_gain *= global.vol_sounds;

            audio_sound_gain(h, gust_gain, 350);
        }
    }
}

// ------------------------------------------------------------
// VOLUME DINAMICO
// ------------------------------------------------------------
var sound_gain = 1;

if (variable_global_exists("vol_sounds"))
    sound_gain = global.vol_sounds;

if (audio_is_playing(rain_handle))
    audio_sound_gain(rain_handle, rain_volume * sound_gain, 250);

if (audio_is_playing(rain_forest_handle))
    audio_sound_gain(rain_forest_handle, rain_forest_volume * sound_gain, 250);

if (audio_is_playing(wind_handle))
    audio_sound_gain(wind_handle, wind_volume * sound_gain, 250);

//var music_gain = 1;

//if (variable_global_exists("vol_music"))
//    music_gain = global.vol_music;

//if (audio_is_playing(music_handle))
//    audio_sound_gain(music_handle, music_volume * music_gain, 250);
