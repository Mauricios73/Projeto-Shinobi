// PATCH C2 - obj_player Create_0.gml
// FSM final: state int + enter/step/exit, mantendo `estado` string por compatibilidade.

// Inherit the parent event
var cam = instance_create_layer(x, y, layer, obj_camera);
cam.alvo = id;

randomise();
event_inherited();

// PATCH C2 - obj_player Create_0.gml
if (!variable_global_exists("potions")) global.potions = 3;

/// -----------------------------
/// Core stats / config
/// -----------------------------
vida_max = 5;
vida_atual = vida_max;

max_velh = 3;
max_velv = 6;

dash_vel = 20;
dash_vel_aereo = 10;
dash_vel_ataque = 30;
dash_aereo_timer = 0;
dash_aereo = true;
dash_delay = 30;
dash_timer = 0;

// --- Variáveis de Double Tap
dash_timer_lateral = 0;
tempo_double_tap = 15; // Tempo em frames para registrar o segundo toque
ultima_tecla_pressionada = 0; // 0 = nenhuma, 1 = direita, 2 = esquerda
is_running = false; // Estado para saber se ativamos a corrida pelo toque duplo

crouch_fase = 0; // 0 = descendo, 1 = segurando, 2 = levantando
defesa_fase = 0; // 0 = entrando na defesa, 1 = segurando, 2 = saindo

on_ground = false;
was_on_ground = false;

invencivel = false;
invencivel_timer = room_speed * 3;
tempo_invencivel = invencivel_timer;

energia_max = 1000;
energia = energia_max;
chakra_regen_rate = 18;         // por segundo
chakra_delay = room_speed * 1.5;
chakra_timer = 0;

chidori_hit = noone;
fire_instance = noone;
fire_hitbox = noone;

// <- NOVO: Variáveis para Andar/Correr e Duplo Salto
// Velocidades de locomoção
vel_caminhar = 1.2;      // Mais lento, para exploração
vel_correr = 2.5;       // Velocidade padrão de deslocamento
vel_sprint = 4.5;       // Corrida rápida (ex: Ninja Run)
pode_duplo_salto = true;
vel_escalar = 2; // <- NOVO: Velocidade de subir e descer a parede

/// ataques
combo = 0;
ataque = 1;
ataque_mult = 1;
posso = true;
pode_dar_dano_slam = true;
dano = noone;
tempo_espera_combo = 0; // Tempo (em frames) que o jogo espera o próximo clique antes de resetar o combo
janela_combo = 20; // Ajuste este valor: quanto maior, mais tempo o jogador tem para apertar


/// controle de power ups (evite resetar global a cada respawn, mas mantive pra compat)
if (!variable_global_exists("power_ups")) global.power_ups = [false];

/// -----------------------------
/// Physics
/// -----------------------------
velh = 0;
velv = 0;
mid_velh = 0;
massa = 1;

/// -----------------------------
/// FSM internal
/// -----------------------------
pstate = PST_IDLE;
pstate_prev = PST_IDLE;

// visual cache
_vis_state = -1;
_vis_combo = -1;
_air_phase = 0; // 0 = subindo, 1 = caindo

/// -----------------------------
/// Helpers
/// -----------------------------
estado_to_pstate = function(_estado)
{
    switch (_estado)
    {
        case "parado":        return PST_IDLE;
        case "movendo":       return PST_RUN;
        case "pulando":       return PST_JUMP;
		case "agachar":       return PST_CROUCH; // <- NOVO
		case "roll":          return PST_ROLL; // <- NOVO
        case "dash":          return PST_DASH;
        case "dash aereo":    return PST_DASH_AIR;
        case "ataque":        return PST_ATK;
        case "ataque aereo":  return PST_ATK_AIR;
		case "defend":        return PST_DEFEND; // <- NOVO
        case "hit":           return PST_HIT;
        case "dead":          return PST_DEAD;
        case "chakra":        return PST_CHAKRA;
        case "fire_breath":   return PST_FIRE;
        case "chidori":       return PST_CHIDORI;
		case "ground_slam":   return PST_GROUND_SLAM; // <- NOVO
		case "wall":          return PST_WALL; // <- NOVO
		case "potion":		  return PST_POTION; // <- NOVO
		case "summon":		  return PST_SUMMON; // <- NOVO
        default:              return PST_IDLE;
    }
};

