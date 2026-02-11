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
		if (sprite_index != spr_dummy_hit2){
			image_index = 0;
			sprite_index = spr_dummy_hit2;
		}
		if (image_index > image_number -1){
				estado = "parado";
				mid_velh = 0;
			}
			/*if (vida_atual > 0)
			{
				if (image_index > image_number -1)
				{
					estado = "parado";
					mid_velh = 0;
				}
			}*/
		break;
	}
	#endregion
}

