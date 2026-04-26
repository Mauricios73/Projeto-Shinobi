// obj_inimigo_esqueleto - CREATE EVENT
// Inherit the parent event
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

posso = true; //testa se pode criar o dano

// No Create do obj_inimigo_esqueleto
recebe_dano = function(_valor, _origem_x) {
    if (estado == "dead" || vida_atual <= 0) exit;

    vida_atual -= _valor;

    if (vida_atual <= 0) {
        vida_atual = 0;
        estado = "dead";
        image_index = 0;
    } else {
        // Super Armor: Só entra em HIT se NÃO estiver atacando
        if (estado != "ataque") {
            estado = "hit";
            image_index = 0;
        }
        effect_create_above(ef_spark, x, y - 20, 0, c_white);
    }
}