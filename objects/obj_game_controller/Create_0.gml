persistent = true;

if (!variable_global_exists("debug")) global.debug = false;

// settings
scr_load_settings();

// audio groups once
if (!variable_global_exists("audio_groups_loaded")) global.audio_groups_loaded = false;
if (!global.audio_groups_loaded) {
    audio_group_load(audiogroup_music);
    audio_group_load(audiogroup_soundeffects);
    global.audio_groups_loaded = true;
}

application_surface_enable(true);

global.vel_mult = 1;
global.pause = false;
global.game_over = false;

game_over = false;

valor = 0;
contador = 0;

// garante ambiente
if (!instance_exists(obj_ambiente)) instance_create_depth(0, 0, 0, obj_ambiente);
