/// @function scr_combat_same_team(_attacker, _target)
/// @description Retorna true quando atacante e alvo pertencem à mesma família de entidade.
function scr_combat_same_team(_attacker, _target)
{
    if (!instance_exists(_attacker) || !instance_exists(_target)) return true;
    return object_get_parent(_attacker.object_index) == object_get_parent(_target.object_index);
}

/// @function scr_combat_can_hit_target(_hitbox, _target)
/// @description Valida regras comuns antes de aplicar dano.
function scr_combat_can_hit_target(_hitbox, _target)
{
    if (!instance_exists(_hitbox) || !instance_exists(_target)) return false;
    if (!instance_exists(_hitbox.pai)) return false;
    if (scr_combat_same_team(_hitbox.pai, _target)) return false;
    if (variable_instance_exists(_target, "invencivel") && _target.invencivel) return false;
    if (variable_instance_exists(_target, "hurt_invuln_timer") && _target.hurt_invuln_timer > 0) return false;
    if (!variable_instance_exists(_target, "vida_atual")) return false;
    return true;
}

/// @function scr_combat_is_enemy(_inst)
/// @description Retorna true para qualquer entidade filha de obj_entidade_inimigo.
function scr_combat_is_enemy(_inst)
{
    if (!instance_exists(_inst)) return false;
    return object_get_parent(_inst.object_index) == obj_entidade_inimigo;
}

/// @function scr_combat_is_player(_inst)
/// @description Retorna true para o player principal ou entidades filhas diretas de player.
function scr_combat_is_player(_inst)
{
    if (!instance_exists(_inst)) return false;
    return (_inst.object_index == obj_player || _inst.object_index == obj_entidade_player);
}

/// @function scr_combat_is_training_dummy(_inst)
/// @description Dummy de treino recebe hit visual, mas nao usa IA, knockback, esquiva ou defesa.
function scr_combat_is_training_dummy(_inst)
{
    if (!instance_exists(_inst)) return false;
    return _inst.object_index == obj_dummy;
}

/// @function scr_combat_set_entity_state(_target, _state)
/// @description Troca estado preservando a FSM do player quando existir.
function scr_combat_set_entity_state(_target, _state)
{
    if (!instance_exists(_target)) return;

    if (scr_combat_is_training_dummy(_target))
    {
        if (_state == "dano" || _state == "hit")
        {
            _target.estado = "hit";
            _target.image_index = 0;
            if (variable_instance_exists(_target, "pstate")) _target.pstate = PST_HIT;
        }
        return;
    }

    if (_target.object_index == obj_player && variable_instance_exists(_target, "player_set_state"))
    {
        switch (_state)
        {
            case "dano":
            case "hit":
                _target.player_set_state(PST_HIT);
            break;

            case "morte":
            case "dead":
                _target.player_set_state(PST_DEAD);
            break;
        }
        return;
    }

    if (variable_instance_exists(_target, "enemy_set_state"))
    {
        _target.enemy_set_state(_state);
        return;
    }

    if (variable_instance_exists(_target, "estado"))
    {
        _target.estado = _state;
        _target.image_index = 0;
    }

    if (variable_instance_exists(_target, "pstate"))
    {
        if (_state == "dano" || _state == "hit") _target.pstate = PST_HIT;
        if (_state == "morte" || _state == "dead") _target.pstate = PST_DEAD;
    }
}

