var rn = room_get_name(room);

// is_menu?
var is_menu = false;
for (var i = 0; i < array_length(menu_rooms); i++)
{
    if (rn == menu_rooms[i]) { is_menu = true; break; }
}

// no menu: não roda timer, não sorteia nada, não cria nada
if (is_menu) exit;

// dt em segundos
var dt = 1 / room_speed;

// ===== DEBUG KEYS (TEMP) =====
if (debug_keys)
{
    // F6: toggle fog
    if (keyboard_check_pressed(vk_f6))
    {
        fog_on = !fog_on;
        fog_left = 15;

        if (debug_popup) show_message("DEBUG: FOG " + (fog_on ? "ON" : "OFF"));
        alarm[0] = 1;
    }

    // F7: força CHUVA 20s
    if (keyboard_check_pressed(vk_f7))
    {
        precip_mode = 2;
        precip_left = 20;
        if (debug_popup) show_message("DEBUG: CHUVA (20s)");
        alarm[0] = 1;
    }

    // F8: força NEVE 20s
    if (keyboard_check_pressed(vk_f8))
    {
        precip_mode = 1;
        precip_left = 20;
        if (debug_popup) show_message("DEBUG: NEVE (20s)");
        alarm[0] = 1;
    }

    // F9: limpa precip
    if (keyboard_check_pressed(vk_f9))
    {
        precip_mode = 0;
        precip_left = 15;
        if (debug_popup) show_message("DEBUG: SEM PRECIP");
        alarm[0] = 1;
    }
}

// ===== TIMERS =====
if (precip_left > 0) precip_left -= dt;
if (fog_left > 0)    fog_left    -= dt;

// Quando acaba precip -> sorteia novo
if (precip_left <= 0)
{
    var r = irandom_range(1, 100);

    var new_mode = 0;
    if (r <= chance_none) new_mode = 0;
    else if (r <= chance_none + chance_snow) new_mode = 1;
    else new_mode = 2;

    precip_mode = new_mode;
    precip_left = irandom_range(precip_min, precip_max);

    if (debug_popup)
    {
        if (precip_mode == 0) show_message("EVENTO: sem precipitação");
        if (precip_mode == 1) show_message("EVENTO: NEVE começou");
        if (precip_mode == 2) show_message("EVENTO: CHUVA começou");
    }

    alarm[0] = 1; // aplica visuais
}

// Quando acaba fog -> toggla
if (fog_left <= 0)
{
    fog_on = !fog_on;
    fog_left = irandom_range(fog_min, fog_max);

    if (debug_popup) show_message("EVENTO: FOG " + (fog_on ? "ON" : "OFF"));

    alarm[0] = 1;
}

// ... (seu código existente)

// === CONTROLE DO SOM DE CHUVA ===
if (precip_mode == 2) {
    // Se está chovendo, define o volume alvo (mais alto para chuva forte)
    rain_target_volume = 1.0; // Volume máximo, ajuste se quiser mais baixo
} else {
    // Se não está chovendo, volume alvo é zero
    rain_target_volume = 0;
}

// Se o som deve tocar
if (rain_target_volume > 0) {
    if (rain_sound_handle == -1 || !audio_is_playing(rain_sound_handle)) {
        rain_sound_handle = audio_play_sound(snd_rain, 0, true);
        // Começa com volume zero para fazer fade-in
        audio_sound_gain(rain_sound_handle, 0, 0);
    }

    // Ajusta o volume com um fade suave
    audio_sound_gain(rain_sound_handle, rain_target_volume, rain_fade_ms);
} else {
    // Se o volume alvo é zero, faz fade-out e para depois do fade
    if (rain_sound_handle != -1 && audio_is_playing(rain_sound_handle)) {
        audio_sound_gain(rain_sound_handle, 0, rain_fade_ms);

        // Para o som após o fade-out
        alarm[1] = ceil((rain_fade_ms / 1000.0) * room_speed);
    }
}