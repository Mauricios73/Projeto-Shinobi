 // PATCH C2 - obj_player Step_0.gml
// FSM final: enter/step/exit por estado + lógica visual totalmente movida para enter e transições internas.

if (instance_exists(obj_transicao)) exit;

// --- invencibilidade blink
if (invencivel && tempo_invencivel > 0)
{
    tempo_invencivel--;
    image_alpha = 0.2 + 0.8 * abs(sin(get_timer() / 50000));
}
else
{
    invencivel = false;
    image_alpha = 1;
}


// --- inputs and ground
var chao = place_meeting(x, y + 1, obj_block);
var parede_dir = place_meeting(x + 1, y, obj_block); // <- NOVO: Deteta parede à direita
var parede_esq = place_meeting(x - 1, y, obj_block); // <- NOVO: Deteta parede à esquerda

var right_pressed = keyboard_check_pressed(global.key_right);
var left_pressed  = keyboard_check_pressed(global.key_left);
var right_held    = keyboard_check(global.key_right);
var left_held     = keyboard_check(global.key_left);
var run			  = keyboard_check(vk_shift);

var jump  = keyboard_check_pressed(global.key_up); // Garante que o salto usa _pressed para o duplo salto funcionar bem
var up    = keyboard_check(global.key_up);         // <- NOVO: Segurar para subir
var down  = keyboard_check(global.key_down); // <- NOVO: Botão de agachar
var roll    = keyboard_check_pressed(vk_control); // <- NOVO: Tecla Control para rolar (podes mudar para global.key_roll depois)
var defend  = keyboard_check(global.key_defesa); // <- NOVO: Input para segurar a defesa (configura a tua global.key_defesa)

var attack  = keyboard_check_pressed(global.key_ataque);
var dash    = keyboard_check_pressed(global.key_dash);
var chidori = keyboard_check_pressed(global.key_chidori);
var fire    = keyboard_check_pressed(global.key_fire);
var chakra  = keyboard_check(global.key_chakra);

// gamepad
if (gamepad_is_connected(0))
{
    var axis_h = gamepad_axis_value(0, gp_axislh);
    if (axis_h >  0.3) right = 1;
    if (axis_h < -0.3) left  = 1;

    if (gamepad_button_check_pressed(0, gp_face1)) jump   = true;
    if (gamepad_button_check_pressed(0, gp_face2)) attack = true;
    if (gamepad_button_check_pressed(0, gp_face3)) dash   = true;
    if (gamepad_button_check(0, gp_face4)) chakra = true;

    if (gamepad_button_check_pressed(0, gp_shoulderr)) chidori = true;
    if (gamepad_button_check_pressed(0, gp_shoulderl)) fire    = true;
}

// --- Lógica de ativação do Double Tap para Correr (vel_correr)
if (right_pressed) {
    if (dash_timer_lateral > 0 && ultima_tecla_pressionada == 1) is_running = true;
    else { dash_timer_lateral = tempo_double_tap; ultima_tecla_pressionada = 1; }
}
if (left_pressed) {
    if (dash_timer_lateral > 0 && ultima_tecla_pressionada == 2) is_running = true;
    else { dash_timer_lateral = tempo_double_tap; ultima_tecla_pressionada = 2; }
}

// Se soltar as teclas de movimento, para de correr
if (!right_held && !left_held) is_running = false;
// cooldowns

// Redução do timer de double tap
if (dash_timer_lateral > 0) dash_timer_lateral--;

if (dash_timer > 0) dash_timer--;

// sync if external systems changed `estado`
player_sync_state_from_string();

// --- DEAD GATE: block all inputs/skills once dead (prevents dash "revive")
if (vida_atual <= 0 && pstate != PST_DEAD) {
    estado = "dead";
    player_set_state(PST_DEAD);
}

if (pstate == PST_DEAD)
{
    // signal game over once
    if (instance_exists(obj_game_controller)) with (obj_game_controller) game_over = true;
    velh = 0; velv = 0; mid_velh = 0;
    if (image_index >= image_number - 1) image_index = image_number - 1;
    exit;
}


