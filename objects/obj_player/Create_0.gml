// Inherit the parent event
var cam = instance_create_layer(x, y, layer, obj_camera);
cam.alvo = id;

randomise();
event_inherited();

vida_max = 5;
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

on_ground = false;
was_on_ground = false;
// cooldown (opcional, mas recomendado)
chidori_cd = 0;
chidori_cd_max = room_speed * 0.35; // ~0.35s

// trava de uso no ar (1 por pulo)
chidori_aereo = true
mostra_estado = true;

fire_hit = noone;
fire_instance = noone;
fire_hitbox = noone;


energia_max = 1000;
energia_regen = 10;
energia = energia_max;
chakra_regen_rate = 18;      // por segundo (ajuste)
chakra_delay = room_speed * 1.5; // 1.5s antes de começar a regenerar

chakra_timer = 0;

skills = instance_find(obj_skill_controller, 0);
skillc = noone;

combo = 0;
dano = noone;
ataque = 1;
posso = true; 
ataque_mult = 1;
ataque_dash = false;
hit_criado = false;
chidori_criado = false;
hitbox_dash = noone;
chidori_hit = noone;

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