/// ========================================================
/// obj_environment_fx - CREATE
/// FASE 4.2
/// Relâmpago + Iluminação Localizada + Atmosfera
/// ========================================================

persistent = true;
depth = -5000;

fx_enabled = true;


// ========================================================
// ILUMINAÇÃO GLOBAL
// ========================================================

ambient_alpha = 0;
ambient_target = 0;

darkness_alpha = 0;
darkness_target = 0;


// ========================================================
// ATMOSFERA
// ========================================================

fog_alpha = 0;
fog_target = 0;

atmosphere_alpha = 0;
atmosphere_target = 0;


// ========================================================
// RELÂMPAGO
// ========================================================

lightning_timer = random_range(8, 18);

lightning_active = false;
lightning_phase = 0;

lightning_alpha = 0;
lightning_strength = 0;

lightning_count = 0;


// ========================================================
// POSIÇÃO DO RELÂMPAGO
// ========================================================

lightning_x = 0;
lightning_y = 0;

lightning_radius = 0;
lightning_radius_target = 0;

lightning_core_alpha = 0;
lightning_halo_alpha = 0;


// ========================================================
// TROVÃO
// ========================================================

thunder_pending = false;
thunder_timer = 0;
thunder_strength = 0;


// ========================================================
// CONFIGURAÇÕES
// ========================================================

lightning_min_time = 7;
lightning_max_time = 20;

thunder_min_delay = 0.25;
thunder_max_delay = 1.80;


// ========================================================
// CONFIGURAÇÕES DE ATMOSFERA
// ========================================================

fog_min_alpha = 0.02;
fog_max_alpha = 0.12;

storm_atmosphere = 0;


// ========================================================
// ESTADO GLOBAL
// ========================================================

if (!variable_global_exists("environment"))
{
    global.environment = {};
}

global.environment.visual = {
    ambient_alpha: 0,
    darkness_alpha: 0,
    fog_alpha: 0,
    lightning: 0,
    lightning_x: 0,
    lightning_y: 0,
    lightning_radius: 0,
    lightning_count: 0
};

// ========================================================
// COLOR GRADING
// ========================================================

color_r = 1;
color_g = 1;
color_b = 1;

target_color_r = 1;
target_color_g = 1;
target_color_b = 1;

color_alpha = 0;
target_color_alpha = 0;

color_transition_speed = 0.025;