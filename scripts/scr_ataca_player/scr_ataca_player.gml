/// @function scr_ataca_entidade(_dist, _xscale)
function scr_ataca_entidade(_dist, _xscale) {
    // Procura o Player ou o Aliado mais próximo
    var _alvo_p = instance_nearest(x, y, obj_player);
    var _alvo_a = instance_nearest(x, y, obj_ally);
    var _alvo_final = noone;

    // Define quem é o alvo mais próximo no momento
    if (_alvo_p != noone && _alvo_a != noone) {
        _alvo_final = (distance_to_object(_alvo_p) < distance_to_object(_alvo_a)) ? _alvo_p : _alvo_a;
    } else {
        _alvo_final = (_alvo_p != noone) ? _alvo_p : _alvo_a;
    }

    // Se houver um alvo no alcance e na frente (direção do xscale)
    if (_alvo_final != noone && distance_to_object(_alvo_final) <= _dist) {
        var _dir_alvo = sign(_alvo_final.x - x);
        if (_dir_alvo == _xscale || _dir_alvo == 0) {
            estado = "ataque";
        }
    }
}