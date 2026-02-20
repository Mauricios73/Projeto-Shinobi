for (var i = 0; i < foam_n; i++)
{
    foam_x[i] += foam_spd[i];
    foam_y[i] += 0.02;

    if (foam_x[i] > w) foam_x[i] -= w;
    if (foam_y[i] > h) foam_y[i] -= h; 
}
// Atualiza ripples
for (var i = 0; i < ripple_max; i++)
{
    if (ripple_a[i] > 0)
    {
        ripple_r[i] += 0.8;
        ripple_a[i] -= 0.03;
    }
}
// =============================
// INTENSIDADE DA TEMPESTADE
// =============================
var storm_target = wave_base_amp;

if (instance_exists(obj_weather_manager))
{
    with (obj_weather_manager)
    {
        if (precip_mode == 2) // chuva
        {
            storm_target = other.wave_storm_amp;
        }
    }
}

// suaviza transição
current_wave_amp = lerp(current_wave_amp, storm_target, 0.02);
