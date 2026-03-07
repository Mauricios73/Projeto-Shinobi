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

var right = keyboard_check(global.key_right);
var left  = keyboard_check(global.key_left);
var jump  = keyboard_check(global.key_up);

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

// cooldowns
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

        velh = (right - left) * max_velh * global.vel_mult;

        if (velh != 0) player_set_state(PST_RUN);
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
        velh = (right - left) * max_velh * global.vel_mult;

        if (abs(velh) < 0.1)
        {
            velh = 0;
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
    }
    break;

    case PST_JUMP:
    {
        // horizontal control
        velh = (right - left) * max_velh * global.vel_mult;

        aplica_gravidade();
        _set_air_visual_from_velv();

        // landing
        if (chao && velv >= 0)
        {
            velv = 0;
            player_set_state((abs(velh) > 0.1) ? PST_RUN : PST_IDLE);
            break;
        }

        if (attack) inicia_ataque(chao);

        if (dash && dash_aereo == true)
        {
            player_set_state(PST_DASH_AIR);
        }
    }
    break;

    case PST_ATK:
    {
        velh = 0;

        // troca sprite só quando combo muda
        _apply_attack_visuals(false);

        // cria dano uma vez
        if (image_index >= 1 && !instance_exists(dano) && posso)
        {
            dano = instance_create_layer(x + sprite_width / 6, y - sprite_height / 9, layer, obj_dano);
            dano.dano = ataque * ataque_mult;
            dano.pai = id;
            dano.persistente = false;
            posso = false;
        }

        // buffer combo
        if (attack && combo < 2 && image_index >= image_number - 4)
        {
            combo++;
            ataque_mult++;
            posso = true;

            // destrói dano atual e recomeça animação
            if (instance_exists(dano))
            {
                with (dano) instance_destroy();
                dano = noone;
            }

            _apply_attack_visuals(true);
        }

        // fim da animação
        if (image_index > image_number - 1)
        {
            combo = 0;
            ataque_mult = 1;
            finaliza_ataque();
            player_set_state(PST_IDLE);
        }

        // cancels
        if (dash && dash_timer <= 0) _cancel_attack_to(PST_DASH);

        if (velv != 0) _cancel_attack_to(PST_JUMP);
    }
    break;

    case PST_ATK_AIR:
    {
        velh = (right - left) * max_velh * global.vel_mult;
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

    case PST_CHAKRA:
    {
        velh = 0;

        chakra_timer++;

        if (chakra_timer >= chakra_delay)
        {
            // regen por segundo
            var dt = delta_time / 1000000;
            energia += chakra_regen_rate * dt;
            energia = clamp(energia, 0, energia_max);
        }

        if (!chakra) player_set_state(PST_IDLE);
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

// camera facing
if (velh != 0) image_xscale = sign(velh);
if (mid_velh != 0) image_xscale = sign(mid_velh);