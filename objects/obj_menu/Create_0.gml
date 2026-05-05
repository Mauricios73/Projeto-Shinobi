/// obj_menu - Create

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
if (!variable_global_exists("key_potion"))  global.key_potion  = ord("H"); // <-- ADICIONE ESTA LINHA
if (!variable_global_exists("key_summon"))  global.key_summon  = ord("G"); 

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
scr_start_game()

scr_exit_game()

scr_change_volume()

scr_change_resolution()

fn_change_difficulty = change_difficulty

fn_change_window_mode = function(mode) {
    global.window_mode = mode;
    switch (mode) {
        case 0: window_set_fullscreen(true); break;
        case 1: window_set_fullscreen(false); break;
    }
};

// --------------------------
// PAGES
// --------------------------
ds_menu_main = scr_create_menu_page(
    ["PLAY",     menu_element_type.script_runner, fn_start_game],
    ["SETTINGS", menu_element_type.page_transfer, menu_page.settings],
    ["EXIT",     menu_element_type.script_runner, fn_exit_game]
);

ds_settings = scr_create_menu_page(
    ["AUDIO",      menu_element_type.page_transfer, menu_page.audio],
    ["DIFFICULTY", menu_element_type.page_transfer, menu_page.difficulty],
    ["GRAPHICS",   menu_element_type.page_transfer, menu_page.graphics],
    ["CONTROLS",   menu_element_type.page_transfer, menu_page.controls],
    ["BACK",       menu_element_type.page_transfer, menu_page.main]
);

ds_menu_audio = scr_create_menu_page(
    ["MASTER", menu_element_type.slider, fn_change_volume, 1, [0,1], 0],
    ["SOUNDS", menu_element_type.slider, fn_change_volume, 1, [0,1], 1],
    ["MUSIC",  menu_element_type.slider, fn_change_volume, 1, [0,1], 2],
    ["BACK",   menu_element_type.page_transfer, menu_page.settings]
);

// Difficulty may be unimplemented; keep entries but they won't crash with menu exec guards in Step
ds_menu_difficulty = scr_create_menu_page(
    ["ENEMIES", menu_element_type.shift, fn_change_difficulty, 0, ["HARMLESS","NORMAL","TERRIBLE"], 0],
    ["ALLIES",  menu_element_type.shift, fn_change_difficulty, 0, ["DIM-WITTED","NORMAL","HELPFUL"], 1],
    ["BACK",    menu_element_type.page_transfer, menu_page.settings]
);

ds_menu_graphics = scr_create_menu_page(
    ["RESOLUTION", menu_element_type.shift,  fn_change_resolution, 0, ["640 x 360","854 x 480","1280 x 720","1440 x 900","1920 x 1080"]],
    ["WINDOW MODE",menu_element_type.toggle, fn_change_window_mode, 1, ["FULLSCREEN","WINDOWED"]],
    ["BACK",       menu_element_type.page_transfer, menu_page.settings]
);

// --------------------------
// CONTROLS (A.1) — expanded binds
// input rows: [Label, input_type, global_field_name, default_value]
// --------------------------
ds_menu_controls = scr_create_menu_page(
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
	["POTION",  menu_element_type.input, "key_potion",  global.key_potion], 
    ["PAUSE",   menu_element_type.input, "key_pause",   global.key_pause],
	["SUMMON",  menu_element_type.input, "key_summon",  global.key_summon],

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
