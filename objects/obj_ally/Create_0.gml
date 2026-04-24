/*// obj_ally - CREATE EVENT
event_inherited();

estado = "spawn";
sprite_index = spr_summon_ally; // A animação de 7 frames que você mencionou
image_index = 0;
image_speed = 1;

// Atributos de combate
vida_aliado = 15;
dano_aliado = 1;
vel_persegue = 2.5;

// Atributos de existência
tempo_vida = room_speed * 15; // 15 segundos de duração
timer_vida = tempo_vida;

// Estado da IA
// Variáveis de decisão (IA simples)
alvo = noone;
distancia_seguir = 80;
dist_ataque = 40; // Distância para começar a bater
dist_parar = 30;  // Distância para parar de andar e bater

dist_perder_alvo = 300; // Se o inimigo fugir demais, o aliado desiste
pode_atacar = true;     // Cooldown para não dar dano em todo frame

vida_max = 15;
vida_atual = vida_max;
max_velh = 2.5; 
max_velv = 8;
massa = 0.8; // Um pouco mais leve que o player talvez?

estado = "spawn";
pstate = PST_IDLE; // Usando as macros da entidade*/

event_inherited(); // Inicializa variáveis da entidade (vida, velh, velv, etc)

// --- Identidade e Vida ---
vida_max = 15;
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