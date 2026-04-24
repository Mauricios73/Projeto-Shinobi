// obj_ally - STEP EVENT

// 1. GERENCIAMENTO DE EXISTÊNCIA
timer_vida--;

// Se você usa uma variável global para o input, use-a aqui. 
// Exemplo: se o seu player usa 'key_summon'
var _key_pressed = keyboard_check_pressed(ord("G")); // SUBSTITUA PELA SUA TECLA

if (_key_pressed && estado != "spawn" && estado != "sacrificio") {
    estado = "sacrificio";
    image_index = 0;
}

// Se o tempo acabar ou a vida chegar a zero, o objeto é removido
if (timer_vida <= 0 || vida_atual <= 0) {
	effect_create_above(ef_smoke, x, y - 15, 2, c_white); // Nuvem cinza ao sumir
    instance_destroy();
	effect_create_above(ef_smoke, x, y - 5, 2, c_gray)
    exit;
}

// 2. SINCRONIA COM O PLAYER (Itens 1, 2 e 5)
if (instance_exists(obj_player)) {
    // [Item 2] Recuo Estratégico: Se player defende, aliado protege as costas
    if (obj_player.pstate == PST_DEFEND) {
        estado = "follow";
        distancia_seguir = 30; // Fica colado no player
    } else {
        distancia_seguir = 80;
    }

    // [Item 5] Ataque de Sacrifício: Re-summon gasta a vida e dá golpe forte
    if (keyboard_check_pressed(vk_control)) { // Ajuste para sua tecla de Summon
        estado = "sacrificio";
        image_index = 0;
    }
}

// 3. NAVEGAÇÃO INTELIGENTE (Item 3)
var no_chao = place_meeting(x, y + 1, obj_block);
if (!no_chao) {
    velv += grav;
} else {
    if (velv > 0) velv = 0;
    
    // Lógica de Pulo: Se houver parede ou player estiver muito acima
    if (jump_cooldown <= 0) {
        var parede = place_meeting(x + (image_xscale * 20), y, obj_block);
        var player_alto = (obj_player.y < y - 48);
        
        if (parede || (player_alto && distance_to_object(obj_player) < 150)) {
            velv = jump_force;
            jump_cooldown = 40;
        }
    }
}
if (jump_cooldown > 0) jump_cooldown--;

// Teleporte de Segurança
if (distance_to_object(obj_player) > dist_teleporte) {
    // Fumaça onde ele estava
    effect_create_above(ef_smoke, x, y, 2, c_white);
    
    x = obj_player.x;
    y = obj_player.y;
    
    // Fumaça onde ele apareceu
    effect_create_above(ef_smoke, x, y, 2, c_gray);
    
    // Faz ele tocar a animação de "nascimento" de novo ao chegar
    estado = "spawn";
    sprite_index = spr_summon_ally;
    image_index = 0;
    velh = 0;
    velv = 0;
}



// 4. MÁQUINA DE ESTADOS
switch (estado)
{
    case "spawn":
        velh = 0;
        if (image_index >= image_number - 1) {
            estado = "idle";
            sprite_index = spr_player_idle;
        }
    break;

    case "idle":
        velh = 0;
        sprite_index = spr_player_idle;
        
        // Busca de inimigo
        var inimigo = instance_nearest(x, y, obj_entidade_inimigo);
        if (inimigo != noone && distance_to_object(inimigo) < 250) {
            alvo = inimigo;
            estado = "combate";
        } else if (distance_to_object(obj_player) > distancia_seguir) {
            estado = "follow";
        }
    break;

    case "follow":
        sprite_index = spr_player_run;
        var _dir = sign(obj_player.x - x);
        velh = _dir * vel_persegue;
        
        if (distance_to_object(obj_player) < distancia_seguir - 10) estado = "idle";
    break;

    case "combate":
	    if (!instance_exists(alvo) || distance_to_object(alvo) > dist_perder_alvo) {
	        alvo = noone;
	        estado = "idle";
	        break;
	    }

	    // --- LÓGICA DE FLANQUEIO CORRIGIDA ---
	    // Se o player está à esquerda do alvo, o destino do aliado é a direita (alvo.x + 40)
	    // Se o player está à direita do alvo, o destino do aliado é a esquerda (alvo.x - 40)
	    var _lado_do_player = (obj_player.x < alvo.x) ? 1 : -1;
	    var target_x = alvo.x + (_lado_do_player * 45); // 45px de distância do centro do alvo

	    var _dist_do_alvo = distance_to_object(alvo);
	    var _dir_para_destino = sign(target_x - x);

	    // Se ele ainda não chegou no ponto de flanqueio, ele corre
	    if (abs(x - target_x) > 10) { 
	        sprite_index = spr_player_run;
	        velh = _dir_para_destino * vel_persegue;
	        image_xscale = sign(alvo.x - x); // Sempre olha para o inimigo enquanto corre para a posição
	    } 
	    else {
	        // CHEGOU NA POSIÇÃO DE ATAQUE
	        velh = 0;
	        image_xscale = sign(alvo.x - x); // Garante que está virado para o alvo
	        sprite_index = spr_player_punch1;

	        // DANO: Verifique se o frame 3 é realmente o do impacto na sua sprite
	        if (image_index >= 3 && image_index < 3.2 && pode_atacar) {
	            var _inst = instance_place(x + (image_xscale * 20), y, obj_entidade_inimigo);
	            if (_inst == alvo) { // Só causa dano se o alvo estiver na frente do soco
	                with(alvo) {
	                    recebe_dano(other.dano_aliado, other.x);
	                }
	                pode_atacar = false;
	            }
	        }
	        if (image_index >= image_number - 1) pode_atacar = true;
	    }
	break;
    
    case "sacrificio":
        sprite_index = spr_katon_goka_mekkyaku; // Sprite de ataque forte
        velh = image_xscale * 6; // Avanço rápido
        
        // Dano massivo ao tocar
        var inimigo_hit = instance_place(x, y, obj_entidade_inimigo);
        if (inimigo_hit) {
            with(inimigo_hit) recebe_dano(5, other.x);
            vida_atual = 0; // Morre após o impacto
        }
        
        if (image_index >= image_number - 1) vida_atual = 0;
    break;
}

// Ajuste visual de pulo/queda (Item 3)
if (!no_chao && estado != "spawn" && estado != "sacrificio") {
    sprite_index = (velv < 0) ? spr_player_jump : spr_player_fall;
}