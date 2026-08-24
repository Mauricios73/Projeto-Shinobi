var chao = place_meeting(x, y + 1, obj_block);

velh = 0;
mid_velh = 0;

//Aplicando GRAVIDADE
if (!chao){
		velv += GRAVIDADE;
}

switch(estado)
{
	#region parado
	case "parado":
	{
		velh = 0
		if (sprite_index != spr_dummy_idle){
			sprite_index = spr_dummy_idle;
		}
		break;
	}
	#endregion
	
 	#region hit
	case "hit":
	{
		velh = 0
	    sprite_index = sprites_hit[hit_index]; // Usa o índice sorteado pelo obj_dano
	    if (image_index >= image_number - 1) {
	        estado = "parado";
	        pstate = PST_IDLE;
	        image_index = 0;
	    }
		break;
	}
	#endregion
}

