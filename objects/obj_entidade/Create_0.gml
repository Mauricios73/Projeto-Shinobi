// obj_entidade - Begin Step

/// -----------------------------
/// State constants (int)
/// -----------------------------
#macro PST_IDLE        0
#macro PST_RUN         1
#macro PST_JUMP        2
#macro PST_DASH        3
#macro PST_DASH_AIR    4
#macro PST_ATK         5
#macro PST_ATK_AIR     6
#macro PST_HIT         7
#macro PST_DEAD        8
#macro PST_CHAKRA      9
#macro PST_FIRE        10
#macro PST_CHIDORI     11
#macro PST_CROUCH      12 
#macro PST_ROLL        13 
#macro PST_WALL        14 
#macro PST_DEFEND      15 
#macro PST_GROUND_SLAM 16 
#macro PST_POTION	   17 
#macro PST_SUMMON	   18
#macro PST_TELEPORT_OUT   19 // Fase 1: Sumindo
#macro PST_TELEPORT_IN    20 // Fase 2: Aparecendo

// 2. Variáveis de Status
delay = 0;
invencivel = false;
vida_max = 10; // Aumente para teste, 1 é muito pouco
vida_atual = vida_max;
pstate = PST_IDLE; // Importante definir o pstate inicial

// 3. Física
velh = 0;
velv = 0;
mid_velh = 0; 
max_velh = 1;
max_velv = 1;
massa = 1;
ataque = 1;
xscale = 1;

// 4. Visual
mostra_estado = false;
img_spd = 35;
estado = "parado"

recebe_dano = function(_valor, _origem_x) {
    if (invencivel) return;

    // --- LÓGICA DE BLOQUEIO ---
    if (pstate == PST_DEFEND) {
        var _lado_ataque = (_origem_x > x) ? 1 : -1;
        
        // O bloqueio só funciona se o player estiver olhando para o ataque
        if (image_xscale == _lado_ataque) { 
            var _dano_reduzido = _valor * 0.1; // 80% de redução
            vida_atual -= _dano_reduzido;
            
            // Knockback (Empurrão do impacto)
            // Empurra para a direção oposta de onde veio o dano
            mid_velh = _lado_ataque * -1; 
            
            if (script_exists(screenshake)) screenshake(1);
            show_debug_message("BLOQUEIO COM SUCESSO! Dano: " + string(_dano_reduzido));
            return; 
        }
    }

    // --- DANO TOTAL (Se não bloqueou ou estava de costas) ---
    vida_atual -= _valor;
    mid_velh = (_origem_x > x) ? -3 : 3; // Knockback de hit normal é mais forte

    if (vida_atual > 0) {
        if (object_index == obj_player) {
            player_set_state(PST_HIT);
        } else {
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