var spd = 0.06;

// Fade OUT
if (!mudei)
{
    alpha = min(1, alpha + spd);

    if (alpha >= 1 && !ja_trocou)
    {
        ja_trocou = true;
        room_goto(destino);
    }

    // quando a room já virou, posiciona o player e começa o fade IN
    if (ja_trocou && room == destino && instance_exists(obj_player))
    {
        // X calculado usando room_width DA ROOM NOVA
        if (spawn_side == "right")
            obj_player.x = room_width - spawn_margin;
        else if (spawn_side == "left")
            obj_player.x = spawn_margin;
        // else: mantém X atual

        // Y opcional (mantém o Y do sensor)
        if (keep_y)
            obj_player.y = clamp(spawn_y, 0, room_height);

        mudei = true;
    }
}
// Fade IN
else
{
    alpha = max(0, alpha - spd);

    if (alpha <= 0)
    {
        persistent = false;
        instance_destroy();
    }
}