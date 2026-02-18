// Tamanho do lago (retângulo)
w = 1520;
h = 180;

// Se quiser que x,y sejam o TOPO-ESQUERDA do lago, deixe assim.
// Se quiser x,y como centro, use: left = x - w/2; top = y - h/2; (no Draw)
reflect_alpha = 0.45; //0.40
	
// Ondas (distorção do reflexo)
wave_amp   = 1.6;
wave_freq  = 0.10;
wave_speed = 0.0032;
slice_h    = 2;      // altura de cada “fatia” (2 fica bem pixel art)

// Surface do reflexo
surf_reflect = -1;

// Espuma (pixels brancos)
foam_n     = 200; //160
foam_x     = array_create(foam_n);
foam_y     = array_create(foam_n);
foam_spd   = array_create(foam_n);
foam_phase = array_create(foam_n);

for (var i = 0; i < foam_n; i++)
{
    foam_x[i]     = random(w);
    foam_y[i]     = random(h);
    foam_spd[i]   = random_range(0.2, 0.9);
    foam_phase[i] = irandom(100000);
}
