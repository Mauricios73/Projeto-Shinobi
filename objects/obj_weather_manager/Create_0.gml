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
precip_min = 20;
precip_max = 45;
fog_min    = 25;
fog_max    = 70;

snow_accum_speed   = 0.015;
snow_melt_speed    = 0.005;

// chances (0..100)
chance_none = 50;
chance_snow = 25;
chance_rain = 25;

// ====== ESTADO ATUAL ======
precip_mode = 0;        // 0 nada, 1 neve, 2 chuva
fog_on      = false;

precip_left = 0;        // tempo restante (s)
fog_left    = 0;

// ====== DEBUG (TEMPORÁRIO) ======
debug_keys   = true;    // deixe true agora
debug_popup  = false;    // show_message quando mudar (TEMPORÁRIO)

// só pra evitar popup repetido
_last_precip = -1;
_last_fog    = -1;


// ====== SOM DA CHUVA ======
rain_sound_handle = -1; // Handle do som de chuva
rain_fade_ms = 400;   // Tempo de fade em milissegundos
rain_target_volume = 0;   // Volume alvo do som da chuva