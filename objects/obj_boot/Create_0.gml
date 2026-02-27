/// obj_boot - Create
persistent = false;

// Sprites (troque pros seus)
spr_studio   = spr_logo_hakoyama;     // logo do estúdio
spr_title_bg = -1;        // fundo da tela de título (pode ser -1 se não usar)
spr_title    = spr_logo_shinobi;      // logo do jogo

target_room = rm_menu;

// Timings (segundos)
fade_in_time   = 0.60;
hold_time      = 1.10;
fade_out_time  = 0.60;

title_fade_in  = 0.60;
min_skip_time  = 0.25;   // trava skip nos primeiros frames
auto_to_menu   = false;  // se true, sai sozinho depois de alguns segundos
auto_wait      = 8.0;

state = 0; // 0 fade-in studio, 1 hold, 2 fade-out, 3 fade-in title, 4 wait, 5 fade-out -> menu
t = 0;
alpha = 0;

// trava skip
skip_lock = min_skip_time;

// (Opcional) criar persistentes aqui sem layer
// Use APENAS o que realmente precisa existir desde o começo.
if (!instance_exists(obj_game_controller)) instance_create_depth(0, 0, 0, obj_game_controller);
if (!instance_exists(obj_pause))           instance_create_depth(0, 0, 0, obj_pause);
if (!instance_exists(obj_weather_manager)) instance_create_depth(0, 0, 0, obj_weather_manager);

// IMPORTANTE: rm_init deve ser tratado como "menu" pro weather
// No obj_weather_manager Create, coloque: menu_rooms = ["rm_init","rm_menu"];
