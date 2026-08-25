depth = -1000;

safe_top = 90;

rain_max = 420;
rain_active = rain_max;

// Inicializa os arrays no Create para que o Draw nunca leia uma variavel inexistente.
rx = array_create(rain_max, 0);
ry = array_create(rain_max, 0);
rv = array_create(rain_max, 0);
rl = array_create(rain_max, 0);
ra = array_create(rain_max, 0);
ph = array_create(rain_max, 0);

init = false;
gw = 0;
gh = 0;

wind_base = 1.2;
wind_amp = 1.4;
wind_speed = 0.00035;
