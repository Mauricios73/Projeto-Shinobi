// obj_entidade - Create

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
#macro PST_CROUCH      12
#macro PST_ROLL        13
#macro PST_WALL        14
#macro PST_DEFEND      15
#macro PST_GROUND_SLAM 16
#macro PST_POTION      17
#macro PST_SUMMON      18
#macro PST_TELEPORT_OUT 19
#macro PST_TELEPORT_IN  20

// Status
delay = 0;
invencivel = false;
hurt_invuln_frames = 12;
hurt_invuln_timer = 0;
vida_max = 10;
vida_atual = vida_max;
pstate = PST_IDLE;

// Fisica
velh = 0;
velv = 0;
mid_velh = 0;
max_velh = 1;
max_velv = 1;
massa = 1;
ataque = 1;
xscale = 1;

// Visual
mostra_estado = false;
img_spd = 35;
estado = "parado";

recebe_dano = function(_valor, _origem_x, _skill_id = "") {
    return scr_combat_receive_damage(id, _valor, _origem_x, _skill_id);
}
