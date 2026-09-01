/// ========================================================
/// obj_particle_system - CREATE
/// FASE 4.4 - SISTEMA DE PARTÍCULAS GENÉRICO
/// ========================================================

persistent = true;
depth = -4000;

particle_system_enabled = true;


/// ========================================================
/// TIPOS DE PARTÍCULA
/// ========================================================

PARTICLE_DUST   = 0;
PARTICLE_LEAF   = 1;
PARTICLE_SPARK  = 2;
PARTICLE_SMOKE  = 3;
PARTICLE_ASH    = 4;
PARTICLE_SPLASH = 5;
PARTICLE_IMPACT = 6;
PARTICLE_FOG    = 7;

// ========================================================
// LISTA DE PARTÍCULAS
// ========================================================

particles = [];

particle_count = 0;

// ========================================================
// AMBIENTE
// ========================================================

environment_enabled = true;

automatic_particles = true;

// ========================================================
// SISTEMA DE VENTO
// ========================================================

// Vento atual utilizado pelas partículas.
wind = 0;

// Vento alvo.
// O sistema não muda instantaneamente:
// ele faz uma transição suave.
wind_target = 0;

// Intensidade base do vento.
wind_base = 5;

// Oscilação natural do vento.
wind_noise = 0;

// Fase usada para a variação natural.
wind_phase = random(1000);

// Velocidade da variação natural.
wind_noise_speed = 0.75;

// ========================================================
// RAJADAS
// ========================================================

wind_gust_active = false;

wind_gust_strength = 0;
wind_gust_target = 0;

wind_gust_timer = 0;
wind_gust_duration = 0;

wind_gust_min = 20;
wind_gust_max = 40;

// Próxima rajada em clima normal.
wind_gust_next = random_range(4, 10);

// ========================================================
// CLIMA
// ========================================================

weather = 0;
weather_intensity = 0;

environment_timer = 0;


// ========================================================
// LIMITE DE SEGURANÇA
// ========================================================

particle_max = 500;


// ========================================================
// ESTADO GLOBAL
// ========================================================

if (!variable_global_exists("particle"))
{
    global.particle = {};
}

global.particle = {
    enabled: true,
    count: 0,
    max: particle_max
};

if (!variable_global_exists("wind"))
{
    global.wind = {};
}

global.wind = {
    enabled: true,
    current: 0,
    target: 0,
    gust: false,
    gust_strength: 0
};