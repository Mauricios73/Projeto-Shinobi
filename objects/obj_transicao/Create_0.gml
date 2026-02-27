alpha = 0;
mudei = false;

ja_trocou = false;
persistent = true;

// destino precisa existir como variável (vai ser setado pelo sensor)
destino = noone;

// --- NOVO: spawn por lado (robusto) ---
spawn_side = "none";    // "left" | "right" | "none"
spawn_margin = 64;      // distância da borda

keep_y = false;         // manter Y do player?
spawn_y = 0;            // Y que vem do sensor (ex: obj_player.y)