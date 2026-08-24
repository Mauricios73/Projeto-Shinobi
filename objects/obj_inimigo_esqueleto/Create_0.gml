// obj_inimigo_esqueleto - Create
event_inherited();

vida_max = 50;
vida_atual = vida_max;

max_velh = 1;
max_velv = 1;

mostra_estado = true;

timer_estado = 0;

dist = 70;
dano = noone;
ataque = 1;

posso = true;

recebe_dano = function(_valor, _origem_x, _skill_id = "") {
    return scr_combat_receive_damage(id, _valor, _origem_x, _skill_id);
}
