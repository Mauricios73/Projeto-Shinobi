/// ========================================================
/// OBJ_NEVE
/// FASE 4 - SISTEMA DE NEVE
/// ========================================================

depth = 100000;

// ========================================================
// CONFIGURAÇÃO
// ========================================================

snow_n = 240;
safe_top = 90;

// ========================================================
// ESTADO DE INICIALIZAÇÃO
// ========================================================

init = false;
gw = 0;
gh = 0;

// ========================================================
// ARRAYS DAS PARTÍCULAS
//
// Inicializados no Create para impedir que o Draw
// tente acessar arrays inexistentes no primeiro frame.
// ========================================================

sx  = array_create(snow_n, 0);
sy  = array_create(snow_n, 0);
sp  = array_create(snow_n, 0);
ss  = array_create(snow_n, 1);
sa  = array_create(snow_n, 0);
ph  = array_create(snow_n, 0);
lay = array_create(snow_n, 0);

// ========================================================
// VENTO
// ========================================================

wind_base  = 0.18;
wind_amp   = 0.35;
wind_speed = 0.00025;