pstate_to_estado = function(_ps)
{
    switch (_ps)
    {
        case PST_IDLE:			return "parado";
        case PST_RUN:			return "movendo";
        case PST_JUMP:			return "pulando";
		case PST_CROUCH:		return "agachar"; // <- NOVO
		case PST_ROLL:			return "roll"; // <- NOVO
        case PST_DASH:			return "dash";
        case PST_DASH_AIR:		return "dash aereo";
        case PST_ATK:			return "ataque";
        case PST_ATK_AIR:		return "ataque aereo";
		case PST_DEFEND:		return "defend"; // <- NOVO
        case PST_HIT:			return "hit";
        case PST_DEAD:			return "dead";
        case PST_CHAKRA:		return "chakra";
        case PST_FIRE:			return "fire_breath";
        case PST_CHIDORI:		return "chidori";
		case PST_GROUND_SLAM:	return "ground_slam"; // <- NOVO
		case PST_WALL:			return "wall"; // <- NOVO
		case PST_POTION:		return "potion"; // <- NOVO
		case PST_SUMMON:		return "summon"; // <- NOVO
        default:				return "parado";
    }
};

// método para iniciar ataque
inicia_ataque = function(_chao)
{
    if (_chao)
    {
        player_set_state(PST_ATK);
    }
    else
    {
        player_set_state(PST_ATK_AIR);
    }
};

// finaliza ataque
finaliza_ataque = function()
{
    posso = true;
    if (instance_exists(dano))
    {
        with (dano) instance_destroy();
        dano = noone;
    }
};

// gravidade
aplica_gravidade = function()
{
    var _chao = place_meeting(x, y + 1, obj_block);
    if (!_chao)
    {
        if (velv < max_velv * 2)
            velv += GRAVIDADE * massa * global.vel_mult;
    }
};

// visuals
_apply_attack_visuals = function(_force)
{
    if (!_force && _vis_combo == combo && _vis_state == pstate) return;

    // Lógica de Sprites do Combo
    switch(combo) {
        case 0: sprite_index = spr_player_punch1; break; // Punch 1
        case 1: sprite_index = spr_player_punch2; break; // Punch 2
        case 2: sprite_index = spr_player_kick; break; // Kick
    }
    image_index = 0;
    _vis_combo = combo;
    _vis_state = pstate;
};

