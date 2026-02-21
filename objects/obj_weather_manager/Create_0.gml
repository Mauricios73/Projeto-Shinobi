if (keyboard_check_pressed(ord("O")))
{
    show_debug_message("ROOM=" + room_get_name(room)
        + " fog_on=" + string(fog_on)
        + " fog_exists=" + string(instance_exists(obj_fog))
        + " fog_count=" + string(instance_number(obj_fog)));

    if (instance_exists(obj_fog))
        show_debug_message("FOG DEPTH=" + string(obj_fog.depth));
}


// evita duplicar
if (instance_number(obj_weather_manager) > 1) { instance_destroy(); exit; }
persistent = true;

// ====== CONFIG ROOMS ======
// Coloque aqui o nome EXATO da sua room de menu:
menu_rooms = ["rm_init", "rm_menu"]; // TROQUE para o nome real do seu menu

// Rooms internas onde NÃO pode ter chuva/neve:
indoor_rooms = ["Room2"];     // Dojo (interior)

// Fog pode aparecer em rooms internas?
fog_in_indoor = true;

// ====== TEMPOS (segundos) ======
precip_min = 30;
precip_max = 60;
fog_min    = 25;
fog_max    = 70;

snow_accum_speed   = 0.015;
snow_melt_speed    = 0.005;

// chances (0..100)
chance_none       = 85;
chance_snow       = 5;
chance_rain_light = 5; // precip_mode = 3
chance_rain_heavy = 5; // precip_mode = 2

// ====== ESTADO ATUAL ======
precip_mode = 0;        // 0 nada, 1 neve, 2 chuva forte, 3 chuva fraca
fog_on      = false;

precip_left = 0;
fog_left    = 0;

// compat (se algum lugar ler global.precip_mode)
global.precip_mode = precip_mode;


// ====== DEBUG (TEMPORÁRIO) ======
debug_keys   = true;    // deixe true agora
debug_popup  = false;    // show_message quando mudar (TEMPORÁRIO)

// só pra evitar popup repetido
_last_precip = -1;
_last_fog    = -1;

// ====== SOM CHUVA (2 camadas) ======
rain_fade_ms = 500;

// ajuste os nomes dos assets aqui:
snd_forest = snd_rain_forest; // <-- CONFIRA O NOME EXATO DO ASSET
snd_heavy  = snd_rain;      // <-- CONFIRA O NOME EXATO DO ASSET

// handles
h_forest = -1;
h_heavy  = -1;

// variação orgânica de volume
rain_wobble      = 1.0;
rain_wobble_t    = 0;
rain_wobble_goal = 1.0;

// para stop seguro pós-fade
rain_stop_armed = false;

// helper: garante loop tocando sem recriar sempre
ensure_loop = function(_h, _snd)
{
    if (_h == -1 || !audio_is_playing(_h))
    {
        _h = audio_play_sound(_snd, 0, true);
        audio_sound_gain(_h, 0, 0);
    }
    return _h;
};_volume = 0;   // Volume alvo do som da chuva