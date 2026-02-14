dano = 0;
pai = noone;

morrer = false;

persistente = false;   // ataques normais
tick_frames = 6;       // usado só se persistente
max_hits_por_alvo = -1;

skill_id = ""; // vazio = ataque normal (sem XP de skill)
xp_lock = ds_map_create(); // key: skill_id + "_" + alvo.id -> true


tick_map = ds_map_create();
hits_map = ds_map_create();
