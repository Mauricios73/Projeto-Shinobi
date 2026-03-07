dano = 0;
pai = noone;

morrer = false;

persistente = false;   // ataques normais
tick_frames = 6;       // usado só se persistente
max_hits_por_alvo = -1;
range = 0; // 0=point, >0=rectangle half-size

skill_id = ""; // vazio = ataque normal (sem XP de skill)
xp_lock = ds_map_create(); // key: skill_id + "_" + alvo.id -> true

life = 999999;   // padrão infinito (ou grande)

tick_map = ds_map_create();
hits_map = ds_map_create();