_apply_state_visuals_enter = function(_ps)
{
    _vis_combo = -1;

    switch (_ps)
    {
        case PST_IDLE:
            sprite_index = spr_player_idle;
            image_index = 0;
        break;

        case PST_RUN:
            sprite_index = spr_player_run;
            image_index = 0;
        break;

        case PST_JUMP:
            // decide fase inicial pelo velv
            _air_phase = (velv >= 0) ? 1 : 0;
            sprite_index = (_air_phase == 0) ? spr_player_jump : spr_player_fall;
            image_index = 0;
        break;
		
		case PST_CROUCH:
            sprite_index = spr_player_crouch; // (Certifica-te que crias este sprite no GameMaker)
            image_index = 0;
        break;
		
		case PST_ROLL: // <- NOVO
            sprite_index = spr_player_roll; // (Tens de criar este sprite!)
            image_index = 0;
            
            // Opcional: Dar invencibilidade rápida durante o rolar
           // invencivel = true;
           // tempo_invencivel = room_speed * 0.5; // Meio segundo de invencibilidade
        break;
		
		case PST_DEFEND: // <- NOVO
            sprite_index = spr_player_defend; // (Vais precisar criar este sprite a defender)
            image_index = 0;
            // Se for um Magic Shield, podes criar um efeito visual aqui no futuro!
        break;

        case PST_DASH:
            sprite_index = spr_player_dash;
            image_index = 0;
        break;

        case PST_DASH_AIR:
            sprite_index = spr_player_dash_aereo;
            image_index = 0;
            dash_aereo_timer = room_speed / 2;
        break;

        case PST_ATK:
            _apply_attack_visuals(true);
        break;

		case PST_ATK_AIR:
            sprite_index = spr_player_jump_kick;
            image_index = 0;
            image_speed = 1.2; // Ataques aéreos costumam ser um pouco mais rápidos
            posso = true;      // Garante que o dano pode ser criado
        break;

        case PST_CHIDORI:
            sprite_index = spr_player_dash_ataque;
            image_index = 0;
        break;

        case PST_FIRE:
            sprite_index = spr_player_jutsu;
            image_index = 0;
            image_speed = 1;
        break;
		
		case PST_POTION:
		    sprite_index = spr_player_potion;
		    image_index = 0;
		    image_speed = 1; 
		break;
		
		case PST_SUMMON:
			sprite_index = spr_player_jutsu_1;
			image_index = 0;
		break;
		
		case PST_GROUND_SLAM: // <- NOVO
            sprite_index = spr_player_ground_slam; // (Cria este sprite caindo com a arma/pé para baixo)
            image_index = 0;
        break;
		
		case PST_WALL: // <- NOVO
            sprite_index = Wall_Jump; // (Terás de criar este sprite a agarrar a parede)
            image_index = 0;
        break;

        case PST_CHAKRA:
            sprite_index = spr_player_chakra;
            image_index = 0;
            image_speed = 1;
            chakra_timer = 0;
        break;

        case PST_HIT:
            sprite_index = spr_player_hit;
            image_index = 0;
            screenshake(3);

            invencivel = true;
            tempo_invencivel = invencivel_timer;
        break;

        case PST_DEAD:
            sprite_index = spr_player_death;
            image_index = 0;
        break;
    }

    _vis_state = _ps;
};

// exit hook
_on_exit_state = function(_old, _new)
{
	if (_old == PST_DEFEND) {
	    defesa_fase = 0;
	    image_speed = 1;
	}
    // saindo de ataque: reset total de combo/mult e limpa dano
    if (_old == PST_ATK && _new != PST_ATK)
    {
        combo = 0;
        ataque_mult = 1;
        finaliza_ataque();
    }

    if (_old == PST_ATK_AIR && _new != PST_ATK_AIR)
    {
        finaliza_ataque();
    }

    // saindo de chidori, garante hitbox destruída
    if (_old == PST_CHIDORI && _new != PST_CHIDORI)
    {
        if (instance_exists(chidori_hit))
        {
            with (chidori_hit) instance_destroy();
            chidori_hit = noone;
        }
    }

    // saindo fire: (skill controller também cuida, mas protege)
    if (_old == PST_FIRE && _new != PST_FIRE)
    {
        if (instance_exists(fire_hitbox))
        {
            with (fire_hitbox) instance_destroy();
            fire_hitbox = noone;
        }
    }
	// NOVO: Ao sair do estado de Chakra
	if (_old == PST_CHAKRA) {
        image_index = 0; // Reseta para a pose inicial ao soltar o botão
        image_speed = 1; 
    } 
	
	if (_old == PST_GROUND_SLAM)
    {
        pode_dar_dano_slam = true;
        image_speed = 1; // Garante que a velocidade volta ao normal
    }
};

// central transition
player_set_state = function(_new)
{
    if (pstate == _new) return;

    _on_exit_state(pstate, _new);

    pstate_prev = pstate;
    pstate = _new;
    estado = pstate_to_estado(pstate);

    // enter
    _apply_state_visuals_enter(pstate);
};

// sync external `estado`
player_sync_state_from_string = function()
{
    var desired = estado_to_pstate(estado);
    if (desired != pstate)
    {
        // troca via set_state para aplicar hooks/visuais
        player_set_state(desired);
    }
};

// init string state (compat)
if (!variable_instance_exists(self, "estado")) estado = "parado";
pstate = estado_to_pstate(estado);
pstate_prev = pstate;
_apply_state_visuals_enter(pstate);

