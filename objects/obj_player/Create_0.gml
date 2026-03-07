// PATCH C2 - obj_player Create_0.gml
// FSM final: state int + enter/step/exit, mantendo `estado` string por compatibilidade.

// Inherit the parent event
var cam = instance_create_layer(x, y, layer, obj_camera);
cam.alvo = id;

randomise();
event_inherited();

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

/// -----------------------------
/// Core stats / config
/// -----------------------------
vida_max = 1;
vida_atual = vida_max;

max_velh = 4;
max_velv = 8;

dash_vel = 20;
dash_vel_aereo = 10;
dash_vel_ataque = 30;

dash_aereo_timer = 0;
dash_aereo = true;

dash_delay = 30;
dash_timer = 0;

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

/// ataques
combo = 0;
ataque = 1;
ataque_mult = 1;
posso = true;
dano = noone;

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
        case "dash":          return PST_DASH;
        case "dash aereo":    return PST_DASH_AIR;
        case "ataque":        return PST_ATK;
        case "ataque aereo":  return PST_ATK_AIR;
        case "hit":           return PST_HIT;
        case "dead":          return PST_DEAD;
        case "chakra":        return PST_CHAKRA;
        case "fire_breath":   return PST_FIRE;
        case "chidori":       return PST_CHIDORI;
        default:              return PST_IDLE;
    }
};

pstate_to_estado = function(_ps)
{
    switch (_ps)
    {
        case PST_IDLE:      return "parado";
        case PST_RUN:       return "movendo";
        case PST_JUMP:      return "pulando";
        case PST_DASH:      return "dash";
        case PST_DASH_AIR:  return "dash aereo";
        case PST_ATK:       return "ataque";
        case PST_ATK_AIR:   return "ataque aereo";
        case PST_HIT:       return "hit";
        case PST_DEAD:      return "dead";
        case PST_CHAKRA:    return "chakra";
        case PST_FIRE:      return "fire_breath";
        case PST_CHIDORI:   return "chidori";
        default:            return "parado";
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

    if (combo == 0)      sprite_index = spr_player_ataque1;
    else if (combo == 1) sprite_index = spr_player_ataque2;
    else                 sprite_index = spr_player_ataque3;

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
            sprite_index = spr_player_ataque2;
            image_index = 0;
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

        case PST_CHAKRA:
            sprite_index = Summon_Ally;
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
