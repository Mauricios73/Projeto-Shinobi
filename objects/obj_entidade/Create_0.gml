// obj_entidade - Begin Step

/// -----------------------------
/// State constants (int)
/// -----------------------------
#macro PST_IDLE        0
#macro PST_RUN         1
#macro PST_JUMP        2
#macro PST_DASH        3
#macro PST_DASH_AIR    4
#macro PST_ATK         5
#macro PST_ATK_AIR     6
#macro PST_HIT         7
#macro PST_DEAD        8
#macro PST_CHAKRA      9
#macro PST_FIRE        10
#macro PST_CHIDORI     11
#macro PST_CROUCH      12 // <- NOVO: Estado de agachar
#macro PST_ROLL        13 // <- NOVO: Estado de Rolar/Deslizar
#macro PST_WALL        14 // <- NOVO: Estado de Parede
#macro PST_DEFEND      15 // <- NOVO: Estado de Defesa
#macro PST_GROUND_SLAM 16 // <- NOVO: Estado de mergulho/Ground Slam

delay = 0;

invencivel = false;

vida_max= 1;
vida_atual = vida_max;

velh = 0;
velv = 0;
mid_velh = 0; 

max_velh = 1;
max_velv = 1;

massa = 1;
ataque = 1;

xscale = 1;

mostra_estado = false;
img_spd = 35;

estado = "parado";