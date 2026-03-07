///@description Load audiogroups once (safe to call multiple times)
if (!variable_global_exists("audio_groups_loaded")) global.audio_groups_loaded = false;
if (global.audio_groups_loaded) exit;

audio_group_load(audiogroup_music);
audio_group_load(audiogroup_soundeffects);

global.audio_groups_loaded = true;
