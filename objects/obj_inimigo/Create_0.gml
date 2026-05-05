// obj_inimigo - CREATE EVENT
event_inherited();

alvo = noone; 
dist = 99999;
tipo_ataque = "";

// Atributos do Ninja
vida_max = 30;
vida_atual = vida_max;
max_velh = 2; // Ninjas são mais rápidos!
dist_visao = 500;
dist_ataque = 30; 
ataque = 1; // Dano base do soco/chute

estado = "parado";

// Variáveis de controle da IA
timer_reacao = 0;
pode_atacar = true;

// Atributos base multiplicados pela dificuldade
var _hp_mult  = variable_global_exists("enemy_hp_mult") ? global.enemy_hp_mult : 1;
vida_max     = 30 * _hp_mult;
vida_atual   = vida_max;

// --- Função de Dano Personalizada (Super Armor) ---
recebe_dano = function(_valor, _origem_x, _skill_id = "") {
    
    // DEBUG 1: A função foi chamada?
    show_debug_message("----------------------------------");
    show_debug_message("FUNCAO CHAMADA no Inimigo: " + string(id));
    show_debug_message("Dano recebido: " + string(_valor) + " | Skill: " + string(_skill_id));
    show_debug_message("Estado atual antes do dano: " + estado);

// Tenta esquivar ou defender antes de processar o dano
    if (estado != "dead" && estado != "hit") {
        var _sorteio = irandom(100);
        
        // 1. Chance de Esquiva (Dificuldade determina o sucesso)
        if (_sorteio < global.enemy_dodge_chance) {
            estado = "esquiva";
            image_index = 0;
            velh = sign(x - _origem_x) * 6; // Pula para longe
            exit;
        }
        
        // 2. Chance de Defesa
        if (_sorteio < (global.enemy_dodge_chance + global.enemy_block_chance)) {
            estado = "defesa";
            image_index = 0;
            vida_atual -= (_valor * 0.05); // Toma apenas 20% do dano
            exit;
        }
    }

    vida_atual -= _valor;
    show_debug_message("Vida restante: " + string(vida_atual));

    if (vida_atual <= 0) {
        show_debug_message("Resultado: MORTE");
        estado = "dead";
        image_index = 0;
    } else {
        var _pode_interromper = true;

        // Se o Ninja estiver atacando, checa Super Armor
        if (estado == "ataque") {
            if (_skill_id == "" && _valor < 3) {
                _pode_interromper = false;
                // DEBUG 2: Super Armor ativou?
                show_debug_message("SUPER ARMOR ATIVADA: Dano insuficiente para interromper.");
            }
        }

        if (_pode_interromper) {
            show_debug_message("Resultado: Entrou em HIT");
            estado = "hit";
            image_index = 0;
            image_blend = c_white;
        } else {
            show_debug_message("Resultado: Manteve ATAQUE (Super Armor)");
            image_blend = c_red; 
        }
        effect_create_above(ef_spark, x, y - 20, 0, c_white);
    }
    show_debug_message("----------------------------------");
}
	

// Atributos base
vida_max_base = 30; 
ataque_base = 1;

// Aplica a dificuldade
vida_max = vida_max_base * global.enemy_hp_mult;
vida_atual = vida_max;
ataque = ataque_base * global.enemy_dmg_mult;