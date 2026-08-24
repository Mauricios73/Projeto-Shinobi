// obj_inimigo - Create
event_inherited();

alvo = noone;
dist = 99999;
tipo_ataque = "";

// Atributos base
vida_max_base = 30;
ataque_base = 1;

var hp_mult = variable_global_exists("enemy_hp_mult") ? global.enemy_hp_mult : 1;
var dmg_mult = variable_global_exists("enemy_dmg_mult") ? global.enemy_dmg_mult : 1;

vida_max = vida_max_base * hp_mult;
vida_atual = vida_max;
ataque = ataque_base * dmg_mult;

max_velh = 2;
dist_visao = 500;
dist_ataque = 30;
dist_patrulha = 120;

patrol_origin_x = x;
patrol_dir = choose(-1, 1);

timer_reacao = 0;
pode_atacar = true;

enemy_state_enter("idle");
