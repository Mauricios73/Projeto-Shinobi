invencivel = false;

vida_max = 1;
vida_atual = vida_max;

velh = 0;
velv = 0;

max_velh = 1;
max_velv = 1;

massa = 1;
ataque = 1;

xscale = 1;

mostra_estado = false;
img_spd = 35;

estado = "parado";


/// ============================================================
/// COLISÃO FÍSICA DO PLAYER
/// ============================================================
/// IMPORTANTE:
/// Esta caixa NÃO muda conforme a animação.
/// A sprite nunca deve controlar a colisão física.
/// ============================================================

col_left   = -7;
col_right  =  7;

col_top    = -22;
col_bottom = 10;


/// ============================================================
/// MOVIMENTO SUBPIXEL
/// ============================================================

move_rem_x = 0;
move_rem_y = 0;


/// ============================================================
/// CONTATOS COM O CENÁRIO
/// ============================================================

on_ground   = false;
hit_ceiling = false;

wall_left  = false;
wall_right = false;


/// ============================================================
/// SENSORES
/// ============================================================

wall_probe    = 2;
ground_probe  = 2;
ceiling_probe = 2;


/// ============================================================
/// WALL SYSTEM
/// ============================================================

wall_sliding  = false;
wall_grabbing = false;


/// ============================================================
/// WALL JUMP
/// ============================================================
/// Valores centralizados para facilitar o balanceamento.
/// ============================================================

wall_jump_h = 5;
wall_jump_v = 7;


/// Quantos pixels o player tenta se afastar
/// da parede antes do impulso.
wall_jump_push = 3;


/// Quantos frames o sistema considera que o player
/// acabou de executar um Wall Jump.
wall_jump_lock = 0;


/// Velocidade máxima durante Wall Slide.
wall_slide_speed = 1.5;


/// ============================================================
/// FUNÇÃO DE COLISÃO FÍSICA
/// ============================================================

collision_player = function(_px, _py)
{
    return collision_rectangle(
        _px + col_left,
        _py + col_top,
        _px + col_right,
        _py + col_bottom,
        obj_block,
        false,
        true
    ) != noone;
};


/// ============================================================
/// SENSOR DE CHÃO
/// ============================================================

player_on_ground = function(_px, _py)
{
    return collision_rectangle(
        _px + col_left + 1,
        _py + col_bottom,
        _px + col_right - 1,
        _py + col_bottom + ground_probe,
        obj_block,
        false,
        true
    ) != noone;
};


/// ============================================================
/// SENSOR DE PAREDE ESQUERDA
/// ============================================================

player_wall_left = function(_px, _py)
{
    return collision_rectangle(
        _px + col_left - wall_probe,
        _py + col_top + 3,
        _px + col_left,
        _py + col_bottom - 3,
        obj_block,
        false,
        true
    ) != noone;
};


/// ============================================================
/// SENSOR DE PAREDE DIREITA
/// ============================================================

player_wall_right = function(_px, _py)
{
    return collision_rectangle(
        _px + col_right,
        _py + col_top + 3,
        _px + col_right + wall_probe,
        _py + col_bottom - 3,
        obj_block,
        false,
        true
    ) != noone;
};


/// ============================================================
/// SENSOR DE TETO
/// ============================================================

player_hit_ceiling = function(_px, _py)
{
    return collision_rectangle(
        _px + col_left + 1,
        _py + col_top - ceiling_probe,
        _px + col_right - 1,
        _py + col_top,
        obj_block,
        false,
        true
    ) != noone;
};