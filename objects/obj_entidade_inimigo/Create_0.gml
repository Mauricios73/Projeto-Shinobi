// OBJ_ENTIDADE_INIMIGO - CREATE EVENT
event_inherited();

/// --- FSM do Inimigo ---
pstate = 0; 
massa = 1;
velh = 0;
velv = 0;
vida_max = 10;
vida_atual = vida_max;
estado = "parado";
ataque = 1; // IMPORTANTE: Defina um valor base de ataque aqui

// --- Variáveis de Controle de Combate ---
// Você PRECISA dessas aqui no pai para a função 'atacando' não dar erro
dano = noone;
posso = true;

///@method atacando()
atacando = function(_sprite_index, _image_index_min, _image_index_max, _dist_x, _dist_y)
{
    mid_velh = 0;
    velh = 0;
    
    if (sprite_index != _sprite_index){
        image_index = 0;
        sprite_index = _sprite_index;
        posso = true;
        dano = noone;
    }
        
    // Ao acabar a animação, volta para o estado parado
    if (image_index > image_number - 1){
        estado = "parado";
    }  
        
    // Criando o objeto de dano (Hitbox)
    // Usamos 'image_xscale' para o dano sair para o lado certo
    if (image_index >= _image_index_min && dano == noone && image_index < _image_index_max && posso){
        var _x_final = x + (_dist_x * image_xscale); 
        dano = instance_create_layer(_x_final, y + _dist_y, layer, obj_dano);
        dano.dano = ataque;
        dano.pai = id;
        posso = false;    
    }

    // Destruindo o dano se ele ainda existir após o frame máximo
    if (instance_exists(dano) && image_index >= _image_index_max){
        instance_destroy(dano);
        dano = noone;
    }
}