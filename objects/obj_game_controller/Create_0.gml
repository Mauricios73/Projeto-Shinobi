persistent = true;

if (instance_number(obj_game_controller) > 1)
{
    instance_destroy();
    exit;
}

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

var rn_create = room_get_name(room);
if (rn_create == "rm_init" || rn_create == "rm_menu")
{
    global.menu_mode = "main";
}
else
{
    global.menu_mode = "game";
}

game_over = false;
game_over_alpha = 0;

valor = 0;
contador = 0;

is_menu_room = function()
{
    var rn = room_get_name(room);
    return (rn == "rm_init" || rn == "rm_menu");
}

ensure_global_controllers = function()
{
    if (!instance_exists(obj_pause)) instance_create_depth(0, 0, 0, obj_pause);
    if (!instance_exists(obj_input)) instance_create_depth(0, 0, -999999, obj_input);
    if (!instance_exists(obj_weather_manager)) instance_create_depth(0, 0, -10000000, obj_weather_manager);
}

sync_room_services = function()
{
    if (is_menu_room())
    {
        if (instance_exists(obj_hud)) with (obj_hud) instance_destroy();
        if (instance_exists(obj_musica)) with (obj_musica) instance_destroy();
        if (instance_exists(obj_ambiente)) with (obj_ambiente) instance_destroy();
        return;
    }

    if (!instance_exists(obj_hud)) instance_create_depth(0, 0, -999998, obj_hud);
    if (!instance_exists(obj_musica)) instance_create_depth(0, 0, -999997, obj_musica);
    if (!instance_exists(obj_ambiente)) instance_create_depth(0, 0, -999996, obj_ambiente);
}

restart_current_room = function()
{
    game_over = false;
    game_over_alpha = 0;
    global.game_over = false;
    global.vel_mult = 1;
    global.pause = false;
    global.menu_mode = "game";
    global.pause_lock_frames = 10;

    instance_activate_all();

    if (variable_global_exists("pause_surface") && surface_exists(global.pause_surface))
    {
        surface_free(global.pause_surface);
        global.pause_surface = -1;
    }

    if (instance_exists(obj_menu)) with (obj_menu) instance_destroy();
    if (instance_exists(obj_dano)) with (obj_dano) instance_destroy();
    if (instance_exists(obj_hitbox)) with (obj_hitbox) instance_destroy();
    if (instance_exists(obj_skill_fire_breath)) with (obj_skill_fire_breath) instance_destroy();
    if (instance_exists(obj_ally)) with (obj_ally) instance_destroy();
    if (instance_exists(obj_camera)) with (obj_camera) instance_destroy();
    if (instance_exists(obj_player)) with (obj_player) instance_destroy();

    room_restart();
}

ensure_global_controllers();
sync_room_services();
