// só para se ainda estiver sem chuva (evita cortar quando voltar a chover)
if (precip_mode != 2 && precip_mode != 3)
{
    if (h_forest != -1) { audio_stop_sound(h_forest); h_forest = -1; }
    if (h_heavy  != -1) { audio_stop_sound(h_heavy);  h_heavy  = -1; }
}
rain_stop_armed = false;