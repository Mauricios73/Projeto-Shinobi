var rn_music = room_get_name(room);
if (rn_music == "rm_init" || rn_music == "rm_menu")
{
    alarm[0] = -1;
    alarm[1] = -1;

    if (variable_instance_exists(id, "musicas"))
    {
        for (var i = 0; i < array_length(musicas); i++)
        {
            audio_stop_sound(musicas[i]);
        }
    }

    if (variable_instance_exists(id, "mus_atual") && mus_atual != noone)
    {
        audio_stop_sound(mus_atual);
    }

    musica_ativa = false;
    instance_destroy();
    exit;
}

music_start_cycle();