/// @function scr_combat_receive_damage(_target, _amount, _origin_x, _skill_id)
/// @description Dano unificado para player e inimigos: vida, defesa, knockback, invulnerabilidade e morte.
function scr_combat_receive_damage(_target, _amount, _origin_x, _skill_id)
{
    if (!instance_exists(_target)) return false;
    if (!variable_instance_exists(_target, "vida_atual")) return false;
    if (variable_instance_exists(_target, "invencivel") && _target.invencivel) return false;
    if (variable_instance_exists(_target, "hurt_invuln_timer") && _target.hurt_invuln_timer > 0) return false;
    if (variable_instance_exists(_target, "estado") && (_target.estado == "morte" || _target.estado == "dead")) return false;

    var amount = max(0, _amount);
    var dir_from_hit = (_origin_x > _target.x) ? -1 : 1;
    var blocked = false;

    if (variable_instance_exists(_target, "pstate") && _target.pstate == PST_DEFEND)
    {
        var lado_ataque = (_origin_x > _target.x) ? 1 : -1;
        if (_target.image_xscale == lado_ataque)
        {
            amount *= 0.1;
            blocked = true;
        }
    }

    var is_dummy = scr_combat_is_training_dummy(_target);

    if (is_dummy && variable_instance_exists(_target, "sprites_hit"))
    {
        _target.hit_index = irandom(array_length(_target.sprites_hit) - 1);
    }

    if (scr_combat_is_enemy(_target) && !is_dummy && variable_instance_exists(_target, "estado"))
    {
        if (_target.estado != "morte" && _target.estado != "dano" && _target.estado != "hit")
        {
            var dodge_chance = variable_global_exists("enemy_dodge_chance") ? global.enemy_dodge_chance : 0;
            var block_chance = variable_global_exists("enemy_block_chance") ? global.enemy_block_chance : 0;
            var sorteio = irandom(99);

            if (sorteio < dodge_chance)
            {
                scr_combat_set_entity_state(_target, "esquiva");
                _target.velh = -dir_from_hit * 6;
                if (variable_instance_exists(_target, "hurt_invuln_timer"))
                {
                    _target.hurt_invuln_timer = variable_instance_exists(_target, "hurt_invuln_frames") ? _target.hurt_invuln_frames : 12;
                }
                return false;
            }

            if (sorteio < dodge_chance + block_chance)
            {
                scr_combat_set_entity_state(_target, "defesa");
                amount *= 0.05;
                blocked = true;
            }
        }
    }

    var was_attacking = variable_instance_exists(_target, "estado") && (_target.estado == "ataque");
    var can_interrupt = !(scr_combat_is_enemy(_target) && !is_dummy && was_attacking && _skill_id == "" && amount < 3);

    _target.last_damage_taken = amount;
    _target.vida_atual = clamp(_target.vida_atual - amount, 0, _target.vida_max);

    if (variable_instance_exists(_target, "mid_velh"))
    {
        if (is_dummy)
        {
            _target.mid_velh = 0;
        }
        else
        {
            var kb = blocked ? 1 : 3;
            if (scr_combat_is_enemy(_target)) kb = blocked ? 1 : 2.5;
            _target.mid_velh = dir_from_hit * kb;
        }
    }

    if (variable_instance_exists(_target, "hurt_invuln_timer"))
    {
        _target.hurt_invuln_timer = variable_instance_exists(_target, "hurt_invuln_frames") ? _target.hurt_invuln_frames : 12;
    }

    if (_target.vida_atual <= 0)
    {
        scr_combat_set_entity_state(_target, (scr_combat_is_enemy(_target) && !is_dummy) ? "morte" : "dead");
    }
    else if (can_interrupt && !blocked)
    {
        scr_combat_set_entity_state(_target, (scr_combat_is_enemy(_target) && !is_dummy) ? "dano" : "hit");
    }

    if (script_exists(screenshake)) screenshake(blocked ? 1 : 3);
    effect_create_above(ef_spark, _target.x, _target.y - 20, 0, blocked ? c_aqua : c_white);
    return true;
}

/// @function scr_combat_apply_damage(_target, _amount, _origin_x, _skill_id)
/// @description Aplica dano usando recebe_dano() quando existir, com fallback seguro.
function scr_combat_apply_damage(_target, _amount, _origin_x, _skill_id)
{
    if (!instance_exists(_target)) return false;
    if (!variable_instance_exists(_target, "vida_atual")) return false;
    return scr_combat_receive_damage(_target, _amount, _origin_x, _skill_id);
}

/// @function scr_combat_grant_skill_xp(_skill_id, _target, _target_died)
/// @description Encapsula XP de skill para evitar acoplamento direto no obj_dano.
function scr_combat_grant_skill_xp(_skill_id, _target, _target_died)
{
    if (_skill_id == "") return;

    var sc = instance_find(obj_skill_controller, 0);
    if (sc != noone)
    {
        sc.grant_xp_on_hit(_skill_id, _target, _target_died);
    }
}

