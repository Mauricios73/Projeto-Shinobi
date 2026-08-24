/// @function scr_player_cancel_attack_to(_next_state)
/// @description Cancela ataque atual com reset total antes de trocar para outro estado.
function scr_player_cancel_attack_to(_next_state)
{
    combo = 0;
    ataque_mult = 1;
    finaliza_ataque();
    player_set_state(_next_state);
}

/// @function scr_player_combat_cleanup_hitbox()
/// @description Limpeza defensiva de hitboxes persistentes controladas pelo player.
function scr_player_combat_cleanup_hitbox()
{
    if (pstate != PST_CHIDORI && instance_exists(chidori_hit))
    {
        scr_hitbox_destroy_ref(chidori_hit);
        chidori_hit = noone;
    }

    if (pstate != PST_FIRE && instance_exists(fire_hitbox))
    {
        scr_hitbox_destroy_ref(fire_hitbox);
        fire_hitbox = noone;
    }
}

/// @function scr_player_combat_spawn_ground_hit(_impact_frame)
/// @description Cria a hitbox do combo no chão uma única vez no frame de impacto.
function scr_player_combat_spawn_ground_hit(_impact_frame)
{
    if (image_index < _impact_frame || instance_exists(dano) || !posso) return false;

    dano = scr_hitbox_create_damage(
        id,
        x + (15 * image_xscale),
        y - 55,
        ataque * ataque_mult,
        "",
        0,
        0,
        false,
        6,
        -1,
        999999
    );

    posso = false;
    return instance_exists(dano);
}

/// @function scr_player_combat_spawn_air_hit()
/// @description Cria a hitbox do ataque aéreo uma única vez.
function scr_player_combat_spawn_air_hit()
{
    if (image_index < 1 || instance_exists(dano) || !posso) return false;

    dano = scr_hitbox_create_damage(
        id,
        x + (30 * image_xscale),
        y - 30,
        ataque,
        "",
        0,
        0,
        false,
        6,
        -1,
        999999
    );

    posso = false;
    return instance_exists(dano);
}

/// @function scr_player_combat_spawn_ground_slam()
/// @description Cria o dano em área do Ground Slam.
function scr_player_combat_spawn_ground_slam()
{
    var impacto = scr_hitbox_create_damage(
        id,
        x,
        y,
        ataque * 3,
        "ground_slam",
        42,
        0,
        false,
        6,
        -1,
        999999
    );

    if (instance_exists(impacto)) impacto.image_xscale = 2 * image_xscale;
    return impacto;
}

/// @function scr_player_combat_destroy_current_hit()
/// @description Limpa a hitbox atual de ataque comum.
function scr_player_combat_destroy_current_hit()
{
    if (instance_exists(dano))
    {
        scr_hitbox_destroy_ref(dano);
    }
    dano = noone;
}
