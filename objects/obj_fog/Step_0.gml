

// Pegar a câmera atual e suas posições no mundo
var cam = view_camera[0];
var camx = camera_get_view_x(cam);
var camy = camera_get_view_y(cam); // <- Importante: pegando o Y da câmera
var camw = camera_get_view_width(cam);
var camh = camera_get_view_height(cam);

// 1) Calcula a porcentagem da tela onde fica o horizonte
var target_ratio_y = camh * 0.52; 
if (instance_exists(obj_env)) {
    target_ratio_y = camh * obj_env.ground_cut_ratio;
}

// 2) Converte para a coordenada REAL do mapa somando o camy
var lago_y = camy + target_ratio_y;

// 3) AJUSTE FINO (Mude esse valor se quiser subir ou descer a névoa no lago)
// Valores negativos sobem a névoa, valores positivos descem
var offset_ajuste = 250; 
lago_y += offset_ajuste;

// Se o Weather Manager desligar o fog, ativa o fade out
if (instance_exists(obj_weather_manager)) {
    if (!obj_weather_manager.fog_on) {
        is_fading_out = true;
    }
}

if (!is_fading_out) {
    // Agora os limites verticais (Y) usam a posição real do lago no mundo
    var y_min = lago_y - 115; // Limite superior da faixa de névoa
    var y_max = lago_y + 5;  // Limite inferior (onde toca na água)
    
    part_emitter_region(fog_sys, fog_emit, camx - 200, camx + camw + 200, y_min, y_max, ps_shape_rectangle, ps_distr_linear);
    
    // Solta as nuvens
    if (irandom(15) == 0) {
        part_emitter_burst(fog_sys, fog_emit, fog_type, irandom_range(1, 2));
    }
} else {
    if (part_particles_count(fog_sys) == 0) {
        instance_destroy();
    }
}