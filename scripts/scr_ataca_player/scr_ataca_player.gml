///@arg player_object
///@arg dist
///@arg xscale
function scr_ataca_player(_player_object, _dist, _xscale) {
    // linha de visão (NOTA: não considera paredes)
    var player = collision_line(
        x,
        y - sprite_height / 2,
        x + (_dist * _xscale),
        y - sprite_height / 2,
        _player_object,
        false,
        true
    );

    if (player) {
        estado = "ataque";
    }
}
