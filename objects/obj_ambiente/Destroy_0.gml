// obj_ambiente - Destroy
if (variable_instance_exists(id, "bird_voice") && bird_voice != -1) audio_stop_sound(bird_voice);
if (variable_instance_exists(id, "crow_voice") && crow_voice != -1) audio_stop_sound(crow_voice);
if (variable_instance_exists(id, "vento_voice") && vento_voice != -1) audio_stop_sound(vento_voice);
