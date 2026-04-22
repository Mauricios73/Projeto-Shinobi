draw_set_font(fnt_asian_ninja);

// View/GUI (safe)
global.view_width  = camera_get_view_width(view_camera[0]);
global.view_height = camera_get_view_height(view_camera[0]);
display_set_gui_size(global.view_width, global.view_height);

// --------------------------
// DEFAULT BINDS (only if missing)
// --------------------------
if (!variable_global_exists("key_up"))      global.key_up      = ord("W");
if (!variable_global_exists("key_down"))    global.key_down    = ord("S");
if (!variable_global_exists("key_left"))    global.key_left    = ord("A");
if (!variable_global_exists("key_right"))   global.key_right   = ord("D");
if (!variable_global_exists("key_enter"))   global.key_enter   = vk_enter;
if (!variable_global_exists("key_revert"))  global.key_revert  = ord("X");

// gameplay binds
if (!variable_global_exists("key_fire"))    global.key_fire    = ord("F");
if (!variable_global_exists("key_chakra"))  global.key_chakra  = ord("R");
if (!variable_global_exists("key_dash"))    global.key_dash    = ord("L");
if (!variable_global_exists("key_chidori")) global.key_chidori = ord("J");
if (!variable_global_exists("key_ataque"))  global.key_ataque  = ord("K");
if (!variable_global_exists("key_defend"))  global.key_defesa  = ord("U");

// pause bind usually set by obj_pause, but keep fallback
if (!variable_global_exists("key_pause"))   global.key_pause   = vk_escape;

// --------------------------
// MENU ENUMS
// --------------------------
enum menu_page {
    main,
    settings,
    audio,
    difficulty,
    graphics,
    controls,
    height
}

enum menu_element_type {
    script_runner,
    page_transfer,
    slider,
    shift,
    toggle,
    input
}

// --------------------------
// LOCAL FUNCTION REFS (robust on older runtimes)
// --------------------------
fn_start_game = function() {
    global.pause = false;
    room_goto(Room1);
};

fn_exit_game = function() {
    game_end();
};

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

fn_change_resolution = function(idx) {
    global.resolution_index = idx;
    switch (idx) {
        case 0: window_set_size(640, 360); break;
        case 1: window_set_size(854, 480); break;
        case 2: window_set_size(1280, 720); break;
        case 3: window_set_size(1440, 900); break;
        case 4: window_set_size(1920, 1080); break;
    }
};

fn_change_window_mode = function(mode) {
    global.window_mode = mode;
    switch (mode) {
        case 0: window_set_fullscreen(true); break;
        case 1: window_set_fullscreen(false); break;
    }
};

// which: 0=enemies, 1=allies
fn_change_difficulty = function(value, which) {
    if (which == 0) global.difficulty_enemies = value;
    else           global.difficulty_allies  = value;
};

// --------------------------
// PAGES
// --------------------------
ds_menu_main = create_menu_page(
    ["PLAY",     menu_element_type.script_runner, fn_start_game],
    ["SETTINGS", menu_element_type.page_transfer, menu_page.settings],
    ["EXIT",     menu_element_type.script_runner, fn_exit_game]
);

ds_settings = create_menu_page(
    ["AUDIO",      menu_element_type.page_transfer, menu_page.audio],
    ["DIFFICULTY", menu_element_type.page_transfer, menu_page.difficulty],
    ["GRAPHICS",   menu_element_type.page_transfer, menu_page.graphics],
    ["CONTROLS",   menu_element_type.page_transfer, menu_page.controls],
    ["BACK",       menu_element_type.page_transfer, menu_page.main]
);

ds_menu_audio = create_menu_page(
    ["MASTER", menu_element_type.slider, fn_change_volume, 1, [0,1], 0],
    ["SOUNDS", menu_element_type.slider, fn_change_volume, 1, [0,1], 1],
    ["MUSIC",  menu_element_type.slider, fn_change_volume, 1, [0,1], 2],
    ["BACK",   menu_element_type.page_transfer, menu_page.settings]
);

// Difficulty may be unimplemented; keep entries but they won't crash with menu exec guards in Step
ds_menu_difficulty = create_menu_page(
    ["ENEMIES", menu_element_type.shift, fn_change_difficulty, 0, ["HARMLESS","NORMAL","TERRIBLE"], 0],
    ["ALLIES",  menu_element_type.shift, fn_change_difficulty, 0, ["DIM-WITTED","NORMAL","HELPFUL"], 1],
    ["BACK",    menu_element_type.page_transfer, menu_page.settings]
);

ds_menu_graphics = create_menu_page(
    ["RESOLUTION", menu_element_type.shift,  fn_change_resolution, 0, ["640 x 360","854 x 480","1280 x 720","1440 x 900","1920 x 1080"]],
    ["WINDOW MODE",menu_element_type.toggle, fn_change_window_mode, 1, ["FULLSCREEN","WINDOWED"]],
    ["BACK",       menu_element_type.page_transfer, menu_page.settings]
);

// --------------------------
// CONTROLS (A.1) — expanded binds
// input rows: [Label, input_type, global_field_name, default_value]
// --------------------------
ds_menu_controls = create_menu_page(
    ["UP",      menu_element_type.input, "key_up",      global.key_up],
    ["DOWN",    menu_element_type.input, "key_down",    global.key_down],
    ["LEFT",    menu_element_type.input, "key_left",    global.key_left],
    ["RIGHT",   menu_element_type.input, "key_right",   global.key_right],
    ["ENTER",   menu_element_type.input, "key_enter",   global.key_enter],
    ["REVERT",  menu_element_type.input, "key_revert",  global.key_revert],

    ["ATTACK",  menu_element_type.input, "key_ataque",  global.key_ataque],
    ["DASH",    menu_element_type.input, "key_dash",    global.key_dash],
    ["CHIDORI", menu_element_type.input, "key_chidori", global.key_chidori],
    ["FIRE",    menu_element_type.input, "key_fire",    global.key_fire],
    ["CHAKRA",  menu_element_type.input, "key_chakra",  global.key_chakra],
    ["PAUSE",   menu_element_type.input, "key_pause",   global.key_pause],

    ["BACK",    menu_element_type.page_transfer, menu_page.settings]
);

// --------------------------
// RUNTIME STATE
// --------------------------
page = menu_page.main;
menu_pages = [ds_menu_main, ds_settings, ds_menu_audio, ds_menu_difficulty, ds_menu_graphics, ds_menu_controls];

// selection per page
menu_option = array_create(array_length(menu_pages), 0);

inputting = false;

// debounce save state
menu_dirty = false;
menu_dirty_timer = 0;

// Make sure menu values reflect loaded globals (safe script)
scr_sync_menu_from_globals();

// audio groups are loaded by obj_game_controller
