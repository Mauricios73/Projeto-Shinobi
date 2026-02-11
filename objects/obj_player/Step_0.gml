//checando se obj transição existe
if (instance_exists(obj_transicao)) exit;

if (invencivel && tempo_invencivel > 0)
{
	tempo_invencivel --;
	image_alpha= max(sin(get_timer()/50000), 0.2);
}
else
{
	invencivel = false;
	image_alpha=1;
}
//Iniciando variaveis
var chao = place_meeting(x, y + 1, obj_block);
var right, left, jump, attack, dash, dashatk;

//controles
// Teclado
right		= keyboard_check(ord("D"));
left		= keyboard_check(ord("A"));
jump		= keyboard_check_pressed(ord("W"));
attack		= keyboard_check_pressed(ord("K"));
dash		= keyboard_check_pressed(ord("L"));
dashatk		= keyboard_check_pressed(ord("J"));

// Joystick (id = 0 para o primeiro controle)
if (gamepad_is_connected(0)) {
    var axis_h = gamepad_axis_value(0, gp_axislh); // analógico esquerdo horizontal
    var axis_v = gamepad_axis_value(0, gp_axislv); // analógico esquerdo vertical    
    // movimento horizontal
    if (axis_h > 0.3) right = 1;
    if (axis_h < -0.3) left = 1;
    // pulo (botão A)
    if (gamepad_button_check_pressed(0, gp_face1)) jump = true;
    // ataque (botão X)
    if (gamepad_button_check_pressed(0, gp_face2)) attack = true;
    // dash (botão B)
    if (gamepad_button_check_pressed(0, gp_face3)) dash = true;
}

//Codigo de movimentação 
velh = (right - left) * max_velh * global.vel_mult;

if (dash_timer > 0)dash_timer--;

