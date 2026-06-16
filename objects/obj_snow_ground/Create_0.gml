//obj_snow_groud - create

depth = -16100; // Acima da água do lago

// ====================================================
// CONFIGURAÇÃO DE ALTURA (AJUSTE AQUI!)
// ====================================================
ground_offset_y = 94;  
lake_offset_y   = 155;  

// ====================================================
// CONFIGURAÇÃO DA NEVE FLUTUANTE (LAGO)
// ====================================================
num_patches = 16; // Quantidade de placas de neve
patch_world_x = array_create(num_patches);
patch_size    = array_create(num_patches);
patch_phase   = array_create(num_patches);
patch_spd     = array_create(num_patches);
patch_lane_y  = array_create(num_patches);

// Escolhe aleatoriamente se o lago terá 2 ou 3 "linhas/raias" de neve flutuante
var num_linhas = choose(3, 6);

for (var i = 0; i < num_patches; i++)
{
    // Posição inicial solta no mundo do jogo
    patch_world_x[i] = random(10000); 
    patch_size[i] = random_range(16, 40); 
    patch_phase[i] = random(100); 
    
    // Velocidade orgânica para deslizar à direita (cada placa tem uma velocidade)
    patch_spd[i] = random_range(0.1, 0.35); 
    
    // Distribui as placas nas "linhas" verticais do lago (afasta elas por 6 pixels em Y)
    var linha_atual = irandom(num_linhas - 1);
    patch_lane_y[i] = linha_atual * 6; 
}
