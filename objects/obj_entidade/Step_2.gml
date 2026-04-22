// obj_entidade - End Step

// Horizontal
if (velh != 0) {
    var _sign = sign(velh);
    var _move = abs(velh);
    // Tenta mover tudo de uma vez, se não colidir
    if (!place_meeting(x + velh, y, obj_block)) {
        x += velh;
    } else {
        // Move até colidir
        while (_move > 0 && !place_meeting(x + _sign, y, obj_block)) {
            x += _sign;
            _move--;
        }
        velh = 0; // para após colidir
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