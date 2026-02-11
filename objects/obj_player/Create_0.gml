// Inherit the parent event
var cam = instance_create_layer(x, y, layer, obj_camera);
cam.alvo = id;

randomise();

event_inherited();

vida_max = 1;
vida_atual = vida_max;

max_velh = 4;
max_velv = 8; 
dash_vel = 20
dash_vel_aereo = 10;
dash_vel_ataque = 30;

dash_aereo_timer = 0;
dash_aereo = true;
dash_delay = 30;
dash_timer = 0;

mostra_estado = true;

combo = 0;
dano = noone;
ataque = 1;
posso = true; 
ataque_mult = 1;
ataque_dash = false;

//controle dos power ups
global.power_ups = [false];

invencivel = false;	
invencivel_timer = room_speed * 3;
tempo_invencivel = invencivel_timer;

//metodo para iniciar ataque
inicia_ataque = function(chao){
	if (chao){
		estado = "ataque";
		velh = 0;
		image_index = 0;
	}
	else
	{
		estado = "ataque aereo";
		image_index = 0;
	}
}

finaliza_ataque = function(){
	posso = true;
	if (dano){
		instance_destroy(dano, false);
		dano = noone;
	}
}

//gravidade
aplica_gravidade = function(){
	var chao = place_meeting(x, y + 1, obj_block);
	//Aplicando GRAVIDADE
	if (!chao){
		if (velv < max_velv * 2){
			velv += GRAVIDADE * massa * global.vel_mult;
		}
	}
}