/// ========================================================
/// OBJ_FOG
/// FASE 4.6 - ATMOSFERA AVANÇADA
/// ========================================================

depth = -2000;


// ========================================================
// CONFIGURAÇÃO VISUAL
// ========================================================

fog_speed  = 0.0008;
fog_layers = 4;


// ========================================================
// DIMENSÕES DA INTERFACE
// ========================================================

guiW = display_get_gui_width();
guiH = display_get_gui_height();


// ========================================================
// SURFACE DO FOG
// ========================================================

surf_fog = -1;

if (guiW > 0 && guiH > 0)
{
    surf_fog =
        surface_create(
            guiW,
            guiH
        );
}


// ========================================================
// SISTEMA DE PARTÍCULAS
// ========================================================

fog_sys =
    part_system_create();

part_system_depth(
    fog_sys,
    depth
);


// ========================================================
// TIPO DE PARTÍCULA
// ========================================================

fog_type =
    part_type_create();


// Forma nativa de nuvem
part_type_shape(
    fog_type,
    pt_shape_cloud
);


// Tamanho
part_type_size(
    fog_type,
    1.5,
    3.0,
    0,
    0.02
);


// Escala horizontal
part_type_scale(
    fog_type,
    2.0,
    0.5
);


// Alpha
part_type_alpha3(
    fog_type,
    0,
    0.88,
    0
);


// Cor
part_type_color1(
    fog_type,
    c_white
);


// Movimento
part_type_speed(
    fog_type,
    0.1,
    0.3,
    0,
    0
);


part_type_direction(
    fog_type,
    0,
    10,
    0,
    2
);


// Vida
part_type_life(
    fog_type,
    400,
    700
);


// ========================================================
// EMISSOR
// ========================================================

fog_emit =
    part_emitter_create(
        fog_sys
    );


// ========================================================
// ESTADO
// ========================================================

is_fading_out = false;


// ========================================================
// FASE 4.6
// ATMOSFERA AVANÇADA
// ========================================================

atmosphere_enabled = true;


// Intensidade
atmosphere_amount = 0;
atmosphere_target = 0;


// Haze
haze_amount = 0;
haze_target = 0;


// Profundidade
depth_amount = 0;
depth_target = 0;


// Velocidade
atmosphere_speed = 0.025;


// Tempo interno
atmosphere_time =
    random(1000);