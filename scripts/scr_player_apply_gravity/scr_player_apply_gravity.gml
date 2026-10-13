/// ============================================================
/// SCR_PLAYER_APPLY_GRAVITY
/// ============================================================

function scr_player_apply_gravity()
{
    if (!place_meeting(x, y + 1, obj_block))
    {
        if (velv < max_velv * 2)
            velv += GRAVIDADE * massa * global.vel_mult;
    }
}

function scr_player_set_air_visual_from_velv()
{
    if (sprite_index == spr_player_leap)
        return;

    var _phase = (velv < 0) ? 0 : 1;

    if (_phase != _air_phase)
    {
        _air_phase = _phase;
        sprite_index = (_phase == 0) ? spr_player_jump : spr_player_fall;
        image_index = 0;
        image_speed = img_spd / room_speed * global.vel_mult;
        _vis_state = pstate;
    }
}

function scr_player_physics_apply_movement()
{
    var total_velh = velh + mid_velh;

    if (total_velh != 0)
    {
        var _sign = sign(total_velh);
        var _move = abs(total_velh);

        if (!place_meeting(x + total_velh, y, obj_block))
        {
            x += total_velh;
        }
        else
        {
            while (_move > 0 && !place_meeting(x + _sign, y, obj_block))
            {
                x += _sign;
                _move--;
            }

            velh = 0;
            mid_velh = 0;
        }
    }

    if (velv != 0)
    {
        var _sign = sign(velv);
        var _move = abs(velv);

        if (!place_meeting(x, y + velv, obj_block))
        {
            y += velv;
        }
        else
        {
            while (_move > 0 && !place_meeting(x, y + _sign, obj_block))
            {
                y += _sign;
                _move--;
            }

            velv = 0;
        }
    }
}