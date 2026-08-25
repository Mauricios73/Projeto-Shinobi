// =====================================================================
// Arquivo / Objeto: obj_transicao
// Evento: Step
// =====================================================================

var spd = 0.06;

// Fade OUT
if (!mudei)
{
    alpha = min(1, alpha + spd);

    if (alpha >= 1 && !ja_trocou)
    {
        // Trava de segurança: só troca de sala se houver um destino válido
        if (destino != noone && room_exists(destino)) 
        {
            ja_trocou = true;
            room_goto(destino);
        }
        else 
        {
            show_debug_message("ERRO: 'destino' não foi configurado no sensor!");
        }
    }

    // Posiciona o player assim que entra na sala nova
    if (ja_trocou && room == destino && instance_exists(obj_player))
    {
        if (target_x != -1) obj_player.x = target_x;
        if (target_y != -1) obj_player.y = target_y;

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