/// @function scr_combat_spawn_damage_number(_target, _amount, _layer)
/// @description Cria o texto flutuante de dano, mantendo fallback para dummy.
function scr_combat_spawn_damage_number(_target, _amount, _layer)
{
    if (!instance_exists(_target)) return noone;

    var base_x = _target.x;
    var base_y = _target.y - (_target.sprite_height / 2);
    var num = instance_create_layer(base_x, base_y, _layer, obj_dano_num);
    num.texto = string(_amount);
    num.cor = (_target.object_index == obj_dummy) ? c_white : c_orange;
    return num;
}

/// @function scr_combat_update_hurt_invulnerability()
/// @description Deve rodar no Step/Begin Step da entidade que usa hurt_invuln_timer.
function scr_combat_update_hurt_invulnerability()
{
    if (variable_instance_exists(self, "hurt_invuln_timer") && hurt_invuln_timer > 0)
    {
        hurt_invuln_timer--;
    }
}

/// @function scr_combat_draw_debug_entity(_inst)
/// @description Desenha hurtbox, range de IA e texto de estado quando global.debug estiver ativo.
function scr_combat_draw_debug_entity(_inst)
{
    if (!variable_global_exists("debug") || !global.debug) return;
    if (!instance_exists(_inst)) return;

    var old_alpha = draw_get_alpha();
    draw_set_alpha(0.35);

    draw_set_color(c_lime);
    draw_rectangle(_inst.bbox_left, _inst.bbox_top, _inst.bbox_right, _inst.bbox_bottom, true);

    if (variable_instance_exists(_inst, "dist_visao"))
    {
        draw_set_color(c_yellow);
        draw_circle(_inst.x, _inst.y, _inst.dist_visao, true);
    }

    if (variable_instance_exists(_inst, "dist_ataque"))
    {
        draw_set_color(c_red);
        draw_circle(_inst.x, _inst.y, _inst.dist_ataque, true);
    }

    draw_set_alpha(old_alpha);
    draw_set_color(c_white);

    if (variable_instance_exists(_inst, "estado"))
    {
        draw_text(_inst.x, _inst.y - _inst.sprite_height, string(_inst.estado));
    }
}

/// @function scr_combat_update_damage_hitbox()
/// @description Engine única do obj_dano. Deve ser chamada de dentro do Step do obj_dano.
function scr_combat_update_damage_hitbox()
{
    if (life != 999999)
    {
        life--;
        if (life <= 0)
        {
            instance_destroy();
            return;
        }
    }

    if (!instance_exists(pai))
    {
        instance_destroy();
        return;
    }

    var lista = ds_list_create();
    var qtd = 0;

    if (variable_instance_exists(self, "range") && range > 0)
    {
        var shape_local = 0;
        if (variable_instance_exists(self, "shape")) shape_local = shape;

        if (shape_local == 1)
            qtd = collision_circle_list(x, y, range, obj_entidade, false, false, lista, false);
        else
            qtd = collision_rectangle_list(x - range, y - range, x + range, y + range, obj_entidade, false, false, lista, false);
    }
    else
    {
        qtd = instance_place_list(x, y, obj_entidade, lista, 0);
    }

    var agora = current_time;

    for (var i = 0; i < qtd; i++)
    {
        var alvo = lista[| i];
        if (!scr_combat_can_hit_target(self, alvo)) continue;

        var key = string(alvo.id);
        var next_ok = 0;
        if (ds_map_exists(tick_map, key)) next_ok = tick_map[? key];
        if (agora < next_ok) continue;

        if (max_hits_por_alvo != -1)
        {
            var hits = 0;
            if (ds_map_exists(hits_map, key)) hits = hits_map[? key];
            if (hits >= max_hits_por_alvo) continue;
            hits_map[? key] = hits + 1;
        }

        var vida_antes = alvo.vida_atual;
        if (scr_combat_apply_damage(alvo, dano, x, skill_id))
        {
            var morreu = (vida_antes > 0 && alvo.vida_atual <= 0);
            scr_combat_grant_skill_xp(skill_id, alvo, morreu);
            var dano_mostrado = variable_instance_exists(alvo, "last_damage_taken") ? alvo.last_damage_taken : dano;
            scr_combat_spawn_damage_number(alvo, dano_mostrado, layer);
        }

        var ms = (tick_frames * 1000) / room_speed;
        tick_map[? key] = agora + ms;
    }

    ds_list_destroy(lista);

    if (morrer)
    {
        instance_destroy();
        return;
    }

    if (!persistente) instance_destroy();
}
