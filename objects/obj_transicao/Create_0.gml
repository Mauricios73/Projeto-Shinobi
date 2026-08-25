// =====================================================================
// Arquivo / Objeto: obj_transicao
// Evento: Create
// =====================================================================

alpha = 0;
mudei = false;

ja_trocou = false;
persistent = true;

// destino precisa existir como variável (vai ser setado pelo sensor)
//destino = noone;

// --- NOVO: spawn por lado (robusto) ---
spawn_side = "none";    // "left" | "right" | "none"
spawn_margin = 64;      // distância da borda

// Variáveis para receber a posição exata
target_x = -1;
target_y = -1;            // Y que vem do sensor (ex: obj_player.y)
