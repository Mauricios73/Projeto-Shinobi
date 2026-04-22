// obj_entidade - Begin Step
// FIX: direção deve considerar impulso (mid_velh), não só velh.
var _dir = velh + mid_velh;
if (_dir != 0) xscale = sign(_dir);
image_xscale = xscale;

// Toggle debug state display
if (position_meeting(mouse_x, mouse_y, id))
{
    if (mouse_check_button_released(mb_left))
        mostra_estado = !mostra_estado;
}

image_speed = (img_spd / room_speed * global.vel_mult);

recebe_dano = function(_valor, _origem_x) {
    if (variable_instance_exists(id, "invencivel") && invencivel) return;

    // --- LÓGICA DE BLOQUEIO ---
    // Verifica se o objeto tem o estado de defesa ativo
    if (variable_instance_exists(id, "pstate") && pstate == PST_DEFEND) {
        var _lado_dano = (_origem_x > x) ? 1 : -1;
        
        // Se estiver virado para o ataque (image_xscale)
        if (image_xscale == _lado_dano) {
            vida_atual -= _valor * 0.2; // 80% de redução
            mid_velh = image_xscale * -1.5; // Empurrão de impacto
            if (script_exists(screenshake)) screenshake(2);
            show_debug_message(string(object_get_name(object_index)) + " bloqueou!");
            return; 
        }
    }

    // --- DANO NORMAL ---
    vida_atual -= _valor;

    // Reação de HIT / MORTE
    if (vida_atual > 0) {
        if (object_index == obj_player) {
            player_set_state(PST_HIT);
        } else {
            // Reação genérica para inimigos
            pstate = PST_HIT;
            estado = "hit";
            image_index = 0;
        }
    } else {
        if (object_index == obj_player) {
            player_set_state(PST_DEAD);
        } else {
            pstate = PST_DEAD;
            estado = "dead";
            image_index = 0;
        }
    }
}