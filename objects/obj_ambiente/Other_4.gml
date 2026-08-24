// obj_ambiente - Room Start
var rn_amb = room_get_name(room);

if (rn_amb == "rm_init" || rn_amb == "rm_menu")
{
    if (variable_instance_exists(id, "bird_voice") && bird_voice != -1) audio_stop_sound(bird_voice);
    if (variable_instance_exists(id, "crow_voice") && crow_voice != -1) audio_stop_sound(crow_voice);
    if (variable_instance_exists(id, "vento_voice") && vento_voice != -1) audio_stop_sound(vento_voice);

    for (var i = 0; i <= 6; i++)
    {
        alarm[i] = -1;
    }

    instance_destroy();
}