// skill input via controller (não troca sprite aqui; troca estado)
var sc = instance_find(obj_skill_controller, 0);
if (fire && sc != noone)   sc.start_fire(self);
if (chidori && sc != noone) sc.start_chidori(self);

// chakra hold gate
if (chakra)
{
    if (pstate == PST_IDLE || pstate == PST_RUN) player_set_state(PST_CHAKRA);
}
else
{
    if (pstate == PST_CHAKRA) player_set_state(PST_IDLE);
}

// --- helpers local
function _set_air_visual_from_velv()
{
    var new_phase = (velv >= 0) ? 1 : 0;
    if (new_phase != _air_phase)
    {
        _air_phase = new_phase;
        sprite_index = (_air_phase == 0) ? spr_player_jump : spr_player_fall;
        image_index = 0;
        _vis_state = pstate; // mantém cache consistente
    }
}

function _cancel_attack_to(_next_state)
{
    // cancela ataque com reset total (evita vazamento)
    combo = 0;
    ataque_mult = 1;
    finaliza_ataque();
    player_set_state(_next_state);
}

// --- per-state step
switch (pstate)
{
    case PST_IDLE:
    {
        if (chao) dash_aereo = true;

        velh = (right_held - left_held) * max_velh * global.vel_mult;

        // <- NOVO: Transição para Agachar
        if (down) {
            player_set_state(PST_CROUCH);
        }
        else if (velh != 0) player_set_state(PST_RUN);
		
        else if (jump || !chao)
        {
            velv = (-max_velv * (jump ? 1 : 0));
            player_set_state(PST_JUMP);
        }
        else if (attack)
        {
            inicia_ataque(chao);
        }
        else if (dash && dash_timer <= 0)
        {
            player_set_state(PST_DASH);
        }
		else if (roll)
        {
            player_set_state(PST_ROLL);
        }
		else if (defend && chao) // Só pode defender se estiver no chão
        {
            player_set_state(PST_DEFEND);
        }

        // garante limpar hitbox de chidori fora do estado
        if (pstate != PST_CHIDORI && instance_exists(chidori_hit))
        {
            with (chidori_hit) instance_destroy();
            chidori_hit = noone;
        }
    }
    break;

    case PST_RUN:
    {
		// <- NOVO: Controla a velocidade baseado na tecla Shift
        // 1. Definição da Velocidade Máxima baseada nos inputs
	    if (run) {
	        max_velh = vel_sprint;
	        sprite_index = spr_player_sprint; 
	    } 
	    else if (is_running) {
	        max_velh = vel_correr;
	        sprite_index = spr_player_run;
	    } 
	    else {
	        max_velh = vel_caminhar;
	        sprite_index = spr_player_walking; // O seu novo sprite de caminhada
	    }
		
        velh = (right_held - left_held) * max_velh * global.vel_mult;

        if (abs(velh) < 0.1)
        {
            velh = 0;
			is_running = false; // Reseta ao parar
            player_set_state(PST_IDLE);
        }
        else if (jump || !chao)
        {
            velv = (-max_velv * (jump ? 1 : 0));
            player_set_state(PST_JUMP);
        }
        else if (attack)
        {
            inicia_ataque(chao);
        }
        else if (dash && dash_timer <= 0)
        {
            player_set_state(PST_DASH);
        }
		else if (roll)
        {
            player_set_state(PST_ROLL);
        }
		else if (defend && chao) // Só pode defender se estiver no chão
        {
            player_set_state(PST_DEFEND);
        }
    }
    break;

    case PST_JUMP:
    {
		// <- NOVO: Transição para agarrar na parede
        // Se não estiver no chão, estiver a tocar numa parede e a pressionar na direção dela
        if (!chao && ((parede_dir && right_held) || (parede_esq && left_held)))
        {
            player_set_state(PST_WALL);
            break; // Sai do case do JUMP
        }
		
		//max_velh = run_key ? vel_correr : vel_caminhar; // <- NOVO: Mantém o controlo de andar/correr no ar
        max_velh = run ? vel_sprint : (is_running ? vel_correr : vel_caminhar);
		// horizontal control
        velh = (right_held - left_held) * max_velh * global.vel_mult;

        aplica_gravidade();
        _set_air_visual_from_velv();

        // landing
        if (chao && velv >= 0)
        {
            velv = 0;
			pode_duplo_salto = true; // <- NOVO: Recarrega o duplo salto ao tocar no chão	
            player_set_state((abs(velh) > 0.1) ? PST_RUN : PST_IDLE);
            break;
        }
		
		// <- NOVO: Lógica do Duplo Salto
        if (jump && pode_duplo_salto)
        {
            velv = -max_velv; // Dá o impulso para cima
            pode_duplo_salto = false; // Gasta o duplo salto
            _air_phase = 0; // Atualiza a animação para "subindo"
            sprite_index = spr_player_jump; 
        }
		// <- NOVO: Iniciar o Ground Slam (Exemplo: segurar Baixo e apertar Ataque)
        if (down && attack)
        {
            player_set_state(PST_GROUND_SLAM);
            break; // Sai do estado atual imediatamente
        }

        if (attack) inicia_ataque(chao);

        if (dash && dash_aereo == true)
        {
            player_set_state(PST_DASH_AIR);
        }
    }
    break;
	
	case PST_CROUCH:
	{
	    velh = 0;
	    // --- Lógica de Animação e Fases ---
	    // FASE: DESCENDO OU SEGURANDO
	    if (down) {
	        crouch_fase = 1; // Estado: Agachado
	        image_speed = 1;
        
	        // Trava no último frame da animação
	        if (image_index >= image_number - 1) {
	            image_index = image_number - 1;
	            image_speed = 0;
	        }
	    } 
	    // FASE: LEVANTANDO (REWIND)
	    else {
	        crouch_fase = 2; // Estado: Levantando
	        image_speed = 0;
	        image_index -= 0.3; // Velocidade do "rewind"

	        // Quando chegar ao frame 0, volta ao estado parado
	        if (image_index <= 0) {
	            image_index = 0;
	            player_set_state(PST_IDLE);
	        }
	    }
	}
	break;
	
	case PST_ROLL:
    {
        // 1. Zera a velocidade normal para o jogador não controlar o boneco
        velh = 0; 
        
        // 2. Aplica a velocidade de impulso baseada para onde o jogador está a olhar (image_xscale)
        // Usamos uma velocidade um pouco maior que o correr normal
        mid_velh = image_xscale * (vel_correr * 2.5); 
        
        // 3. Aplica gravidade (útil se ele rolar para fora de uma plataforma e cair)
        aplica_gravidade();

        // 4. Termina o rolar quando a animação chegar ao fim
        if (image_index >= image_number - 1)
        {
            mid_velh = 0; // Para o impulso
            player_set_state(PST_IDLE); // Volta ao normal
        }
        
        // Opcional: Permitir cancelar o rolar num salto
        if (jump) 
        {
            mid_velh = 0;
            velv = -max_velv;
            player_set_state(PST_JUMP);
        }
    }
    break;

    case PST_ATK:
	{
    velh = 0;
    _apply_attack_visuals(false);

    // CRIAÇÃO DE DANO DINÂMICO
    // Criamos o dano no frame de impacto de cada sprite
    var frame_impacto = (combo == 1) ? 1 : 2; // Punch 2 é rápido (frame 1), outros no frame 2

    if (image_index >= frame_impacto && !instance_exists(dano) && posso)
    {
        // Ajuste a posição do dano baseado na escala do player
        dano = instance_create_layer(x + (15 * image_xscale), y - 55, layer, obj_dano);
        dano.dano = ataque * ataque_mult;
        dano.pai = id;
        posso = false;
    }

    // BUFFER DE COMBO (Janela para apertar o próximo botão)
    if (attack && combo < 2 && image_index >= image_number - 3)
    {
        combo++;
        ataque_mult += 1; // Aumenta o dano progressivamente
        posso = true;
        
        if (instance_exists(dano)) { with (dano) instance_destroy(); dano = noone; }
        _apply_attack_visuals(true);
    }

    // FINALIZAÇÃO
    if (image_index >= image_number - 1)
    {
        player_set_state(PST_IDLE);
    }
}
break;

    case PST_ATK_AIR:
    {
        velh = (right_held - left_held) * max_velh * global.vel_mult;
        aplica_gravidade();
        _set_air_visual_from_velv();

        if (image_index >= 1 && !instance_exists(dano) && posso)
        {
            dano = instance_create_layer(x + sprite_width / 6, y - sprite_height / 9, layer, obj_dano);
            dano.dano = ataque;
            dano.pai = id;
            posso = false;
        }

        if (image_index >= image_number - 1)
        {
            finaliza_ataque();
            player_set_state(PST_JUMP);
        }

        if (chao)
        {
            velv = 0;
            finaliza_ataque();
            player_set_state(PST_IDLE);
        }
		// <- NOVO: Iniciar o Ground Slam (Exemplo: segurar Baixo e apertar Ataque)
        if (down && attack)
        {
            player_set_state(PST_GROUND_SLAM);
            break; // Sai do estado atual imediatamente
        }
    }
    break;
	
	case PST_DEFEND:
    {
	    velh = 0; // Travado no lugar enquanto defende

	    // --- Lógica de Animação e Fases da Defesa ---
    
	    // FASE: DEFENDENDO OU SEGURANDO
	    if (defend) {
	        defesa_fase = 1; 
	        image_speed = 1;
        
	        // Trava no último frame da animação (postura de defesa completa)
	        if (image_index >= image_number - 1) {
	            image_index = image_number - 1;
	            image_speed = 0;
	        }
        
	        // Opcional: Se o jogador apertar Roll enquanto defende, ele esquiva
	        if (roll) {
	            defesa_fase = 0;
	            player_set_state(PST_ROLL);
	        }
	    } 
	    // FASE: SAINDO DA DEFESA (REWIND)
	    else {
	        defesa_fase = 2; 
	        image_speed = 0;
	        image_index -= 0.4; // Velocidade da saída (pode ser mais rápido que o Crouch)

	        // Quando chegar ao frame 0, volta ao estado parado
	        if (image_index <= 0) {
	            image_index = 0;
	            defesa_fase = 0; // Reseta a fase interna
	            player_set_state(PST_IDLE);
	        }
	    }
	}
	break;

    case PST_FIRE:
    {
        velh = 0;
        velv = 0;

        // se o efeito sumiu, encerra
        if (!instance_exists(fire_instance))
        {
            var _sc = instance_find(obj_skill_controller, 0);
            if (_sc != noone) _sc.end_fire(self);
            player_set_state(PST_IDLE);
        }
    }
    break;

    case PST_CHIDORI:
    {
        aplica_gravidade();
        _set_air_visual_from_velv();

        mid_velh = image_xscale * dash_vel_ataque;

        if (image_index >= image_number - 1)
        {
            mid_velh = 0;
            player_set_state(PST_IDLE);
        }
    }
    break;
	
	case PST_GROUND_SLAM:
    {
        // 1. Zera o movimento horizontal para ele cair a direito
        velh = 0; 
        mid_velh = 0;
        
        // 2. Força uma descida muito rápida (o dobro da velocidade máxima de queda)
        velv = max_velv * 2; 

        // 3. O que acontece quando bate no chão?
        if (chao)
        {
            // Para a queda
            velv = 0; 
            
            // Opcional: Adicionar um tremor de ecrã para dar peso ao impacto (já tens o screenshake no PST_HIT!)
            screenshake(4); 
            
            // Futuramente: Criar o obj_dano_area aqui para magoar os inimigos!
            
            // Volta ao estado parado (ou podias criar um estado extra só para a animação de recuperar do impacto)
            player_set_state(PST_IDLE); 
        }
    }
    break;

    case PST_CHAKRA:
    {
        velh = 0;

	// --- Lógica de Regeneração ---
        chakra_timer++;
        if (chakra_timer >= chakra_delay)
        {
            var dt = delta_time / 1000000;
            energia += chakra_regen_rate * dt;
            energia = clamp(energia, 0, energia_max);
        }

    // --- LÓGICA DE ANIMAÇÃO (Loop Parcial Frames 2 a 9) ---
        // O frame 10 (image_number) é o limite. Quando chegar perto do fim, volta pro 2.
        if (image_index >= image_number - 2) 
        {
            image_index = 5; 
        }

        // Se soltar o botão, volta para IDLE
        if (!chakra) player_set_state(PST_IDLE);
    }
    break;
	
	case PST_WALL:
    {
        // 1. Condições de saída (Cair da parede ou tocar no chão)
        if (!parede_dir && !parede_esq) // Se as paredes acabarem
        {
            player_set_state(PST_JUMP);
            break;
        }
        if (chao) // Se escorregar até ao chão
        {
            player_set_state(PST_IDLE);
            break;
        }

        // 2. Orientação do Sprite (vê para que lado está a parede)
        if (parede_dir) image_xscale = 1; // Vira para a direita
        if (parede_esq) image_xscale = -1; // Vira para a esquerda

        // 3. Wall Climbing (Escalar)
        // Desativamos a gravidade colocando o velh a zero, a menos que ele escale
        velh = 0; 
        velv = (down - up) * vel_escalar; // Sobe se pressionar 'up', desce se 'down'

        // 4. Wall Jump (Salto da parede)
        if (jump)
        {
            // Impulso vertical
            velv = -max_velv; 
            
            // Impulso horizontal para o lado oposto da parede usando o mid_velh
            mid_velh = parede_dir ? -max_velh * 1.5 : max_velh * 1.5; 
            
            // Recarrega o duplo salto e o dash aéreo para ele poder usá-los a seguir!
            pode_duplo_salto = true; 
            dash_aereo = true;       
            
            player_set_state(PST_JUMP);
        }
    }
    break;

    case PST_DASH:
    {
        velh = 0;
        mid_velh = image_xscale * dash_vel;

        if (image_index >= image_number - 1)
        {
            mid_velh = 0;
            dash_timer = dash_delay;
            player_set_state(PST_IDLE);
        }
    }
    break;

    case PST_DASH_AIR:
    {
        velv = 0;
        velh = 0;
        dash_aereo = false;

        mid_velh = image_xscale * dash_vel_aereo;
        dash_aereo_timer--;

        if (image_index >= image_number - 1 || dash_aereo_timer <= 0)
        {
            mid_velh = 0;
            player_set_state(PST_JUMP);
        }
    }
    break;

    case PST_HIT:
    {
        velh = 0;
        mid_velh = 0;

        if (vida_atual > 0)
        {
            if (image_index >= image_number - 1) player_set_state(PST_IDLE);
        }
        else
        {
            if (image_index >= image_number - 1) player_set_state(PST_DEAD);
        }
    }
    break;

    case PST_DEAD:
    {
        if (instance_exists(obj_game_controller))
        {
            with (obj_game_controller) game_over = true;
        }

        velh = 0;
        mid_velh = 0;

        if (image_index >= image_number - 1)
            image_index = image_number - 1;
    }
    break;
}

// ----- Movimento e colisão (otimizado) -----
var total_velh = velh + mid_velh;

// Horizontal
if (total_velh != 0) {
    var _sign = sign(total_velh);
    var _move = abs(total_velh);
    if (!place_meeting(x + total_velh, y, obj_block)) {
        x += total_velh;
    } else {
        while (_move > 0 && !place_meeting(x + _sign, y, obj_block)) {
            x += _sign;
            _move--;
        }
        velh = 0;
        mid_velh = 0;
    }
}

// Vertical
if (velv != 0) {
    var _sign = sign(velv);
    var _move = abs(velv);
    if (!place_meeting(x, y + velv, obj_block)) {
        y += velv;
    } else {
        while (_move > 0 && !place_meeting(x, y + _sign, obj_block)) {
            y += _sign;
            _move--;
        }
        velv = 0;
    }
}