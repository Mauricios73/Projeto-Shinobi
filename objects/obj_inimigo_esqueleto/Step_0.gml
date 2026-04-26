// obj_inimigo_esqueleto - STEP EVENT
var chao = place_meeting(x, y + 1, obj_block);

//Aplicando GRAVIDADE
if (!chao){
		velv += GRAVIDADE * massa * global.vel_mult;
}

// No Step Event do obj_inimigo_esqueleto
if (pstate == PST_HIT && estado != "ataque") {
    estado = "hit";
}
	
switch(estado)
{
	#region parado
	case "parado":
	{
		velh = 0
		mid_velh = 0;
		timer_estado++;
		if (sprite_index != spr_skeleton_idle){
			image_index = 0;
			sprite_index = spr_skeleton_idle;
		}
		
		//indo para patrulha random
		if (irandom(timer_estado) > 300){
			estado = choose("movendo", "parado", "movendo");
			timer_estado = 0
		}
		scr_ataca_entidade(dist, image_xscale); // Agora ataca aliado também
		
		break;
	}
	#endregion
	
	#region movendo
case "movendo":
{
    timer_estado++;
    
    // Se não estiver com a sprite de walk, reseta e escolhe uma direção
    if (sprite_index != spr_skeleton_walk) {
        image_index = 0;
        sprite_index = spr_skeleton_walk;
        
        // Escolhe 1 (direita) ou -1 (esquerda) e guarda numa variável interna
        if (!variable_instance_exists(id, "direcao_patrulha")) direcao_patrulha = choose(1, -1);
        else direcao_patrulha = choose(1, -1);
    }
    
    // APLICA O MOVIMENTO REAL
    velh = direcao_patrulha * max_velh;
    
    // Inverte a direção se bater em uma parede (usando sua lógica de colisão)
    if (place_meeting(x + velh, y, obj_block)) {
        direcao_patrulha *= -1;
    }

    // Voltando para parado ou mudando patrulha
    if (irandom(timer_estado) > 300) {
        estado = choose("parado", "movendo", "parado");
        timer_estado = 0;
        velh = 0; // Para de mover ao trocar de estado
    }
    
    // Chame a nova função de ataque que criamos
    scr_ataca_entidade(dist, image_xscale);
    
    break;
}
#endregion
	
	#region ataque
	case "ataque":
	{
		atacando(spr_skeleton_attack, 8, 15, sprite_width/2, -sprite_height/3);
		
		break;
	}
	#endregion
	
 	#region hit
	case "hit":
	{
		delay = room_speed * 2;
		velh=0;
		mid_velh = 0;
		
		if (sprite_index != spr_skeleton_hit)
		{
			image_index = 0;
			sprite_index = spr_skeleton_hit;
			}
			
			if (vida_atual > 0)
			{
				if (image_index > image_number -1)
				{
					estado = "parado";
					mid_velh = 0;
				}
			}
			else 
			{
				if (image_index >= 3){
					estado = "dead";
			}
		}		
		break;
	}
	#endregion
	
	#region dead
	case "dead":
	{
		mid_velh = 0;
		velh =0;
		
		if (sprite_index != spr_skeleton_dead){
			image_index = 0;
			sprite_index = spr_skeleton_dead;
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
