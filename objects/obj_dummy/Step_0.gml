var chao = place_meeting(x, y + 1, obj_block);

//Aplicando GRAVIDADE
if (!chao){
		velv += GRAVIDADE;
}

switch(estado)
{
	#region parado
	case "parado":
	{
		if (sprite_index != spr_dummy_idle){
			sprite_index = spr_dummy_idle;
		}
		break;
	}
	#endregion
	
 	#region hit
	case "hit":
	{
	    sprite_index = sprites_hit[hit_index]; // Usa o índice sorteado pelo obj_dano
	    if (image_index >= image_number - 1) {
	        estado = "parado";
	    }
		break;
	}
	#endregion
}

