// obj_entidade_inimigo - Create
event_inherited();

// FSM do inimigo
pstate = PST_IDLE;
massa = 1;
velh = 0;
velv = 0;
vida_max = 10;
vida_atual = vida_max;
estado = "idle";
ataque = 1;

// Controle de combate
dano = noone;
posso = true;

enemy_state_enter = function(_state)
{
    image_index = 0;
    estado = _state;

    switch (_state)
    {
        case "idle":
        case "parado":
            estado = "idle";
            pstate = PST_IDLE;
        break;

        case "patrulha":
        case "movendo":
        case "perseguicao":
            pstate = PST_RUN;
        break;

        case "ataque":
            pstate = PST_ATK;
        break;

        case "dano":
        case "hit":
            estado = "dano";
            pstate = PST_HIT;
        break;

        case "morte":
        case "dead":
            estado = "morte";
            pstate = PST_DEAD;
        break;
    }
}

enemy_set_state = function(_state)
{
    var next_state = _state;
    if (next_state == "parado") next_state = "idle";
    if (next_state == "movendo") next_state = "patrulha";
    if (next_state == "hit") next_state = "dano";
    if (next_state == "dead") next_state = "morte";

    if (estado == next_state) return;
    enemy_state_enter(next_state);
}

atacando = function(_sprite_index, _image_index_min, _image_index_max, _dist_x, _dist_y)
{
    mid_velh = 0;
    velh = 0;

    if (sprite_index != _sprite_index)
    {
        image_index = 0;
        sprite_index = _sprite_index;
        posso = true;
        dano = noone;
    }

    if (image_index > image_number - 1)
    {
        enemy_set_state("idle");
    }

    if (image_index >= _image_index_min && dano == noone && image_index < _image_index_max && posso)
    {
        var _x_final = x + (_dist_x * image_xscale);
        dano = scr_hitbox_create_damage(id, _x_final, y + _dist_y, ataque, "", 0, 0, false, 6, 1, 999999);
        posso = false;
    }

    if (instance_exists(dano) && image_index >= _image_index_max)
    {
        instance_destroy(dano);
        dano = noone;
    }
}
