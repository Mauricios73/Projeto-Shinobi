// obj_musica - Destroy
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
