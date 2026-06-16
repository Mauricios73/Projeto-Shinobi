if (!variable_global_exists("snow_amount") || global.snow_amount <= 0) exit;

var cam = view_camera[0];
var camx = camera_get_view_x(cam);
var camy = camera_get_view_y(cam);
var camw = camera_get_view_width(cam);
var camh = camera_get_view_height(cam);

// 1. Descobrir onde a linha d'água base está no mundo real (camy + altura da tela)
var target_ratio_y = camh * 0.52;
if (instance_exists(obj_env)) {
    target_ratio_y = camh * obj_env.ground_cut_ratio;
}
var lago_base_y = camy + target_ratio_y;

var max_snow_height = 14; 
var total_h = global.snow_amount * max_snow_height;

gpu_set_blendmode(bm_normal);

// ====================================================
// PARTE A: ACÚMULOS FLUTUANTES (DESLIZANDO NO MUNDO)
// ====================================================
var final_lake_y = lago_base_y + lake_offset_y;

// Margem extra para a neve entrar/sair da tela suavemente (loop invisível)
var margin = 150; 
var wrap_w = camw + margin * 2;
var start_x = camx - margin;

for (var i = 0; i < num_patches; i++)
{
    var rel_x = (patch_world_x[i] - start_x) mod wrap_w;
    if (rel_x < 0) rel_x += wrap_w; 
    
    var px = start_x + rel_x; 
    
    var water_bob = sin(current_time * 0.0015 + patch_phase[i]) * 1.5;
    var py = final_lake_y + patch_lane_y[i] + water_bob;
    
    var p_width = patch_size[i] * global.snow_amount;
    var p_height = (patch_size[i] * 0.18) * global.snow_amount; 
    
    if (p_width > 2)
    {
        // 100% Sólido para bloquear a cor escura da água
        draw_set_alpha(1.0); 
        
        // 1) CAMADA DE BAIXO: Sombra de gelo (um branco azulado 1 pixel para baixo)
        draw_set_color(make_color_rgb(200, 220, 255));
        draw_ellipse(px - p_width, py - p_height + 1, px + p_width, py + p_height + 1, false);
        
        // 2) CAMADA DE CIMA: Neve pura brilhante
        draw_set_color(c_white);
        draw_ellipse(px - p_width, py - p_height, px + p_width, py + p_height, false);
    }
}

// ====================================================
// PARTE B: ACÚMULO SÓLIDO (PRESO AO CHÃO DO MUNDO)
// ====================================================
var final_ground_y = lago_base_y + ground_offset_y;

// Base sólida da neve (retângulo base)
draw_set_alpha(0.3 + global.snow_amount * 0.5);
draw_set_color(c_white);
draw_rectangle(camx, final_ground_y - total_h, camx + camw, final_ground_y, false);

// Camada irregular superior do chão
draw_set_alpha(0.85);

// Para garantir que a textura da neve não deslize quando a câmera mover, 
// ancoramos o ponto de desenho aos múltiplos de 4 no mundo real:
var grid_start_x = floor(camx / 4) * 4;
var grid_end_x = camx + camw + 4;

for (var xx = grid_start_x; xx < grid_end_x; xx += 4)
{
    // Ao usar a coordenada real 'xx' no seno, o formato da neve "cola" no cenário!
    var offset = sin(xx * 0.06 + current_time * 0.0004) * (1 + global.snow_amount * 2.5);
    var snow_layer_y = final_ground_y - total_h + offset; 

    draw_rectangle(xx, snow_layer_y, xx + 4, final_ground_y, false);
}

// Restaura os padrões do GameMaker
draw_set_alpha(1);