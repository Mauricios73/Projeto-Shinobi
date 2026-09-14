/// obj_menu_audio - Clean Up

if (audio_is_playing(rain_handle))
    audio_stop_sound(rain_handle);

if (audio_is_playing(rain_forest_handle))
    audio_stop_sound(rain_forest_handle);

if (audio_is_playing(wind_handle))
    audio_stop_sound(wind_handle);

if (audio_is_playing(music_handle))
    audio_stop_sound(music_handle);
