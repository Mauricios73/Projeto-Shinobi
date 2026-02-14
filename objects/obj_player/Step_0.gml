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
var right, left, jump, attack, dash, chidori, fire, chakra;

//controles
// Teclado
right			= keyboard_check(global.key_right);
left			= keyboard_check(global.key_left);
jump			= keyboard_check(global.key_up);
attack			= keyboard_check_pressed(global.key_ataque);
dash			= keyboard_check_pressed(global.key_dash);
chidori			= keyboard_check_pressed(global.key_chidori);
chakra			= keyboard_check_pressed(global.key_chakra);
fire			= keyboard_check_pressed(global.key_fire);


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

// Regeneração
//if (estado != "fire_breath" || "chidori")
//{
//    energia = clamp(energia, 0, energia_max);

//}
#region inputs
// ==========================
// INPUT DE SKILLS
// ==========================
if (!instance_exists(skillc)) skillc = instance_find(obj_skill_controller, 0);
if (keyboard_check_pressed(global.key_fire) && instance_exists(skillc))
{
    if (skillc.can_use_fire(self))
    {
        skillc.start_fire(self);
        estado = "fire_breath";
    }
}

var sc = instance_find(obj_skill_controller, 0);
if (keyboard_check_pressed(global.key_chidori) && sc != noone)
{
    if (sc.chidori.unlocked && sc.chidori.energy_cost <= energia)
    {
        energia -= sc.chidori.energy_cost;
        energia = clamp(energia, 0, energia_max);

        estado = "chidori";
    }
}

if (keyboard_check(global.key_chakra))
{
    if (estado == "parado" || estado == "movendo")
    {
        estado = "chakra";
    }
}
else
{
    // soltou: se estava canalizando, volta
    if (estado == "chakra") estado = "parado";
}

#endregion

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
		else if (chidori && global.power_ups[0])
		{
			estado = "chidori";
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
		else if (chidori && global.power_ups[0])
		{
			estado = "chidori";
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
		else if (chidori && global.power_ups[0])
		{
			estado = "chidori";
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
			dano.persistente = false;
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
	
	#region fire breath
	case "fire_breath":
		{
		    velh = 0;

		    if (sprite_index != spr_player_jutsu)
		    {
		        sprite_index = spr_player_jutsu;
		        image_index = 0;
		        image_speed = 1;
		    }

		    // NÃO encerra pelo sprite do player.
		    // Quem encerra é o obj_skill_fire_breath quando a animação dele terminar.
    
		    // Segurança: se por algum motivo o fogo sumir, volta pro parado
		    if (!instance_exists(fire_instance))
		    {
		        var sc = instance_find(obj_skill_controller, 0);
		        if (sc != noone) sc.end_fire(self);
		        estado = "parado";
		    }
		}
		break;
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
			posso = true;
			if (dano){
				instance_destroy(dano, false);
				dano = noone;
			}
		}
		break;
	}
	
	#endregion

	#region chidori
	case "chidori":
{
    aplica_gravidade();
    if (sprite_index != spr_player_dash_ataque)
    {
        sprite_index = spr_player_dash_ataque;
        image_index = 0;
        hit_criado = false;
    }

    // 🔥 cria só no frame 2 (ajuste se quiser)
		if (floor(image_index) == 2 && !hit_criado)show_debug_message("CHIDORI HITBOX CRIADO: " + string(chidori_hit));

		{
		    var dir = image_xscale;

		    // cria na frente do player
		    chidori_hit = instance_create_layer(x + dir * 55, y - 42, layer, obj_dano);

		    chidori_hit.pai = id;
		    chidori_hit.persistente = false;
		    chidori_hit.skill_id = "chidori"; // ✅ XP vai pro chidori

		    // dano = base + bônus por level do chidori (puxando do controller)
		    var sc = instance_find(obj_skill_controller, 0);
		    var lv = 1;
		    var bonus_per_lv = 2;

		    if (sc != noone) {
		        lv = sc.chidori.level;
		        bonus_per_lv = sc.chidori.dmg_bonus_per_level;
		    }

		    chidori_hit.dano = ataque + (lv - 1) * bonus_per_lv;
		    hit_criado = true;
		}
		    mid_velh = image_xscale * dash_vel_ataque;

		if (image_index >= image_number - 1)
			{
			    if (instance_exists(chidori_hit)) with (chidori_hit) instance_destroy();
			    chidori_hit = noone;

			    estado = "parado";
				velh = 0;
			    mid_velh = 0;
			    finaliza_ataque();
			}
		    break;
		}
	#endregion

	#region chakra
	case "chakra":
	{
		velh = 0; // fica parado canalizando

		// sprite de “preparação / concentração”
		if (sprite_index != spr_player_jutsu)
		{
		    sprite_index = spr_player_jutsu;
		    image_index = 0;
		    image_speed = 1;
		    chakra_timer = 0;
		}

		chakra_timer++;

		// após o delay, começa a regenerar
		if (chakra_timer >= chakra_delay)
		{
		    // regen por segundo (delta_time)
		    var dt = delta_time / 1000000; // segundos
		    energia += chakra_regen_rate * dt;
		    energia = clamp(energia, 0, energia_max);

		    // opcional: trocar sprite para “canalizando de verdade”
		    // if (sprite_index != spr_player_chakra_loop) sprite_index = spr_player_chakra_loop;
		}
		// se chegou ao máximo, pode encerrar automaticamente
		if (energia >= energia_max)
		{
		    energia = energia_max;
		    // continua canalizando se você quiser, ou volta:
		    // estado = "parado";
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
		mid_velh = 0;
		
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
