/// @function scr_player_state_machine_pre_step()
/// @description Gates globais da FSM: invencibilidade, sync externo, morte e ações globais.
function scr_player_state_machine_pre_step()
{
    // Invencibilidade blink.
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

    // Sync caso algum sistema externo altere `estado`.
    player_sync_state_from_string();

    // Dead gate: bloqueia input/skills quando morrer.
    if (vida_atual <= 0 && pstate != PST_DEAD) {
        estado = "dead";
        player_set_state(PST_DEAD);
    }

    if (pstate == PST_DEAD)
    {
        if (instance_exists(obj_game_controller)) with (obj_game_controller) game_over = true;
        velh = 0; velv = 0; mid_velh = 0;
        if (image_index >= image_number - 1) image_index = image_number - 1;
        return false;
    }

    scr_player_skills_handle_global_actions();
    return true;
}

/// @function scr_player_state_machine_step()
/// @description Executa o switch principal da FSM do obj_player.
function scr_player_state_machine_step()
{
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
    		    if (jump && abs(velh) < 0.5) velv = 0; 
    		    else velv = (-max_velv * (jump ? 1 : 0));
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
            // 1. Transição para agarrar na parede
            if (!chao && ((parede_dir && right_held) || (parede_esq && left_held)))
            {
                player_set_state(PST_WALL);
                break;
            }
    		
            max_velh = run ? vel_sprint : (is_running ? vel_correr : vel_caminhar);
            velh = (right_held - left_held) * max_velh * global.vel_mult;
    		
            // --- LÓGICA DO SALTO PARADO (LEAP) ---
            var pode_aterissar = true; // Variável de controle para não cancelar o pulo
    
            if (sprite_index == spr_player_leap) 
            {
                image_speed = 1;
                
                // Bloqueia a aterrissagem enquanto prepara o pulo no chão
                if (image_index < 5) 
                {
                    pode_aterissar = false; 
                    velv = 0; 
                    velh = 0; // Opcional: trava o movimento horizontal no "squat" do pulo
                }
                
                // Frame 5: Momento do impulso físico
                if (image_index >= 5 && image_index < 5.2 && velv == 0) 
                {
                    velv = -max_velv; 
                }
            }
    
            scr_player_apply_gravity();
            scr_player_set_air_visual_from_velv();
    
            // 2. Landing (Tocar no chão)
            // Só volta para IDLE se não estiver na fase de preparação do salto parado
            if (chao && velv >= 0 && pode_aterissar)
            {
                velv = 0;
                pode_duplo_salto = true;	
                player_set_state((abs(velh) > 0.1) ? PST_RUN : PST_IDLE);
                break;
            }
    		
            // 3. Duplo Salto
            if (jump && pode_duplo_salto)
            {
                velv = -max_velv;
                pode_duplo_salto = false;
                _air_phase = 0;
                sprite_index = spr_player_jump; // Duplo salto usa sempre a sprite de movimento
            }
    
            if (down && attack) { player_set_state(PST_GROUND_SLAM); break; }
            if (attack) inicia_ataque(chao);
            if (dash && dash_aereo == true) player_set_state(PST_DASH_AIR);
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
            scr_player_apply_gravity();
    
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
    
        // Cria a hitbox do combo no frame de impacto.
        var frame_impacto = (combo == 1) ? 1 : 2;
        scr_player_combat_spawn_ground_hit(frame_impacto);
    		// --- AJUSTE DE FLUIDEZ DO COMBO ---
            if (attack && combo < 2) 
            {
                // Verificamos se já passamos do começo da animação para não pular frames
                // Se o jogador apertar muito cedo, o combo incrementa e a função visual reseta o frame
                combo++;
                ataque_mult++;
                posso = true;
    			tempo_espera_combo = 0; // Reseta o cronômetro pois ele apertou
    
                scr_player_combat_destroy_current_hit();
                _apply_attack_visuals(true); // Isso vai resetar o image_index para 0 do PRÓXIMO golpe
            }
    		// --- FIM DA ANIMAÇÃO ---
            if (image_index >= image_number - 1)
            {
                image_speed = 0; // Para a animação no último frame (pose de ataque)
                image_index = image_number - 1;
                
                tempo_espera_combo++; // Começa a contar o tempo de espera "tarde"
                
                // Se o tempo acabar ou o jogador se mover, aí sim resetamos
                if (tempo_espera_combo >= janela_combo || right_held || left_held || jump)
                {
                    combo = 0;
                    ataque_mult = 1;
                    tempo_espera_combo = 0;
                    image_speed = 1; // Devolve a velocidade da animação
                    finaliza_ataque();
                    player_set_state(PST_IDLE);
                }
            }
            else 
            {
                image_speed = 1; // Garante que a animação roda enquanto não chega ao fim
            }
    
            // cancels
            if (dash && dash_timer <= 0) scr_player_cancel_attack_to(PST_DASH);
            if (velv != 0) scr_player_cancel_attack_to(PST_JUMP);
        }
        break;
    
        case PST_ATK_AIR:
    {
            // 1. Movimentação: Permite um leve controle horizontal durante o chute
            velh = (right_held - left_held) * (max_velh * 0.5) * global.vel_mult;
            scr_player_apply_gravity();
            
            // IMPORTANTE: NÃO chamamos scr_player_set_air_visual_from_velv() aqui para não resetar o sprite do chute!
    
            // 2. Criação do Dano (Baseado no frame de impacto da animação)
            scr_player_combat_spawn_air_hit();
    
            // 3. Finalização por fim de animação
            if (image_index >= image_number - 1)
            {
                finaliza_ataque();
                player_set_state(PST_JUMP); // Volta para o estado de pulo para processar a queda
            }
    
            // 4. Finalização por toque no chão (Cancelamento de impacto)
            if (chao)
            {
                velv = 0;
                finaliza_ataque();
                player_set_state(PST_IDLE);
            }
    
            // 5. Transição para Ground Slam (Se o jogador quiser cancelar o chute em um slam)
            if (down && attack)
            {
                finaliza_ataque();
                player_set_state(PST_GROUND_SLAM);
                break;
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
    	    velh = 0; velv = 0;
        
    	    if (image_index < 3) {
    	        image_speed = 1;
    	    } else {
    	        image_index = 3; // Trava na pose de sopro
    	        image_speed = 0;
    
    	        if (!instance_exists(fire_instance)) {
    	            // Criamos a skill. Ela mesma vai gerenciar sua hitbox e tempo.
    	            var fx = instance_create_layer(x, y, layer, obj_skill_fire_breath);
    	            fx.owner = id;
    	            fire_instance = fx;
    	        }
    	    }
    
    	    // Se a skill acabou (foi destruída), o player volta ao IDLE
    	    if (image_index >= 3 && !instance_exists(fire_instance)) {
    	        player_set_state(PST_IDLE);
    	    }
    	}
    	break;
    
        case PST_CHIDORI:
    	{
    	    scr_player_apply_gravity();
    	    mid_velh = image_xscale * dash_vel_ataque;
    
    	    // Se bater em parede ou acabar a animação
    	    if (place_meeting(x + sign(mid_velh), y, obj_block) || image_index >= image_number - 1)
    	    {
    	        mid_velh = 0;
    	        player_set_state(PST_IDLE);
    	    }
    	}
    	break;
    	
    	case PST_GROUND_SLAM:
    	{
            velh = 0; 
            mid_velh = 0;
            
            // 1. DESCIDA
            if (!chao)
            {
                velv = max_velv * 2.5; 
                image_speed = 0; 
                image_index = 0; // Mantém o frame de "preparação" no ar
                pode_dar_dano_slam = true; // Garante que está pronto para o impacto
            }
            // 2. IMPACTO
            else 
            {
                // Se ainda não criamos o dano deste impacto
                if (pode_dar_dano_slam) 
                {
                    velv = 0;
                    screenshake(6);
                    
                    // Criar o dano em área padronizado
                    var _impacto = scr_player_combat_spawn_ground_slam();
    
                    pode_dar_dano_slam = false; // "Trava" para não criar mais de um dano
                    image_index = 1; // Pula para o frame de impacto da animação
                    image_speed = 1; // Começa a rodar a animação de recuperação
                }
    
                // 3. FINALIZAÇÃO (Sempre após a animação acabar)
                if (image_index >= image_number - 1)
                {
                    player_set_state(PST_IDLE);
                }
            }
        }
        break;
    	
    	case PST_TELEPORT_OUT:
    	{
    	    if (image_index >= image_number - 1) 
    	    {
    	        x = target_x;
    	        y = target_y;
            
    	        // AO CHAMAR ISSO, o _apply_state_visuals_enter será executado
    	        // e criará o segundo efeito de Kamuy no destino automaticamente.
    	        player_set_state(PST_TELEPORT_IN); 
    	    }
    	}
    	break;	
    
    	case PST_TELEPORT_IN:
    	{
    	    // Quando terminar de aparecer, volta ao normal
    	    if (image_index >= image_number - 1) 
    	    {
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
    	
    	case PST_POTION:
    	{
    	    // O player não se move enquanto bebe
    	    velh = 0;
    	    velv = 0;
    	    scr_player_apply_gravity();
    
    	    // Lógica de Cura: 
    	    // Vamos esperar chegar no frame onde ele realmente bebe (ex: frame 4)
    	    if (image_index >= 4 && !potion_healed) 
    	    {
    	        if (vida_atual < vida_max) {
    	            vida_atual = clamp(vida_atual + 5, 0, vida_max);
    	        }
    	        potion_healed = true;
    	    }
    
    	    // Finaliza o estado quando a animação acabar
    	    if (image_index >= image_number - 1) 
    	    {
    	        player_set_state(PST_IDLE);
    	    }
    	}
    	break;
    	
    	case PST_SUMMON:
    	{
    	    velh = 0; // O player fica parado durante o jutsu
    	    image_speed = 1;
    
    	    // 1. CHECAGEM DO FRAME DE DISPARO (Frame 6 de 7)
    	    // Criamos o aliado quando o player atinge o frame final da animação
    	    if (image_index >= 6 && !summon_spawned && !instance_exists(obj_ally)) 
    	    {
    	        var _dist = 64 * image_xscale;
    	        instance_create_layer(x + _dist, y, layer, obj_ally);
    	        summon_spawned = true;
            
    	        // Efeito visual nativo para marcar a chegada
    	        effect_create_above(ef_smoke, x + _dist, y, 1, c_white);
            
    	        if (script_exists(screenshake)) screenshake(2);
    	    }
    
    	    // 2. A TRAVA (O Pulo do Gato)
    	    // Se chegamos no último frame (6) mas o aliado ainda não existe ou 
    	    // ainda está na animação de "spawn", travamos o frame do player
    	    if (image_index >= 6)
    	    {
    	        if (!instance_exists(obj_ally)) 
    	        {
    	            image_index = 6; // Trava no frame 6
    	        } 
    	        else if (obj_ally.estado == "spawn") 
    	        {
    	            image_index = 6; // Mantém travado enquanto o aliado está "nascendo"
    	        }
    	    }
    
    	    // 3. LIBERAÇÃO
    	    // Só volta para o IDLE quando o aliado terminar de aparecer (mudar para idle)
    	    if (instance_exists(obj_ally) && obj_ally.estado != "spawn") 
    	    {
    	        summon_spawned = false;
    	        player_set_state(PST_IDLE);
    	    }
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
    
    
}