//iniciando a maquina de estados
switch(estado){
	 
	#region parado
	case "parado":
	{
		if (chao) dash_aereo = true;
		//comportamento do estado
		sprite_index = spr_player_idle;
		
		//troca de estado
		if (velh != 0){
			estado = "movendo";
		}
		else if (jump || !chao)
		{
			estado = "pulando";
			velv = (-max_velv * jump); 
			image_index = 0;
		}
		else if (attack)
		{
			inicia_ataque(chao);
		}
		else if (dash && dash_timer <= 0)
		{
			
			estado = "dash";
			image_index = 0;
			
		}
		else if (dashatk && global.power_ups[0])
		{
			estado = "dashatk";
			image_index = 0;
			
		}
		break;
	}
	#endregion	
	
	#region movendo
	case "movendo":
	{
		sprite_index = spr_player_run;
		
		if (abs(velh) < .1){
			estado = "parado";
			velh = 0;
		}
		else if (jump || !chao)
		{
			estado = "pulando";
			velv = (-max_velv * jump); 
			image_index = 0;
		}
		else if (attack)
		{
			inicia_ataque(chao);
		}
		else if (dash && dash_timer <= 0)
		{
			estado = "dash";
			image_index = 0;
		}
		else if (dashatk && global.power_ups[0])
		{
			estado = "dashatk";
			image_index = 0;
		}
		
		break;
	}
	#endregion
	
 	#region pulando
	case "pulando":
	{
		aplica_gravidade(); 
		//caindo
		if (velv > 0)
		{
			sprite_index = spr_player_fall;
		}
		else
		{
			sprite_index = spr_player_jump;
			
		}
		if (attack)
		{
			inicia_ataque(chao);
		}
		
		else if (chao)
		{
			//screenshake(8, true, 270);
			estado = "parado";
			mid_velh = 0;
		}
		else if (dash && dash_aereo == true)
		{
			estado = "dash aereo";
		}
		else if (dashatk && global.power_ups[0])
		{
			estado = "dashatk";
		}
		break;
	}
	#endregion
	
	#region ataque
	case "ataque":
	{
		velh = 0;
		
		if (combo == 0){
			sprite_index = spr_player_ataque1;
		}
		else if (combo == 1){
			sprite_index = spr_player_ataque2;
		}
		else if (combo == 2){
			sprite_index = spr_player_ataque3;
		}
	
		// criando dado
		if (image_index >= 1 && dano == noone && posso){
			dano = instance_create_layer(x + sprite_width/6, y - sprite_height/9, layer, obj_dano);
			dano.dano = ataque * ataque_mult;
			dano.pai = id;
			posso = false;
			
		}
		
		if (attack && combo < 2 && image_index >= image_number -4){
			combo ++;
			image_index = 0;
			posso = true;
			ataque_mult++;
			if (dano){
				instance_destroy(dano, false);
				dano = noone;
			}
		}
		
		//saindo do estado
		if (image_index > image_number -1){
			estado = "parado";
			velh = 0;
			combo = 0;  
			ataque_mult = 1;
			finaliza_ataque()
		}
		if (dash && dash_timer <= 0)
		{
			estado = "dash";
			image_index = 0;
			combo = 0;
			if (dano){
				instance_destroy(dano, false);
				dano = noone;
			}
		}
		if (velv != 0)
		{
			estado = "pulando";
			image_index = 0;
		}
		
		break;
	}
	#endregion
	
	#region ataque aereo
	case "ataque aereo":
	{
		aplica_gravidade();
		if (sprite_index != spr_player_ataque2)
		{
			sprite_index = spr_player_ataque2;		 
			image_index = 0;
		}
		
		// criando dado
		if (image_index >= 1 && dano == noone && posso){
			dano = instance_create_layer(x + sprite_width/6, y - sprite_height/9, layer, obj_dano);
			dano.dano = ataque;
			dano.pai = id;
			posso = false;
		}
		
		if (image_index >= image_number -1)
		{
			estado = "pulando";
			finaliza_ataque()
		}		
		if (chao)
		{
			estado = "parado";
			aaposso = true;
			if (dano){
				instance_destroy(dano, false);
				dano = noone;
			}
		}
		break;
	}
	
	#endregion
	
	#region dash ataque
	case "dashatk":
	{
		aplica_gravidade();
		if (sprite_index != spr_player_dash_ataque)
		 {
			 sprite_index = spr_player_dash_ataque;
			 image_index = 0;
		 }
		 
		dano = instance_create_layer(x + sprite_width/6, y - sprite_height/6, layer, obj_dano);
		dano.pai = id;
		dano.dano = ataque;
		dano.morrer = false;
		posso = false;
				 
		 //velocidade
		 mid_velh = image_xscale * dash_vel_ataque;
		 
		if (image_index >= image_number -1){
			image_index = image_number -1;
			estado = "parado";
			mid_velh = 0;
			finaliza_ataque();
		 }
		break;
	}
	#endregion
	
	#region dash
	case "dash":
	{
		if (sprite_index != spr_player_dash)
		{
			 sprite_index = spr_player_dash;
			 image_index = 0;
		}
		
		mid_velh = image_xscale * dash_vel;
		 
		if (image_index >= image_number -1 ){
			estado = "parado";
			mid_velh = 0;
			dash_timer = dash_delay;
		}		 
		break;
	}	 
	#endregion
	
	#region dash aereo
	case "dash aereo":
	{
		velv = 0;
		velh = 0;
		dash_aereo = false;
		if (sprite_index != spr_player_dash_aereo)
		 {
			 sprite_index = spr_player_dash_aereo;
			 image_index = 0;
			 dash_aereo_timer = room_speed / 2 ;
		}
		mid_velh = image_xscale * dash_vel_aereo;
		dash_aereo_timer--;
		
		//if (dash_aereo_timer <= 0){
		if (image_index >= image_number -1 || dash_aereo_timer <= 0){
			estado = "parado";
		}
		break;
	}
	#endregion
	
	#region hit
	case "hit":
	{
		if (sprite_index != spr_player_hit)
		{
			sprite_index = spr_player_hit;		 
			image_index = 0;
			screenshake(3);
			
			invencivel = true;
			tempo_invencivel = invencivel_timer;	
		}
		velh = 0;
		
		if (vida_atual > 0)
		{
			if (image_index >= image_number -1){
				 estado = "parado";
			 }
		}
		else
		{
			if (image_index >= image_number -1){
				 estado = "dead";
			 }
		}
		break;
	}
	#endregion
	
	#region dead
	case "dead":
	{
		//checando controlador
		if (instance_exists(obj_game_controller)){
			with(obj_game_controller){
				game_over = true;
			}
		}
		
		velh = 0;
		if (sprite_index != spr_player_death)
		{
			sprite_index = spr_player_death;		 
			image_index = 0;
		}
		
		if (image_index >= image_number -1)
		{
			image_index = image_number -1;
		}		
		break;
	}
	#endregion
	
	default:
	{
		estado = "parado";
	}
}

if (keyboard_check(vk_enter)) game_restart();
