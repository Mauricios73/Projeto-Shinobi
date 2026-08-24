/// @function scr_player_apply_gravity()
/// @description Aplica gravidade no obj_player respeitando chão, massa e multiplicador global.
function scr_player_apply_gravity()
{
    var _chao = place_meeting(x, y + 1, obj_block);
    if (!_chao)
    {
        if (velv < max_velv * 2)
            velv += GRAVIDADE * massa * global.vel_mult;
    }
}

/// @function scr_player_set_air_visual_from_velv()
/// @description Atualiza sprite de subida/queda sem reiniciar a animação de preparação do leap.
function scr_player_set_air_visual_from_velv()
{
    if (sprite_index == spr_player_leap && image_index < 5) return;

    var new_phase = (velv >= 0) ? 1 : 0;
    if (new_phase != _air_phase)
    {
        _air_phase = new_phase;
        sprite_index = (_air_phase == 0) ? spr_player_jump : spr_player_fall;
        image_index = 0;
        _vis_state = pstate;
    }
}

/// @function scr_player_physics_apply_movement()
/// @description Resolve movimento horizontal/vertical e colisão contra obj_block.
function scr_player_physics_apply_movement()
{
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
}
