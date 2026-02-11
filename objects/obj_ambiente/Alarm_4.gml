if (vento_id != noone) {
    audio_stop_sound(vento_id);
}

vento_id = noone;
vento_ativo = false;

// pausa antes da próxima rajada
alarm[2] = room_speed * irandom_range(10, 30);
