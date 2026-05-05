fn_change_volume = function(value, type) {
    switch (type) {
        case 0:
            global.vol_master = value;
            audio_master_gain(value);
            break;
        case 1:
            global.vol_sounds = value;
            audio_group_set_gain(audiogroup_soundeffects, value, 0);
            break;
        case 2:
            global.vol_music = value;
            audio_group_set_gain(audiogroup_music, value, 0);
            break;
    }
};