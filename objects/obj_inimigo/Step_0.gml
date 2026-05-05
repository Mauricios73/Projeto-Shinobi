// obj_inimigo - STEP EVENT

// 1. Gravidade e Colisão Base
if (!place_meeting(x, y + 1, obj_block)) {
    velv += GRAVIDADE * massa;
}

// 2. Lógica de Percepção (Prioridade: Clone > Player)
var _clone_proximo = instance_nearest(x, y, obj_ally);
var _player_proximo = instance_nearest(x, y, obj_player);

alvo = noone;

if (_clone_proximo != noone && distance_to_object(_clone_proximo) < dist_visao) {
    alvo = _clone_proximo;
} 
else if (_player_proximo != noone && distance_to_object(_player_proximo) < dist_visao) {
    alvo = _player_proximo;
}

// 3. Variáveis de Direção e Distância
if (alvo != noone && instance_exists(alvo)) {
    dist = point_distance(x, y, alvo.x, alvo.y);
    var _dir = sign(alvo.x - x);
} else {
    dist = 99999;
    var _dir = image_xscale;
}

// 4. FSM (Máquina de Estados)
switch (estado) {
    case "parado":
        velh = 0;
        sprite_index = spr_inimigo_idle; // Garanta que tem a sprite de idle
        
        if (alvo != noone) {
            // O inimigo "espera" o tempo de reação antes de começar a agir
            timer_reacao++;
            if (timer_reacao >= global.enemy_reaction_time) {
                estado = "movendo";
                timer_reacao = 0;
            }
        }
        break;

    case "movendo":
        sprite_index = spr_inimigo_run;
        
        if (alvo != noone && instance_exists(alvo)) {
            image_xscale = _dir;
            
            // Lógica de Inteligência (Dificuldade Terrible)
            // Se o player atacar e estivermos perto, o inimigo para para tentar defender/esquivar
            var _player_atacando = (alvo.estado == "ataque" || alvo.estado == "ataque aereo");
            if (global.difficulty_enemies == 2 && _player_atacando && dist < 60) {
                velh = 0;
            } else {
                velh = _dir * max_velh;
            }

            // Transição para Ataque
            if (dist < dist_ataque) {
                estado = "ataque";
                image_index = 0;
                velh = 0;
                
                // No difícil, chance de usar skill especial
                if (global.difficulty_enemies == 2 && irandom(100) < 30) {
                    tipo_ataque = "skill"; 
                } else {
                    tipo_ataque = choose("soco", "chute");
                }
            }
        } else {
            estado = "parado";
        }
        break;

    case "ataque":
        velh = 0;
        if (tipo_ataque == "soco") {
            atacando(spr_inimigo_punch1, 2, 4, 25, -50); 
        } else if (tipo_ataque == "chute") {
            atacando(spr_inimigo_kick, 3, 5, 30, -30); 
        } else if (tipo_ataque == "soco") {
            atacando(spr_inimigo_punch2, 2, 4, 25, -50);
        } else {
			atacando(spr_explosive_strike, 2, 4, 25, -50);
		}
        break;

    case "defesa": // Estado adicionado para IA avançada
        velh = 0;
        sprite_index = spr_inimigo_defend; // Use sua sprite de defesa
        if (image_index > image_number - 1) estado = "parado";
        break;

    case "esquiva": // Estado adicionado para IA avançada
        sprite_index = spr_inimigo_roll; // Use sua sprite de esquiva/rolamento
        if (image_index > image_number - 1) estado = "parado";
        break;

    case "hit":
        velh = 0;
        sprite_index = spr_inimigo_hit;
        if (image_index > image_number - 1) {
            estado = "parado";
        }
        break;

    case "dead":
        velh = 0;
        sprite_index = spr_inimigo_dead;
        if (image_index > image_number - 1) {
            image_speed = 0;
            image_alpha -= 0.02;
            if (image_alpha <= 0) instance_destroy();
        }
        break;
}

// 5. Visual e Super Armor
if (estado != "ataque") {
    image_blend = c_white;
} else {
    // Se quiser um feedback visual para Super Armor (ex: brilho vermelho)
    // if (vida_atual > 0) image_blend = c_red;
}