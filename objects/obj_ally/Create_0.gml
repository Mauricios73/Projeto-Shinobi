// obj_ally - CREATE EVENT

event_inherited(); // Inicializa variáveis da entidade (vida, velh, velv, etc)

// --- Identidade e Vida ---
vida_max = 2;
vida_atual = vida_max;
dano_aliado = 1;
timer_vida = room_speed * 15;

// --- Física e Movimentação ---
max_velh = 2.5;
max_velv = 8;
grav = 0.3;
jump_force = -7;
vel_persegue = 2.5;
jump_cooldown = 0;

// --- Estados e IA ---
estado = "spawn";
pstate = PST_IDLE;
alvo = noone;
pode_atacar = true;

// --- Distâncias Táticas ---
distancia_seguir = 80;
dist_ataque = 40;
dist_parar = 35;
dist_perder_alvo = 350;
dist_teleporte = 500;

sprite_index = spr_summon_ally;
image_index = 0;