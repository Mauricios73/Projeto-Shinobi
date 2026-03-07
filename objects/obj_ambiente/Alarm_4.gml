if (vento_voice != -1) {
    audio_stop_sound(vento_voice);
}
vento_voice = -1;
vento_ativo = false;

// pause before next gust
alarm[2] = room_speed * irandom_range(10, 30);
