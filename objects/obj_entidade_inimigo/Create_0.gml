// Inherit the parent event
event_inherited();

/// --- FSM do Inimigo ---
pstate = 0; // Estado inicial (IDLE)

// Garante que o estado em string também comece correto
if (!variable_instance_exists(id, "estado")) estado = "parado";

///@method atacando()
///@args _sprite_index _image_index_min _image_index_max _dist_x _dist_y
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
		
	if (image_index > image_number -1){
		estado = "parado";
	} 
		
	//criando dano  
		if (image_index >= _image_index_min && dano == noone && image_index < _image_index_max && posso){
		dano = instance_create_layer(x + _dist_x, y + _dist_y, layer, obj_dano);
		dano.dano = ataque;
		dano.pai = id;
		posso = false;	
	}
	//destruindo o dano
	if (dano != noone && image_index >= _image_index_max){
		instance_destroy(dano);
		dano = noone;
	}
}