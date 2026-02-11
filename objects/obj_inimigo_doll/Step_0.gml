var chao = place_meeting(x, y + 1, obj_block);

//Aplicando GRAVIDADE
if (!chao){
		velv += GRAVIDADE * massa * global.vel_mult;
}


switch(estado)
{
	#region parado
	case "parado":
	{
		velh = 0;
		mid_velh = 0;
		timer_estado++;
		if (sprite_index != spr_doll_idle){
			image_index = 0;
			sprite_index = spr_doll_idle;
		}
		
		//indo para patrulha random;
		if (irandom(timer_estado) > 200){
			estado = choose("movendo", "parado", "movendo");
			timer_estado = 0
		}
		scr_ataca_player(obj_player, dist, image_xscale);
		
		break;
	}
	#endregion
	
	#region movendo
	case "movendo":
	{
		timer_estado++;
		if (sprite_index != spr_doll_walk){
			image_index = 0;
			sprite_index = spr_doll_walk;
			mid_velh = choose(1, -1);
		}
		
		//indo para patrulha random
		if (irandom(timer_estado) > 200){
			estado = choose("parado", "movendo", "parado");
			timer_estado = 0;
		}
		scr_ataca_player(obj_player, dist, image_xscale);
		
		break;
	}
	#endregion
	
	#region ataque
	case "ataque":
	{
		atacando(spr_doll_attack, 2, 5, sprite_width/4, -sprite_height/3);	
		
		break;
	}
	#endregion
	
	#region hit
	case "hit":
	{
		delay = room_speed * 2;
		mid_velh = 0;
		velh =0;
		
		if (sprite_index != spr_doll_hit){
			image_index = 0;
			sprite_index = spr_doll_hit;
		}
		if (vida_atual > 0){
			if (image_index > image_number -1){
				estado = "parado";
			}
		}
		else 
		{
			if (image_index >= 0){
				estado = "dead";
			}
		}		
		break;
	}
	#endregion
	
	#region dead
	case "dead":
	{
		velh = 0;
		mid_velh = 0;
		
		if (sprite_index != spr_doll_dead){
			image_index = 0;
			sprite_index = spr_doll_dead;
		}
		
		if (image_index > image_number -1){
			image_speed = 0;
			image_alpha -= .01;
			if (image_alpha <= 0) instance_destroy();
		}
		break;
	
	}
	#endregion
}

if (delay > 0) delay--;
