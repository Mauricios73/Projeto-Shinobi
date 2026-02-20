depth = -1000;

// --------------------
// TAMANHO DO LAGO
// --------------------
w = 1362;
h = 330;

reflect_alpha = 0.55;

// --------------------
// ONDAS
// --------------------
wave_amp   = 10.2;
wave_speed = 0.0022;
slice_h    = 1;

wave_base_amp = 2.8;
wave_storm_amp = 5.5;

current_wave_amp = wave_base_amp;


// Surface do reflexo
surf_reflect = -1;

// --------------------
// ESPUMA
// --------------------
foam_n     = 600;

foam_x     = array_create(foam_n);
foam_y     = array_create(foam_n);
foam_spd   = array_create(foam_n);
foam_phase = array_create(foam_n);

// =============================
// RIPPLES DA CHUVA
// =============================
ripple_max = 40;
ripple_x   = array_create(ripple_max);
ripple_y   = array_create(ripple_max);
ripple_a   = array_create(ripple_max);
ripple_r   = array_create(ripple_max);

for (var i = 0; i < ripple_max; i++)
{
    ripple_a[i] = 0;
}


for (var i = 0; i < foam_n; i++)
{
    foam_x[i]     = random(w);
    foam_y[i]     = random(h);
    foam_spd[i]   = random_range(0.2, 0.9);
    foam_phase[i] = irandom(100000);
}
