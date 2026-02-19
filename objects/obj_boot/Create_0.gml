///// obj_boot - Create
//persistent = false;

//// Room alvo no final
//target_room = rm_menu;

//// Fundo
//bg_col = c_black;

//// Skip
//skip_enabled = true;
//skip_text    = "Pressione qualquer tecla para pular";

//// Se quiser usar uma fonte específica, set aqui:
//skip_font = -1; // -1 = fonte padrão atual

//// ===== Sequência de logos (em segundos) =====
//// Troque os sprites pelos seus:
//seq = [
//    { spr: spr_logo_hakoyama, fade_in: 0.60, hold: 1.10, fade_out: 0.60 },
//    { spr: spr_logo_shinobi,  fade_in: 0.60, hold: 1.20, fade_out: 0.70 }
//];

//// Controle
//idx = 0;
//t   = 0;
//a   = 0;

//// Escala/posicionamento
//margin = 0.12;        // margem em % da tela
//allow_upscale = true; // se false, nunca aumenta acima de 1x
//integer_scale = false; // se true, força escala inteira (bom pra pixel art)

//// (Opcional) garantir controladores persistentes aqui, SEM layer
//// Comente se você já coloca eles nas rooms.
//if (!instance_exists(obj_game_controller))   instance_create_depth(0, 0, 0, obj_game_controller);
//if (!instance_exists(obj_musica))           instance_create_depth(0, 0, 0, obj_musica);
//if (!instance_exists(obj_weather_manager))  instance_create_depth(0, 0, 0, obj_weather_manager);

//// Importante: rm_init NÃO deve ter HUD/pause/menu.
//// Deixe só obj_boot (e no máximo esses controllers persistentes).

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
