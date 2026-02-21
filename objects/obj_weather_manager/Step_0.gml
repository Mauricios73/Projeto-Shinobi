var rn = room_get_name(room);

// -------- is_menu?
var is_menu = false;
for (var i = 0; i < array_length(menu_rooms); i++)
{
    if (rn == menu_rooms[i]) { is_menu = true; break; }
}

// dt em segundos
var dt = 1 / room_speed;

// ===== DEBUG KEYS =====
if (debug_keys)
{
    // F6: toggle fog
    if (keyboard_check_pressed(vk_f6))
    {
        fog_on = !fog_on;
        fog_left = 15;
        alarm[0] = 1;
    }

    // F7: força CHUVA FORTE 20s
    if (keyboard_check_pressed(vk_f7))
    {
        precip_mode = 2;
        precip_left = 20;
        alarm[0] = 1;
    }

    // F8: força CHUVA FRACA 20s
    if (keyboard_check_pressed(vk_f8))
    {
        precip_mode = 3;
        precip_left = 20;
        alarm[0] = 1;
    }

    // F9: força NEVE 20s
    if (keyboard_check_pressed(vk_f9))
    {
        precip_mode = 1;
        precip_left = 20;
        alarm[0] = 1;
    }

    // F10: limpa precip
    if (keyboard_check_pressed(vk_f10))
    {
        precip_mode = 0;
        precip_left = 15;
        alarm[0] = 1;
    }
}

// ===== MENU: não roda timers, mas garante que áudio/visuais desliguem =====
if (is_menu)
{
    precip_mode = 0;
    fog_on = false;
    global.precip_mode = 0;

    // aplica fade out do áudio (sem cortes)
    var target_forest = 0;
    var target_heavy  = 0;

    if (h_forest != -1) audio_sound_gain(h_forest, 0, rain_fade_ms);
    if (h_heavy  != -1) audio_sound_gain(h_heavy,  0, rain_fade_ms);

    if (!rain_stop_armed && (h_forest != -1 || h_heavy != -1))
    {
        rain_stop_armed = true;
        alarm[1] = ceil((rain_fade_ms / 1000) * room_speed) + 1;
    }

    alarm[0] = 1; // destrói visuais no menu
    exit;
}

// ===== TIMERS =====
if (precip_left > 0) precip_left -= dt;
if (fog_left > 0)    fog_left    -= dt;

// ===== sorteio precip =====
if (precip_left <= 0)
{
    var r = irandom_range(1, 100);
    var new_mode = 0;

    if (r <= chance_none) new_mode = 0;
    else if (r <= chance_none + chance_snow) new_mode = 1;
    else if (r <= chance_none + chance_snow + chance_rain_light) new_mode = 3; // chuva fraca
    else new_mode = 2; // chuva forte

    precip_mode = new_mode;
    precip_left = irandom_range(precip_min, precip_max);

    alarm[0] = 1; // aplica visuais
}

// ===== sorteio fog =====
if (fog_left <= 0)
{
    fog_on = !fog_on;
    fog_left = irandom_range(fog_min, fog_max);
    alarm[0] = 1;
}

// compat global
global.precip_mode = precip_mode;

// ============================
// SOM DA CHUVA (sem clique)
// ============================

// variação orgânica leve
rain_wobble_t -= dt;
if (rain_wobble_t <= 0)
{
    rain_wobble_t    = random_range(0.7, 1.4);
    rain_wobble_goal = random_range(0.92, 1.08);
}
rain_wobble = lerp(rain_wobble, rain_wobble_goal, 0.02);

// estados
var rain_light = (precip_mode == 3);
var rain_heavy = (precip_mode == 2);
var rain_any   = (rain_light || rain_heavy);

// volumes alvo
var target_forest = rain_any   ? (rain_heavy ? 0.22 : 0.65) : 0;
var target_heavy  = rain_heavy ? 0.45 : 0;

// aplica wobble
target_forest *= rain_wobble;
target_heavy  *= rain_wobble;

// garante loops e aplica gain com fade
if (target_forest > 0)
{
    h_forest = ensure_loop(h_forest, snd_forest);
    audio_sound_gain(h_forest, clamp(target_forest, 0, 1), rain_fade_ms);
}
else if (h_forest != -1)
{
    audio_sound_gain(h_forest, 0, rain_fade_ms);
}

if (target_heavy > 0)
{
    h_heavy = ensure_loop(h_heavy, snd_heavy);
    audio_sound_gain(h_heavy, clamp(target_heavy, 0, 1), rain_fade_ms);
}
else if (h_heavy != -1)
{
    audio_sound_gain(h_heavy, 0, rain_fade_ms);
}

// agenda stop seguro (pra não cortar no meio)
if (!rain_any && (h_forest != -1 || h_heavy != -1))
{
    if (!rain_stop_armed)
    {
        rain_stop_armed = true;
        alarm[1] = ceil((rain_fade_ms / 1000) * room_speed) + 1;
    }
}
else
{
    rain_stop_armed = false;
}